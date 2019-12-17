//
//  YSReplyModel.h
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSReplyModel : NSObject
/// id
@property (nonatomic, assign) NSInteger ID;
/// 1支付宝 2微信 3银行卡
@property (nonatomic, assign) NSInteger type;
/// 收款方式名称
@property (nonatomic, copy) NSString *type_name;
@end

NS_ASSUME_NONNULL_END
