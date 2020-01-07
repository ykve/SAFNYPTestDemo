//
//  PushMessageModel.h
//  WRHB
//
//  Created by AFan on 2019/9/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHC_ModelSqlite.h"


NS_ASSUME_NONNULL_BEGIN

@interface PushMessageNumModel : NSObject<NSCoding,WHC_SqliteInfo>

/// 用户ID  自己的
@property (nonatomic, assign) NSInteger userId;
/// 会话ID
@property (nonatomic, assign)  NSInteger sessionId;
/// 消息所属会话
@property (nonatomic, assign) ChatSessionType chatSessionType;
/// 最后一条消息内容
@property (nonatomic ,copy) NSString *lastMessage;
/// 消息条数
@property (nonatomic ,assign) NSInteger number;
/// 未读消息总量剩余
@property (nonatomic ,assign) NSInteger messageCountLeft;
/// 置顶聊天用的
@property (nonatomic, assign) BOOL    isTopChat;
/// 置顶时间
@property (nonatomic, strong, nonnull) NSDate    *isTopTime;
/// 消息在数据库的创建时间
@property (nonatomic, strong) NSDate    *create_time;
/// 最后的消息是自己的还是对方的  默认对方的 0   1 自己的
@property (nonatomic, assign) BOOL    isYourselfSend;



/// ID
@property (nonatomic, assign) NSInteger sendUserId;
/// 名称
@property (nonatomic ,copy) NSString *name;
/// 头像
@property (nonatomic ,copy) NSString *avatar;

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder;
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
