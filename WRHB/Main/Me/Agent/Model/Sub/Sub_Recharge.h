//
//  Sub_Recharge.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sub_Recharge : NSObject
/// 充值次数
@property (nonatomic, assign) NSInteger count;
/// 充值金额
@property (nonatomic, copy) NSString *number;
@end

NS_ASSUME_NONNULL_END
