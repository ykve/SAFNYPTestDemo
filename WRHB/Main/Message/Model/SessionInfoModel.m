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
    return @{@"sessionId": @"id"};
}


@end
