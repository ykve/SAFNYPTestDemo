//
//  Sub_Withdraw.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sub_Withdraw : NSObject
/// 提现次数
@property (nonatomic, assign) NSInteger count;
/// 提现金额
@property (nonatomic, copy) NSString *number;
@end

NS_ASSUME_NONNULL_END
