//
//  ChatsModel.h
//  WRHB
//
//  Created by AFan on 2019/10/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatsModel : NSObject<NSCoding>

/// 会话 ID
@property (nonatomic, assign) NSInteger sessionId;
/// 会话名称
@property (nonatomic, copy) NSString *name;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 红包类型
@property (nonatomic, assign) RedPacketType play_type;
/// 会话类型
@property (nonatomic, assign) ChatSessionType sessionType;


/// ******* 单聊  *******
/// 单聊的用户ID
@property (nonatomic, assign) NSInteger userId;
/// 创建者
@property (nonatomic, assign) NSInteger initiator;
/// ******* 群专属  *******
/// 玩法详情
@property (nonatomic, copy) NSString *desc;
/// "5,20"   包个数范围      如果是禁抢 这个是 数字 包数（如3  6  9）
/// 包数分割字符串  切割  //最小2-3   5-9包 最小2   10包最小3 |  最大 5-7  最大自身 8-10 最大7
@property (nonatomic, copy) NSString *packet_range;
///  "10,1000"  包金额范围
@property (nonatomic, copy) NSString *number_limit;

@property (nonatomic, copy) NSString *notice;



/// 客服类型 0 正常 1 盈商  默认正常
@property (nonatomic, assign) NSInteger kefuType;
/// 群密码
@property (nonatomic, copy) NSString *password;
/// 本地头像
@property (nonatomic, copy) NSString *localImg;
/// 我加入的会话
@property (nonatomic ,assign) BOOL isJoinChatsList;

@end

NS_ASSUME_NONNULL_END
