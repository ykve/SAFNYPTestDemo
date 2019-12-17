//
//  ClubMemberDetailsListModel.h
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberDetailsListModel : NSObject

/// 红包ID
@property (nonatomic, assign) NSInteger packet_id;
/// 玩法类型
@property (nonatomic, copy) NSString *play_type;
/// 盈利金额
@property (nonatomic, copy) NSString *number;
/// 操作金额
@property (nonatomic, copy) NSString *operate_number;
/// 时间
@property (nonatomic, assign) NSTimeInterval created_at;
/// 类型
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END
