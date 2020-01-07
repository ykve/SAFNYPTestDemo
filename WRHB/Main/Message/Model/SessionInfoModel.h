//
//  SessionInfoModel.h
//  WRHB
//
//  Created by AFan on 2019/10/8.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseUserModel;

@interface SessionInfoModel : NSObject

/// 会话 ID
@property (nonatomic, assign) NSInteger sessionId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
/// 须知(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *packet_range;
@property (nonatomic, copy) NSString *number_limit;
/// 公告(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *notice;
/// 红包类型
@property (nonatomic, assign) RedPacketType play_type;
///
@property (nonatomic, assign) NSInteger initiator;
/// 会话类型
@property (nonatomic, assign) ChatSessionType type;

@end

NS_ASSUME_NONNULL_END
