//
//  UnreadMessagesNumSingle.h
//  WRHB
//
//  Created by AFan on 2019/12/29.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHC_ModelSqlite.h"


NS_ASSUME_NONNULL_BEGIN

@interface UnreadMessagesNumSingle : NSObject<NSCoding, WHC_SqliteInfo>

+ (UnreadMessagesNumSingle *)sharedInstance;

/// 用户ID  自己的
@property (nonatomic, assign) NSInteger userId;
/// 微聊未读总消息数量
@property (nonatomic ,assign) NSInteger weChatsUnReadAllCount;
/// 最后更新的未读消息数
@property (nonatomic ,assign) NSInteger weChatslastBadgeNum;
/// 我的消息 未读数量
@property (nonatomic ,assign) NSInteger myMessageUnReadCount;
/// 最后一次刷新我的消息未读数量
@property (nonatomic ,assign) NSInteger myMessagelastBadgeNum;
/// 我的好友 申请添加 消息数量
@property (nonatomic ,assign) NSInteger myFriendMessageNum;
/// 系统消息列表数量
@property (nonatomic ,assign) NSInteger sysMessageListNum;
/// 俱乐部申请加入 消息通知数量
@property (nonatomic ,assign) NSInteger clubAppltJoinNum;

/// 主动销毁  切换账号的时候
- (void)destoryInstance;

@end

NS_ASSUME_NONNULL_END


