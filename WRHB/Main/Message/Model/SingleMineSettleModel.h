//
//  SingleMineSettleModel.h
//  WRHB
//
//  Created by AFan on 2019/11/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleMineSettleModel : NSObject

/** 红包ID */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** 发送时间 */
@property(nonatomic, readwrite) int64_t sendTime;

/** 发包者 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *senderName;

/** 抢包金额 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *grabNum;

/** 赔付金额 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *loseNum;

/** 是否中雷 */
@property(nonatomic, readwrite) BOOL gotMime;

/** 接收者 */
@property(nonatomic, readwrite) uint64_t receiver;

@end

NS_ASSUME_NONNULL_END
