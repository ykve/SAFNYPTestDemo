//
//  TopupDetailsModel.h
//  WRHB
//
//  Created by AFan on 2019/12/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopupDetailsModel : NSObject

/// ********* 公共字段 *********
/// 1支付宝 2微信 3银行卡
@property (nonatomic, assign) NSInteger type;
/// 充值类型标题
@property (nonatomic, copy) NSString *type_name;
/// icon
@property (nonatomic, copy) NSString *icon;
/// 充值金额 保留两位小数
@property (nonatomic, copy) NSString *money;
/// 充值描述
@property (nonatomic, copy) NSString *description;


/// ********* 二维码类型字段 *********
/// 二维码地址
@property (nonatomic, copy) NSString *qrcode_url;
/// 收款姓名
@property (nonatomic, copy) NSString *qrcode_name;


/// ********* 银行卡类型字段 *********
/// 收款卡号
@property (nonatomic, copy) NSString *bank_card;
/// 收款姓名
@property (nonatomic, copy) NSString *bank_user;
/// 收款银行
@property (nonatomic, copy) NSString *bank_name;
/// 收款开户行
@property (nonatomic, copy) NSString *bank_title;


@end

NS_ASSUME_NONNULL_END
