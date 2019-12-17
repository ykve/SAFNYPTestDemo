//
//  NoRobJieSuanModel.h
//  WRHB
//
//  Created by AFan on 2019/10/19.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoRobSettleModel : NSObject


/// 发包用户
@property (nonatomic, copy) NSString *send_user;
/// 金额数量
@property (nonatomic, copy) NSString *value;
/// 赔付金额
@property (nonatomic, copy) NSString *pay_number;
/// 雷号玩法
@property (nonatomic, copy) NSString *mimes_play_type;
/// 红包数量
@property (nonatomic, assign) NSInteger pieces;
/// 红包玩法
@property (nonatomic, assign) NSInteger play_type;
/// 雷数赔率
@property (nonatomic, copy) NSString *odds;
/// 结果
@property (nonatomic, copy) NSString *result;



/// 发包用户 ID
@property (nonatomic, assign) NSInteger ID;
/// 中雷数量
@property (nonatomic, assign) NSInteger get_mimes;
/// 埋雷号码  逗号分割 [,]
@property (nonatomic, copy) NSString *mimes;
/// 奖励金额
@property (nonatomic, copy) NSString *reward;





@end

NS_ASSUME_NONNULL_END



