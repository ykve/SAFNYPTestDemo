//
//  WithdrawView.h
//  WRHB
//
//  Created by AFan on 2019/2/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UIImageView *bankIconImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UIButton *selectBankBtn;
@property (nonatomic, strong) UILabel *tipLabel;


/// 金额余额
@property (nonatomic, strong) UILabel *moneyYuELabel;
/// 可提现金额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 每天最多可提现 x 次
@property (nonatomic, strong) UILabel *ttiLabel;

@property(nonatomic,copy)void(^desIconBlock)(void);


-(void)initView;
@end

NS_ASSUME_NONNULL_END
