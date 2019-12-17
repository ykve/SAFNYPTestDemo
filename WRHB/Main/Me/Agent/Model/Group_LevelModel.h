//
//  Group_LevelModel.h
//  WRHB
//
//  Created by AFan on 2019/12/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group_LevelModel : NSObject

/// 发包金额
@property (nonatomic, copy) NSString *send_number;
/// 充值金额
@property (nonatomic, copy) NSString *charge_number;
/// 提现金额
@property (nonatomic, copy) NSString *withdraw_number;
/// 抢包金额
@property (nonatomic, copy) NSString *grab_number;
/// 抢包个数
@property (nonatomic ,assign) NSInteger grab_count;
/// 代理用户
@property (nonatomic ,assign) NSInteger agent_user;
/// 普通用户
@property (nonatomic ,assign) NSInteger normal_user;
/// 发包个数
@property (nonatomic ,assign) NSInteger send_count;


@end

NS_ASSUME_NONNULL_END
