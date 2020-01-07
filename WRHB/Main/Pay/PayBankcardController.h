//
//  PayBankcardController.h
//  WRHB
//
//  Created by AFan on 2019/12/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayTopupModel;
@class TopupDetailsModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayBankcardController : UIViewController

@property (nonatomic, strong) PayTopupModel *selectPayModel;
/// 充值详情数据
@property (nonatomic, strong) TopupDetailsModel *detailsModel;
@end

NS_ASSUME_NONNULL_END
