//
//  SqliteManage.m
//  Project
//
//  Created by AFan on 2019/11/9.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "SqliteManage.h"
#import "WHC_ModelSqlite.h"
#import "PushMessageNumModel.h"
#import "YPMessage.h"

@implementation SqliteManage
+ (SqliteManage *)sharedInstance {
    static SqliteManage *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


+ (void)removeGroupSql:(NSInteger)groupId {
    NSString *query = [NSString stringWithFormat:@"sessionId='%ld'",groupId];
    [WHC_ModelSqlite delete:[YPMessage class] where:query];
    
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%ld' AND userId='%ld'",groupId,[AppModel sharedInstance].user_info.userId];
    [WHC_ModelSqlite delete:[PushMessageNumModel class] where:queryWhere];
}

+ (PushMessageNumModel *)queryById:(NSInteger)groupId{
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%ld' AND userId='%ld'",groupId,[AppModel sharedInstance].user_info.userId];
    return [[WHC_ModelSqlite query:[PushMessageNumModel class] where:queryWhere] firstObject];
}

+ (void)clean{
    [WHC_ModelSqlite removeModel:[PushMessageNumModel class]];
}

@end
