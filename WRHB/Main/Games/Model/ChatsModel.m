//
//  ChatsModel.m
//  WRHB
//
//  Created by AFan on 2019/10/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ChatsModel.h"

@implementation ChatsModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"sessionId": @"id", @"sessionType": @"type", @"userId": @"user"};
}

@end
