//
//  AFHttpError.m
//  WRHB
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AFHttpError.h"
#import <SAMKeychain.h>
#import "AppDelegate.h"

@interface AFHttpError() <NSCopying,NSMutableCopying>

@end


static AFHttpError *_instance = nil;

@implementation AFHttpError


-(void)handleFailResponse:(id)object {
    if([object isKindOfClass:[NSError class]]){
        NSError *error = (NSError *)object;
        
        NSDictionary *errorInfo = error.userInfo;
        if ([errorInfo[@"NSLocalizedDescription"] isEqualToString:@"The request timed out."]) {
             [MBProgressHUD showErrorMessage:@"网络请求超时，请稍后重试"];
             NSLog(@"===== 超时 URL:🔴%@ =====", errorInfo[@"NSErrorFailingURLKey"]);
            return;
        }
        
        NSDictionary *yingError = [error.userInfo objectForKey:@"NSUnderlyingError"];
        if (yingError) {
            if([yingError isKindOfClass:[NSError class]]){
                [self showMessageError:object];
            } else {
                NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData: (NSData *)yingError options:kNilOptions error:nil];
                if (errorData) {
                    [self showMessageError:object];
                }
            }
        } else {
            [self showMessageError:object];
        }
    } else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *dd = (NSDictionary *)object;
        [self errorDataDict:dd];
    } else if([object isKindOfClass:[NSString class]]) {
        [MBProgressHUD showErrorMessage:object];
    } else {
        [MBProgressHUD hideHUD];
    }
    
}


- (void)showMessageError:(NSError *)error {
    NSDictionary *dic = error.userInfo;
    NSString *msg = @"服务器连接失败,请稍后再试";
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"错误原因:%@", dic[@"NSDebugDescription"]);
        msg = [dic objectForKey:@"NSDebugDescription"] == nil ? msg : [dic objectForKey:@"NSDebugDescription"];
        if ([msg isEqualToString:@"The Internet connection appears to be offline."]) {
            msg = @"请求失败，请检查网络设置";
        }
        
        if([dic[@"NSUnderlyingError"] isKindOfClass:[NSError class]]){
            [self showMessageError:dic[@"NSUnderlyingError"]];
            return;
        }
        
        if ([dic[@"com.alamofire.serialization.response.error.response"] isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *http = (NSHTTPURLResponse *)dic[@"com.alamofire.serialization.response.error.response"];
            NSInteger code = http.statusCode;
            NSLog(@"错误状态:%zd", code);
            if (code == 401) {
                // 内部重新登录
                [self action_login];
                return;
            } else if (code == 500) {
                msg = @"code=500 内部服务器错误，请稍后重试";
            } else if (code == 429) {
                NSLog(@"🔴🔴=========== code=429 太多请求 ===========🔴🔴");
                return;
            }
            
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: dic[@"com.alamofire.serialization.response.error.data"] options:kNilOptions error:nil];
            
            if([serializedData isKindOfClass:[NSDictionary class]]){
                if (code == 403 && [[serializedData objectForKey:@"code"] integerValue] == 1) {
                    msg = [serializedData objectForKey:@"msg"];
                } else if (code == 500) {
                    msg = @"内部服务器错误，请稍后重试-500";
                }
            }
            
        }
    }
    
    [MBProgressHUD showErrorMessage:msg];
}


//-(void)handleFailResponse:(id)object {
//    if([object isKindOfClass:[NSError class]]){
//        NSError *error = (NSError *)object;
//        NSDictionary *errdict = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
//        if (errdict) {
//            NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData: (NSData *)errdict options:kNilOptions error:nil];
//            if (errorData) {
//                [self errorDataDict:errorData];
//            } else {
//                NSLog(@"错误很多");
//                [self showError:object];
//            }
//        } else {
//            [self showError:object];
//        }
//    }else if([object isKindOfClass:[NSDictionary class]]){
//        NSDictionary *dd = (NSDictionary *)object;
//        [self errorDataDict:dd];
//    }else if([object isKindOfClass:[NSString class]])
//        [MBProgressHUD showErrorMessage:object];
//    else
//        [MBProgressHUD hideHUD];
//}

- (void)errorDataDict:(NSDictionary *)dict {
    
    if ([FunctionManager isEmpty:dict[@"message"]]) {
        [MBProgressHUD showTipMessageInWindow:@"登录超时 请退出重新登录"];
    }else{
        if ([dict[@"message"] isEqualToString:@"您的账号已在其他设备登录"]) {
            [self forcedOffline:@"您的账号已在其他设备登录"];
            return;
        } else if ([dict[@"message"] isEqualToString:@"请登录"]) {
            //                [self outLogin];
            return;
        }
        [MBProgressHUD showErrorMessage:dict[@"message"]];
    }
}




// 强制下线
- (void)forcedOffline:(NSString *)msg {
    
    dispatch_async(dispatch_get_main_queue(),^{
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate logOut];
        
        if (msg.length == 0) {
            return;
        }
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:msg button:@"确定" callBack:nil];
    });
}


#pragma mark -  重新登录 不让用户感觉
- (void)action_login {
    
    NSString *password = [SAMKeychain passwordForService:@"password" account:[AppModel sharedInstance].user_info.mobile];
    if (!password || password.length <= 0) {
        [self forcedOffline:nil];
        return;
    }
    NSDictionary *parameters = @{
                                 @"mobile":[AppModel sharedInstance].user_info.mobile,
                                 @"password":password,
                                 @"device_type":@"1"  // 设备类型 1 苹果 2 安卓
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"loginByMobile"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf updateUserInfo:response[@"data"]];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

/**
 更新用户信息
 */
-(void)updateUserInfo:(NSDictionary *)dict {
    AppModel *appModel = [AppModel mj_objectWithKeyValues:dict];
    
    [AppModel sharedInstance].token = appModel.token;
    [AppModel sharedInstance].user_info = appModel.user_info;
    [AppModel sharedInstance].assets = appModel.assets;
    
    [AppModel sharedInstance].user_info.isLogined = YES;
    
    [[AppModel sharedInstance] saveAppModel];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(appModel.user_info.userId) forKey:@"userId"];
    [ud setObject:appModel.user_info.mobile forKey:@"mobile"];
    [ud synchronize];
}









+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}




@end
