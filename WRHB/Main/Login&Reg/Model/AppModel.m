//
//  AppModel.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "AppModel.h"
#import "UserInfo.h"
#import "WXManage.h"
//#import "SqliteManage.h"
//#import "LoginViewController.h"
//#import "LoginBySMSViewController.h"

#import "YPIMManager.h"
//#import "PreLoginVC.h"
//#import "PreRootVC.h"
#import "SessionSingle.h"
#import "PayAssetsModel.h"

#import "LoginViewController.H"
#import "UIDevice+BAKit.h"
#import "ChatsModel.h"

static NSString *Path = @"com.yipin.www";

@implementation AppModel

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"assets" : @"PayAssetsModel"
             };
}


+ (void)load{
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)sharedInstance{
    static AppModel *appModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(appModel == nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filename]) {
                appModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
//               id aa = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
                if(appModel == nil){
                    appModel = [[AppModel alloc] init];
                }
            } else {
                appModel = [[AppModel alloc] init];
            }
            
//            AppModel *appModel = [AppModel mj_objectWithKeyValues:dict];
//
//            [AppModel sharedInstance].token = appModel.token;
//            [AppModel sharedInstance].user_info = appModel.user_info;
//            [AppModel sharedInstance].assets = appModel.assets;
            
//            [AppModel sharedInstance].user_info.isLogined = YES;
            
        }
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger serverIndex = [[ud objectForKey:@"serverIndex"] integerValue];

        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            //第一次启动
            if (UIDevice.isSimulator) {
                serverIndex = 1;
            }
        } else {
            //不是第一次启动了
            if (UIDevice.isSimulator) {
                serverIndex = 1;
            }
            
        }
        
        
//         serverIndex = 1;  // 手动固定测试
        NSArray *arr = [appModel ipArray];
        if(serverIndex >= arr.count) {
            serverIndex = 0;
        }
        
        NSDictionary *dic = arr[serverIndex];
        appModel.serverApiUrl = dic[@"apiUrl"];
        appModel.isDebugMode = [dic[@"isBeta"] boolValue];
        if (appModel.isDebugMode) {
            appModel.wsSocketURL = kWSSocketURLTest;
        } else {
            appModel.wsSocketURL = kWSSocketURL;
        }
        
        
    });
    return appModel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setTurnOnSound:(BOOL)Sound{ ///<YES关闭，No开启
    _turnOnSound = Sound;
}

- (void)handleModelFromDic:(NSDictionary*)dict
{
     AppModel *appModel = [AppModel mj_objectWithKeyValues:dict];
     [AppModel sharedInstance].token = appModel.token;
     [AppModel sharedInstance].channel = appModel.channel;
     [AppModel sharedInstance].event = appModel.event;
     [AppModel sharedInstance].user_info = appModel.user_info;
     [AppModel sharedInstance].assets = appModel.assets;
     [AppModel sharedInstance].set_trade_password = appModel.set_trade_password;
     
     [AppModel sharedInstance].user_info.isLogined = YES;
     
     [[AppModel sharedInstance] saveAppModel];
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
     [ud setObject:@(appModel.user_info.userId) forKey:@"userId"];
     [ud setObject:appModel.user_info.mobile forKey:@"mobile"];
     [ud synchronize];
}

- (void)saveAppModel {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:Path];
    [NSKeyedArchiver archiveRootObject:self toFile:filename];
}

-(UserInfo *)user_info{
    if(_user_info == nil)
        _user_info = [[UserInfo alloc] init];
    return _user_info;
}


- (UIViewController *)rootVc{

    if (![[NSUserDefaults standardUserDefaults]objectForKey:[NSString appVersion]]) {
        return [[NSClassFromString(@"GuideViewController") alloc]init];
    }
    else{
        //        dispatch_semaphore_t signal = dispatch_semaphore_create(3);
        //        __block UIViewController* rVC = [UIViewController new];
        //
        //        [NET_REQUEST_MANAGER requestMsgBannerWithId:OccurBannerAdsTypeLaunch success:^(id object) {
        //            BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
        //            if (model.data.records.count>0) {
        ////                NSDictionary* dic = @{
        ////                                      kArr:
        ////                                          @[
        ////                                              @{kImg:@"msg_banner1",kUrl:@"https://www.baidu.com"},
        ////                                              @{kImg:@"msg_banner2",kUrl:@"https://news.baidu.com"}
        ////                                              ]
        ////                                      };
        //                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"PreRootVC")alloc]init]];
        //                rVC = nav;
        //                dispatch_semaphore_signal(signal);
        //            }
        //        } fail:^(id object) {
        //            if ([AppModel sharedInstance].user.isLogined) {
        //                rVC = [[NSClassFromString(@"BaseTabBarController")alloc]init];
        //
        //
        //
        //            }else{
        //                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController")alloc]init]];//PreLoginVC
        //                rVC = nav;
        //            }
        //            dispatch_semaphore_signal(signal);
        //
        //        }];
        //        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        //        return rVC;
        //    }
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"PreRootVC")alloc]init]];//PreLoginVC
        return nav;
    }

    
    //        return [[NSClassFromString(@"PreRootVC")alloc]init];
    
    
    //        if ([AppModel sharedInstance].user.isLogined) {
    //                return [[NSClassFromString(@"BaseTabBarController")alloc]init];
    //
    //
    //
    //        }else{
    //            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[NSClassFromString(@"LoginViewController")alloc]init]];//PreLoginVC
    //            return nav;
    //        }
    
}




- (CATransition *)animation{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type =  @"cube";  //立方体效果
    
    //设置动画子类型
    animation.subtype = kCATransitionFromTop;
    return animation;
}


-(NSArray *)ipArray{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [ud objectForKey:@"ipArray"];
    NSDictionary *dic1 = @{@"apiUrl":kServerUrl, @"isBeta":@(NO),@"baseKey":kBaseKey};
    NSMutableArray *array = [NSMutableArray arrayWithObjects:dic1, nil];
    
    NSArray *testArr = [kTestServerURLJson mj_JSONObject];
    [array addObjectsFromArray:testArr];
    if(arr) {
        [array addObjectsFromArray:arr];
    }
    return array;
}

- (id)copyWithZone:(NSZone *)zone {
    AppModel *appM = [[[self class] allocWithZone:zone] init];
    appM.token = self.token;
    appM.user_info = self.user_info;
    appM.assets = [self.assets mutableCopyWithZone:zone]; // 这是一个mutableCopy属性
    return appM;
}

@end
