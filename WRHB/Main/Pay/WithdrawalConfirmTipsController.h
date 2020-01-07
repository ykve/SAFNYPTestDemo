//
//  WithdrawalConfirmTipsController.h
//  WRHB
//
//  Created by AFan on 2019/12/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayAssetsModel;
@class WithdrawBankModel;

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawalConfirmTipsController : UIViewController
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

/// 1 满足打码 2 不满足打码
@property (nonatomic, assign) NSInteger txType;
@property (nonatomic, copy) NSString *txMoney;
@property (nonatomic, strong) WithdrawBankModel *selectBankModel;
///
@property (nonatomic, strong) PayAssetsModel *assetsModel;

@property (nonatomic, copy)void(^onSubmitBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
