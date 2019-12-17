//
//  Sub_Game.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sub_Game : NSObject
/// 发包次数
@property (nonatomic, assign) NSInteger send_count;
/// 发包金额
@property (nonatomic, copy) NSString *send_number;
/// 抢包金额
@property (nonatomic, copy) NSString *grab_number;
/// 抢包金额
@property (nonatomic, assign) NSInteger grab_count;


@end

NS_ASSUME_NONNULL_END
