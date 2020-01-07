//
//  SessionInfoModels.h
//  WRHB
//
//  Created by AFan on 2020/1/7.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SessionInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface SessionInfoModels : NSObject

/// 公告(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *notice;
/// 玩法说明(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *play_type_notice;
/// 成员信息
@property (nonatomic, strong) NSArray<BaseUserModel *> *group_users;
/// 群规(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *group_regulation;
/// 须知(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *desc;
/// 创建者ID
@property (nonatomic, assign) NSInteger creator;
///
@property (nonatomic, strong) SessionInfoModel *session_info;
/// 红包类型
@property (nonatomic, assign) RedPacketType play_type;



@end

NS_ASSUME_NONNULL_END
