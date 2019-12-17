//
//  ReportModel.h
//  WRHB
//
//  Created by AFan on 2019/10/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group_Capital.h"
#import "Group_Activity.h"
#import "Group_Assets.h"
#import "Group_Level.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeamReportModel : NSObject

/// 流水
@property (nonatomic, strong) Group_Capital *group_capital;
/// 活跃度
@property (nonatomic, strong) Group_Activity *group_activity;
/// 资金报表
@property (nonatomic, strong) Group_Assets *group_assets;
///
@property (nonatomic, strong) Group_Level *group_level;








/// 总注册
@property (nonatomic, assign) NSInteger registerNum;
/// 新注册人数
@property (nonatomic, assign) NSInteger new_register;
/// 发包个数
@property (nonatomic, assign) NSInteger send_num;
/// 抢包个数
@property (nonatomic, assign) NSInteger grab_num;
/// 发包人数
@property (nonatomic, assign) NSInteger send_count;
/// 抢包人数
@property (nonatomic, assign) NSInteger grab_count;
/// 总充值金额
@property (nonatomic, copy) NSString *recharge;
/// 总提现金额
@property (nonatomic, copy) NSString *withdraw;
/// 起始金额
@property (nonatomic, copy) NSString *start_money;
/// 截至金额
@property (nonatomic, copy) NSString *end_money;
/// 发包金额
@property (nonatomic, copy) NSString *send;
/// 抢包金额
@property (nonatomic, copy) NSString *grab;
/// 流水佣金分成
@property (nonatomic, copy) NSString *agent_fy;
/// 首充用户奖金
@property (nonatomic, copy) NSString *first_reward;
/// 首冲笔数
@property (nonatomic, assign) NSInteger first_num;
/// 次冲笔数
@property (nonatomic, assign) NSInteger second_num;
/// 首冲金额
@property (nonatomic, copy) NSString *first_money;
/// 次冲金额
@property (nonatomic, copy) NSString *second_money;


@end

NS_ASSUME_NONNULL_END
