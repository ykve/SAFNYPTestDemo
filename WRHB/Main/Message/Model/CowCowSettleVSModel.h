//
//  CowCowVSMessageModel.h
//  WRHB
//
//  Created by AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

@interface CowCowSettleVSModel : NSObject

/// ID
@property (nonatomic, assign) NSInteger ID;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 庄的点数
@property (nonatomic, assign) NSInteger banker_points;
/// 庄赢的数量
@property (nonatomic, assign) NSInteger banker_win_times;
/// 闲赢的数量
@property (nonatomic, assign) NSInteger player_win_times;


@end

