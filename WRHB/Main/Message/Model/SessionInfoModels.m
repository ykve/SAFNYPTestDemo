//
//  SessionInfoModels.m
//  WRHB
//
//  Created by AFan on 2020/1/7.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "SessionInfoModels.h"

@implementation SessionInfoModels

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"desc": @"description"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"group_users" : @"BaseUserModel",
             @"session_info" : @"SessionInfoModel"
             };
}

@end
