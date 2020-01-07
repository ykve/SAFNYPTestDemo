//
//  BillRecotdDetailsController.h
//  WRHB
//
//  Created by AFan on 2019/12/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface BillRecotdDetailsController : UIViewController

/// 账单类型
@property (nonatomic, assign) NSInteger category;
///
@property (nonatomic, strong) BillItemModel *billModel;

@end

NS_ASSUME_NONNULL_END
