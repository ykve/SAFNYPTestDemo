/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
{
    [[self nextResponder] routerEventWithName:eventName user_info:user_info];
}

@end


// 使用方法

//  Cell
//- (void)followButtonClick:(UIButton *)button
//{
//    [self routerEventWithName:@"cancelFollow" user_info:self.user_info];
//}
//
//// Controller
//- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
//{
//    if ([eventName isEqualToString:@"cancelFollow"]) {
//        NSString *userId = user_info[@"userId"];
//        [self cancelFollowWithUserId:userId];
//        return;
//    }
//    [super routerEventWithName:eventName user_info:user_info];
//}
//
//// Controller  另外
//- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
//{
//    if ([eventName isEqualToString:@"favButtonClick"]) {
//        NSLog(@"favButtonClick  user_info = %@",user_info);
//        currentSelectRecommend = [[NSDictionary alloc] initWithDictionary:user_info];
//        NSString *recommendUser = user_info[@"recommendUser"];
//        [self followUser:recommendUser];
//    }
//    else if ([eventName isEqualToString:@"commentButtonClick"]){
//        currentSelectRecommend = [[NSDictionary alloc] initWithDictionary:user_info];
//        NSString *recommendUser = user_info[@"recommendUser"];
//        [self commentWithUserId:recommendUser];
//        NSLog(@"commentButtonClick user_info = %@",user_info);
//    }
//    else{
//        [super routerEventWithName:eventName user_info:user_info];
//    }
//}
