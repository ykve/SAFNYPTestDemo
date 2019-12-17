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

/// 玩法说明(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *play_type_notice;
/// 群规(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *group_regulation;
/// 须知(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *desc;
/// 成员信息
@property (nonatomic, strong) NSArray<BaseUserModel *> *group_users;
/// 公告(只有群聊才会有，单聊不返回)
@property (nonatomic, copy) NSString *notice;
/// 红包类型
@property (nonatomic, assign) RedPacketType play_type;
/// 群主ID
@property (nonatomic, assign) NSInteger groupId;
/// 创建者ID
@property (nonatomic, assign) NSInteger creator;

@end

NS_ASSUME_NONNULL_END
