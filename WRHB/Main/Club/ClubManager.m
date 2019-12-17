//
//  ClubManager.m
//  WRHB
//
//  Created by AFan on 2019/12/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubManager.h"

@implementation ClubManager
MJCodingImplementation

+ (ClubManager *)sharedInstance
{
//    NSAssert(0, @"这是一个单例对象，请使用+(ClubManager *)sharedInstance方法");
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}
- (id)copy
{
    return self;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}
@end
