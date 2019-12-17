//
//  TopupBankCardDetailsVC.h
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayTopupModel;

NS_ASSUME_NONNULL_BEGIN

@interface TopupBankCardDetailsVC : UIViewController
@property (nonatomic, strong) PayTopupModel *selectPayModel;
/// 充值金额
@property (copy, nonatomic) NSString *topupMoney;
@end

NS_ASSUME_NONNULL_END
