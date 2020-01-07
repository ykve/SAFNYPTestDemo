//
//  UserInfo.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId": @"id"};
}

- (id)copyWithZone:(NSZone *)zone{
    UserInfo *copy = [[self class] allocWithZone: zone];
    copy.userId = self.userId;
    copy.name = self.name;
    copy.avatar = self.avatar;
    copy.mobile = self.mobile;
    copy.recommend = self.recommend;
    copy.sex = self.sex;
    copy.is_agent = self.is_agent;
    
    copy.isLogined = self.isLogined;
    return copy;
}

@end
