//
//  RoomMangaeModel.h
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClubInitiator;

NS_ASSUME_NONNULL_BEGIN

@interface RoomMangaeModel : NSObject
/// 会话名称
@property (nonatomic, copy) NSString *title;
/// 会话ID
@property (nonatomic, assign) NSInteger ID;
/// 会话头像
@property (nonatomic, copy) NSString *avatar;
/// 玩法
@property (nonatomic, assign) NSInteger play_type;
/// 房间创建者
@property (nonatomic, strong) ClubInitiator *initiator;

///
@property (nonatomic, copy) NSString *tax_rate;
/// 状态 1 开启 2 关闭   3 删除
@property (nonatomic, assign) NSInteger status;
/// 成员数量
@property (nonatomic, assign) NSInteger member_count;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger fee_from_who;

@end

NS_ASSUME_NONNULL_END
