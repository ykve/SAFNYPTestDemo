//
//  SqliteManage.m
//  WRHB
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


+ (void)removePushMessageNumModelSql:(NSInteger)sessionId {
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%ld' AND userId='%ld'",(long)sessionId,(long)[AppModel sharedInstance].user_info.userId];
   BOOL sdff = [WHC_ModelSqlite delete:[PushMessageNumModel class] where:queryWhere];
    
    NSString *query = [NSString stringWithFormat:@"userId = %ld and sessionId= %ld",[AppModel
                                                                                         sharedInstance].user_info.userId,(long)sessionId];
    [WHC_ModelSqlite delete:[YPMessage class] where:query];
}

+ (PushMessageNumModel *)queryPushMessageNumModelById:(NSInteger)sessionId{
    NSString *queryWhere = [NSString stringWithFormat:@"sessionId='%ld' AND userId='%ld'",(long)sessionId,(long)[AppModel sharedInstance].user_info.userId];
    return [[WHC_ModelSqlite query:[PushMessageNumModel class] where:queryWhere] firstObject];
}

+ (void)clean{
    [WHC_ModelSqlite removeModel:[PushMessageNumModel class]];
}

@end
