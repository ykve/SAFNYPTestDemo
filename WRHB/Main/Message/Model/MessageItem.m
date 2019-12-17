//
//  MessageItem.m
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "MessageItem.h"



@implementation MessageItem



+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"groupId": @"id"};
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString *)whc_SqliteVersion {
    return @"1.0.2";
}


@end
