//
//  Sub_Activity.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sub_Activity : NSObject

/// 发包奖励
@property (nonatomic, copy) NSString *send_reward;
/// 代理工资
@property (nonatomic, copy) NSString *agent_salary;
/// 基金奖励
@property (nonatomic, copy) NSString *fund_reward;
/// 签到奖励
@property (nonatomic, copy) NSString *check_in_reward;
/// 充值奖励
@property (nonatomic, copy) NSString *recharge_reward;
/// 第一次充值奖励
@property (nonatomic, copy) NSString *first_charge_reward;
/// 第二次充值奖励
@property (nonatomic, copy) NSString *second_charge_reward;
/// 抢包奖励
@property (nonatomic, copy) NSString *grab_reward;
/// 好友充值奖励
@property (nonatomic, copy) NSString *friend_charge_reward;


@end

NS_ASSUME_NONNULL_END
