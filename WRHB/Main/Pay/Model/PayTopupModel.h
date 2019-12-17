//
//  CPTPayModel.h
//  LotteryProduct
//
//  Created by Jason Lee on 2019/5/20.
//  Copyright © 2019 vsskyblue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;
/// 图片url
@property (nonatomic, copy) NSString *icon;
/// 额度数组
@property (nonatomic, strong) NSArray *amounts;




/// 最大金额
@property (nonatomic,assign) NSInteger maxMoney;
/// 最小金额
@property (nonatomic,assign) NSInteger minMoney;








/// 支付项id
@property (nonatomic,assign) NSInteger wayId;
/// 支付标识，在线支付用
@property (nonatomic,copy) NSString *wayTag;

/// 图片url
//@property (nonatomic, copy) NSString *wayPicture;
/// 收款方式（1：银行卡转银行卡 ；2：微信转银行卡；3：支付宝转银行卡）
@property (nonatomic, assign) NSInteger receiveType;

/// 是否选中
@property (nonatomic, assign) BOOL isSel;
/// 是否人工充值
@property (nonatomic, assign) BOOL isManualRecharge;



@end

NS_ASSUME_NONNULL_END
