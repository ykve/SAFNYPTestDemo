//
//  BaseUserModel.m
//  WRHB
//
//  Created by AFan on 2019/10/8.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BaseUserModel.h"

@implementation BaseUserModel
MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userId": @"user_id"};
}

@end
