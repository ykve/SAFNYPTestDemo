//
//  MessageSingle.m
//  WRHB
//
//  Created by AFan on 2019/5/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MessageSingle.h"

@implementation MessageSingle

+ (MessageSingle *)sharedInstance {
    static MessageSingle *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _unreadAllMessagesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

@end

