//
//  PasswordTipController.h
//  WRHB
//
//  Created by AFan on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "ViewController.h"

@class PWView;
NS_ASSUME_NONNULL_BEGIN

@interface PasswordTipController : ViewController
@property (nonatomic, strong) PWView *pwView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@end

NS_ASSUME_NONNULL_END
