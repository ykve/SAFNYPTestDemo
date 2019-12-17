//
//  Group_Assets.h
//  WRHB
//
//  Created by AFan on 2019/12/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group_Assets : NSObject
/// 活动奖励
@property (nonatomic, copy) NSString *activity_reward;
/// 团队余额
@property (nonatomic, copy) NSString *assets;
/// 提现总额
@property (nonatomic, copy) NSString *withdraw_number;
/// 充值总额
@property (nonatomic, copy) NSString *charge_number;
/// 充值笔数
@property (nonatomic ,assign) NSInteger charge_count;
/// 提现笔数
@property (nonatomic ,assign) NSInteger withdraw_count;
@end

NS_ASSUME_NONNULL_END
