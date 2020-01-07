//
//  SqliteManage.h
//  WRHB
//
//  Created by AFan on 2019/11/9.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PushMessageNumModel;
@interface SqliteManage : NSObject

+ (SqliteManage *)sharedInstance;


+ (void)removePushMessageNumModelSql:(NSInteger)groupId;
+ (PushMessageNumModel *)queryPushMessageNumModelById:(NSInteger)groupId;

+ (void)clean;


@end
