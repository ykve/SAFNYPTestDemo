//
//  SysMessageListController.m
//  WRHB
//
//  Created by AFan on 2019/11/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SysMessageListController.h"

@interface SysMessageListController ()

@end

@implementation SysMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1");
}

/**
 拒绝好友申请
 */
- (void)requestAddFriend {
    
//    BADataEntity *entity = [BADataEntity new];
//    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/add"];
//    NSDictionary *parameters = @{
//                                 @"user":@([self.searchTextField.text integerValue])
//                                 };
//    entity.parameters = parameters;
//    entity.needCache = NO;
//
//    [MBProgressHUD showActivityMessageInView:nil];
//    __weak __typeof(self)weakSelf = self;
//    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [MBProgressHUD hideHUD];
//        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            strongSelf.userModel = nil;
//            [strongSelf.tableView reloadData];
//        }
//
//    } failureBlock:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [[AFHttpError sharedInstance] handleFailResponse:error];
//    } progressBlock:nil];
}

@end
