//
//  ClubInfo.h
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubInfo : NSObject<NSCoding>
/// 俱乐部 ID
@property (nonatomic, assign) NSInteger ID;
/// 俱乐部名称
@property (nonatomic, copy) NSString *title;
/// 俱乐部聊天会话ID
@property (nonatomic, assign) NSInteger session;
/// 俱乐部公告
@property (nonatomic, copy) NSString *notice;
/// 角色 1 会员 2管理员 3 群主
@property (nonatomic, assign) NSInteger role;
/// 是否禁言 1 不禁言 2 禁言
@property (nonatomic, assign) NSInteger can_speak;
/// 创建房间 1 会员2 管理员
@property (nonatomic, assign) NSInteger who_create_room;
/// 创建房间费用 1 发包者 2 抢包者
@property (nonatomic, assign) NSInteger fee_from_who;
/// 俱乐部抽水比例
@property (nonatomic, copy) NSString *tax_rate;
/// 是否显示在大联盟 1 显示 2 不显示
@property (nonatomic, assign) NSInteger show_alliance;

@end

NS_ASSUME_NONNULL_END
