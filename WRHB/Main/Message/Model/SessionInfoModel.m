//
//  SessionInfoModel.m
//  WRHB
//
//  Created by AFan on 2019/10/8.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SessionInfoModel.h"

@implementation SessionInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"desc": @"description"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"group_users" : @"BaseUserModel"
             };
}

@end
