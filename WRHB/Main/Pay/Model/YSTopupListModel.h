//
//  YSTopupListModel.h
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSTopupListModel : NSObject

/// 盈商索引id
@property (nonatomic, assign) NSInteger ID;
/// 盈商唯一ID
@property (nonatomic, copy) NSString *bus_id;
/// 盈商名称
@property (nonatomic, copy) NSString *name;
/// 等级
@property (nonatomic, assign) NSInteger level_id;
/// 1在线 2离线
@property (nonatomic, assign) NSInteger is_online;
/// 银行卡号
@property (nonatomic, copy) NSString *avatar;
/// 评分
@property (nonatomic, assign) CGFloat score;
/// [1,2,3]  //支持的付款方式图标 1支付宝 2微信 3银行卡
@property (nonatomic, strong) NSArray *account_types;

@property (nonatomic, strong) NSArray *reply;

@end

NS_ASSUME_NONNULL_END
