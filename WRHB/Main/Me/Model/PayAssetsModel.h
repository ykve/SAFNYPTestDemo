//
//  PayAssetsModel.h
//  WRHB
//
//  Created by AFan on 2019/10/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayAssetsModel : NSObject<NSCoding>

/// 中文名称
@property (nonatomic, copy) NSString *display;
/// 资产英文
@property (nonatomic, copy) NSString *coin_name;
/// 冻结余额
@property (nonatomic, copy) NSString *lock_num;


/// 可用余额    - 提现信息接口 - 余额数量
@property (nonatomic, copy) NSString *over_num;
// ******** 提现信息接口 ********
/// 可提现金额
@property (nonatomic, copy) NSString *can_withdraw;
/// 可提现次数
@property (nonatomic, assign) NSInteger withdraw_num;
/// 行政费
@property (nonatomic, copy) NSString *cost;
/// 需要达到的流水
@property (nonatomic, copy) NSString *change_capital;
/// 提现手续费
@property (nonatomic, copy) NSString *fee_rate;
/// 行政手续费
@property (nonatomic, copy) NSString *cost_fee;


@end

NS_ASSUME_NONNULL_END
