//
//  Sub_Users.h
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sub_Withdraw;
@class Sub_Game;
@class Sub_Recharge;
@class Sub_Activity;

NS_ASSUME_NONNULL_BEGIN

@interface Sub_Users : NSObject

/// ID
@property (nonatomic, assign) NSInteger user_id;
/// 用户名
@property (nonatomic, copy) NSString *name;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 是否是代理
@property (nonatomic, assign) BOOL is_agent;
/// 层级
@property (nonatomic, assign) NSInteger level;
/// 佣金
@property (nonatomic, copy) NSString *commission;
/// 流水
@property (nonatomic, copy) NSString *capital;


/// 提现
@property (nonatomic, strong) Sub_Withdraw *withdraw; 
/// 充值
@property (nonatomic, strong) Sub_Recharge *recharge;
/// 游戏 发包、抢包
@property (nonatomic, strong) Sub_Game *game;
///
@property (nonatomic, strong) Sub_Activity *activity;



@end

NS_ASSUME_NONNULL_END
