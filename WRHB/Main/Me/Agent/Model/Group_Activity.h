//
//  Group_Activity.h
//  WRHB
//
//  Created by AFan on 2019/12/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group_Activity : NSObject
/// 二充金额
@property (nonatomic, copy) NSString *second_charge_number;
/// 首充金额
@property (nonatomic, copy) NSString *first_charge_number;
/// 首充笔数
@property (nonatomic ,assign) NSInteger first_charge_count;
/// 二充笔数
@property (nonatomic ,assign) NSInteger second_charge_count;
/// 注册人数
@property (nonatomic ,assign) NSInteger registerCount;
/// 活跃人数
@property (nonatomic ,assign) NSInteger activity;




///
@property (nonatomic ,assign) NSInteger send_count;

@end

NS_ASSUME_NONNULL_END
