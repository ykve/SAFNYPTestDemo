//
//  Group_Capital.h
//  WRHB
//
//  Created by AFan on 2019/12/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group_Capital : NSObject

/// 发包总额
@property (nonatomic, copy) NSString *send_number;
/// 抢包总额
@property (nonatomic, copy) NSString *grab_number;
/// 发包个数
@property (nonatomic ,assign) NSInteger send_count;
/// 抢包人数
@property (nonatomic ,assign) NSInteger grab_users;
/// 发包人数
@property (nonatomic ,assign) NSInteger send_users;
/// 抢包个数
@property (nonatomic ,assign) NSInteger grab_count;

@end

NS_ASSUME_NONNULL_END
