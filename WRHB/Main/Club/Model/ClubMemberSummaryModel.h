//
//  ClubSummaryModel.h
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberSummaryModel : NSObject

/// 充值
@property (nonatomic, copy) NSString *charge;
/// 提现
@property (nonatomic, copy) NSString *withdraw;
/// 发包个数
@property (nonatomic, assign) NSInteger send_count;
/// 抢包个数
@property (nonatomic, assign) NSInteger grab_count;
/// 发包金额
@property (nonatomic, copy) NSString *send_number;
/// 抢包金额
@property (nonatomic, copy) NSString *grab_number;
/// 累盈利
@property (nonatomic, copy) NSString *win;
/// 累积流水
@property (nonatomic, copy) NSString *capital;

@end

NS_ASSUME_NONNULL_END
