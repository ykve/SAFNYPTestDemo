//
//  PayBankcardController.m
//  WRHB
//
//  Created by AFan on 2019/12/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayBankcardController.h"
#import "UIView+AZGradient.h"  // 渐变色
#import "PayTopupModel.h"
#import "TopupDetailsModel.h"

@interface PayBankcardController ()

///
@property (nonatomic, strong) UIImageView *iconImg;
///
@property (nonatomic, strong) UILabel *moneyLabel;
/// 收款银行
@property (nonatomic, strong) UILabel *bankNameLabel;
/// 收款姓名
@property (nonatomic, strong) UILabel *receiNameLabel;
/// 开户行名称
@property (nonatomic, strong) UILabel *kaihuBankNameLabel;
/// 卡号
@property (nonatomic, strong) UILabel *cardNumLabel;
/// 付款姓名
@property (nonatomic, strong) UITextField *nameTextField;



@end

@implementation PayBankcardController

/// 导航栏透明功能
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#333333"],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡存款";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];

    [self setupUI];
    [self setViewData];
}

/**
 提交支付
 */
- (void)onSubmitBtn {
    NSDictionary *parameters = @{
                                 @"name":self.nameTextField.text,
                                 @"money":self.detailsModel.money,
                                 @"method_id":@(self.selectPayModel.ID)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"recharge/order"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInView:response[@"message"]];
            [strongSelf performSelector:@selector(delayedExecBackReturn) withObject:nil afterDelay:1.5];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)delayedExecBackReturn {
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)setViewData {
    
    if (self.detailsModel.icon.length < kAvatarLength) {
        self.iconImg.image = [UIImage imageNamed:@"pay_bankcard_icon"];
    } else {
        [self.iconImg cd_setImageWithURL:[NSURL URLWithString:self.detailsModel.icon] placeholderImage:[UIImage imageNamed:@"pay_bankcard_icon"]];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", self.detailsModel.money];
    self.bankNameLabel.text = self.detailsModel.bank_name;
    self.receiNameLabel.text = self.detailsModel.bank_user;
    self.kaihuBankNameLabel.text = self.detailsModel.bank_title;
    self.cardNumLabel.text = self.detailsModel.bank_card;
}

/**
 复制
 */
-(void)onCopyAction:(UIButton *)sender {
    
    NSString *text = nil;
    if (sender.tag == 4000) {
        text = self.bankNameLabel.text;
    } else if (sender.tag == 4001) {
        text = self.receiNameLabel.text;
    } else if (sender.tag == 4002) {
        text = self.kaihuBankNameLabel.text;
    } else if (sender.tag == 4003) {
        text = self.cardNumLabel.text;
    }
    
    if(text.length == 0) {
        text = @"";
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = text;
    [MBProgressHUD showSuccessMessage:@"复制成功"];
}

- (void)setupUI {
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"pay_bankcard_bg"];
    [self.view addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(199);
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(170);
    }];
    
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = [UIImage imageNamed:@"pay_bankcard_icon"];
    [backView addSubview:iconImg];
    _iconImg = iconImg;
    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(20);
        make.left.equalTo(backView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(72.5, 48.5));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"当前银行卡方式存款";
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImg.mas_centerY);
        make.left.equalTo(iconImg.mas_right).offset(10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"        尊敬的用户您好，您的存款订单已生成，请记录以下官方账户信息以及存款金额，并尽快登录您的网上银行/手机银行/支付宝/微信进行转账，转账完成后请保留银行或APP回执，以遍确认转账信息。";
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor colorWithHex:@"#333333"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImg.mas_bottom).offset(20);
        make.left.equalTo(iconImg.mas_left);
        make.right.equalTo(backView.mas_right).offset(-20);
    }];
    
    UIView *midBgView = [[UIView alloc] init];
    midBgView.layer.cornerRadius = 8;
    midBgView.layer.masksToBounds = YES;
    midBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midBgView];
    
    [midBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(54);
    }];
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"存款金额:";
    titLabel.font = [UIFont systemFontOfSize:15];
    titLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titLabel.textAlignment = NSTextAlignmentLeft;
    [midBgView addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midBgView.mas_centerY);
        make.left.equalTo(midBgView.mas_left).offset(15);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont systemFontOfSize:24];
    moneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [midBgView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midBgView.mas_centerY);
        make.left.equalTo(titLabel.mas_right).offset(5);
        make.right.equalTo(midBgView.mas_right).offset(-20);
    }];
    
    
    /// 收款银行
    UIView *bottomBgView = [[UIView alloc] init];
    bottomBgView.layer.cornerRadius = 8;
    bottomBgView.layer.masksToBounds = YES;
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(246);
    }];
    
    CGFloat titleTextSpacing = 10;
    
    UIButton *copyButton1 = [UIButton new];
    [bottomBgView addSubview:copyButton1];
    copyButton1.titleLabel.font = [UIFont systemFontOfSize2:15];
    [copyButton1 setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton1 addTarget:self action:@selector(onCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton1.layer.masksToBounds = YES;
    copyButton1.layer.cornerRadius = 5;
    copyButton1.tag = 4000;
    [copyButton1 az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBgView.mas_top).offset(15);
        make.right.equalTo(bottomBgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    
    UILabel *tit1Label = [[UILabel alloc] init];
    tit1Label.text = @"收款银行:";
    tit1Label.font = [UIFont systemFontOfSize:15];
    tit1Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit1Label.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:tit1Label];
    
    [tit1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton1.mas_centerY);
        make.left.equalTo(bottomBgView.mas_left).offset(15);
    }];
    
    UILabel *bankNameLabel = [[UILabel alloc] init];
    bankNameLabel.text = @"-";
    bankNameLabel.font = [UIFont systemFontOfSize:14];
    bankNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    bankNameLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:bankNameLabel];
    _bankNameLabel = bankNameLabel;
    
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton1.mas_centerY);
        make.left.equalTo(tit1Label.mas_right).offset(titleTextSpacing);
        make.right.equalTo(midBgView.mas_right).offset(-10);
    }];
    
    UIButton *copyButton2 = [UIButton new];
    [bottomBgView addSubview:copyButton2];
    copyButton2.titleLabel.font = [UIFont systemFontOfSize2:15];
    [copyButton2 setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton2 addTarget:self action:@selector(onCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton2.layer.masksToBounds = YES;
    copyButton2.layer.cornerRadius = 5;
    copyButton2.tag = 4001;
    [copyButton2 az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyButton1.mas_bottom).offset(17);
        make.right.equalTo(copyButton1.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    
    UILabel *tit2Label = [[UILabel alloc] init];
    tit2Label.text = @"收款姓名:";
    tit2Label.font = [UIFont systemFontOfSize:15];
    tit2Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit2Label.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:tit2Label];
    
    [tit2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton2.mas_centerY);
        make.left.equalTo(tit1Label.mas_left);
    }];
    
    UILabel *receiNameLabel = [[UILabel alloc] init];
    receiNameLabel.text = @"-";
    receiNameLabel.font = [UIFont systemFontOfSize:14];
    receiNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    receiNameLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:receiNameLabel];
    _receiNameLabel = receiNameLabel;
    
    [receiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton2.mas_centerY);
        make.left.equalTo(tit2Label.mas_right).offset(titleTextSpacing);
        make.right.equalTo(midBgView.mas_right).offset(-10);
    }];
    
    
    UIButton *copyButton3 = [UIButton new];
    [bottomBgView addSubview:copyButton3];
    copyButton3.titleLabel.font = [UIFont systemFontOfSize2:15];
    [copyButton3 setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton3 addTarget:self action:@selector(onCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton3.layer.masksToBounds = YES;
    copyButton3.layer.cornerRadius = 5;
    copyButton3.tag = 4002;
    [copyButton3 az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyButton2.mas_bottom).offset(17);
        make.right.equalTo(copyButton1.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    
    UILabel *tit3Label = [[UILabel alloc] init];
    tit3Label.text = @"收款开户行:";
    tit3Label.font = [UIFont systemFontOfSize:15];
    tit3Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit3Label.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:tit3Label];
    
    [tit3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton3.mas_centerY);
        make.left.equalTo(tit1Label.mas_left);
    }];
    
    UILabel *kaihuBankNameLabel = [[UILabel alloc] init];
    kaihuBankNameLabel.text = @"-";
    kaihuBankNameLabel.font = [UIFont systemFontOfSize:14];
    kaihuBankNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    kaihuBankNameLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:kaihuBankNameLabel];
    _kaihuBankNameLabel = kaihuBankNameLabel;
    
    [kaihuBankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton3.mas_centerY);
        make.left.equalTo(tit3Label.mas_right).offset(titleTextSpacing);
        make.right.equalTo(midBgView.mas_right).offset(-10);
    }];
    
    
    UIButton *copyButton4 = [UIButton new];
    [bottomBgView addSubview:copyButton4];
    copyButton4.titleLabel.font = [UIFont systemFontOfSize2:15];
    [copyButton4 setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton4 addTarget:self action:@selector(onCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton4.layer.masksToBounds = YES;
    copyButton4.layer.cornerRadius = 5;
    copyButton4.tag = 4003;
    [copyButton4 az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyButton3.mas_bottom).offset(17);
        make.right.equalTo(copyButton1.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    
    
    UILabel *tit4Label = [[UILabel alloc] init];
    tit4Label.text = @"收款卡号:";
    tit4Label.font = [UIFont systemFontOfSize:15];
    tit4Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit4Label.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:tit4Label];
    
    [tit4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton4.mas_centerY);
        make.left.equalTo(tit1Label.mas_left);
    }];
    
    UILabel *cardNumLabel = [[UILabel alloc] init];
    cardNumLabel.text = @"-";
    cardNumLabel.font = [UIFont systemFontOfSize:14];
    cardNumLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cardNumLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:cardNumLabel];
    _cardNumLabel = cardNumLabel;
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyButton4.mas_centerY);
        make.left.equalTo(tit4Label.mas_right).offset(titleTextSpacing);
        make.right.equalTo(midBgView.mas_right).offset(-10);
    }];
    
    
    /// 付款姓名
    UITextField *nameTextField = [[UITextField alloc] init];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;  //边框类型
    nameTextField.font = [UIFont boldSystemFontOfSize:15.0];  // 字体
    nameTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    nameTextField.placeholder = @"请输入付款姓名"; // 占位文字
    nameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    //    nameTextField.delegate = self;
    nameTextField.keyboardType = UIKeyboardTypeEmailAddress; // 键盘类型
    nameTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [bottomBgView addSubview:nameTextField];
    _nameTextField = nameTextField;
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyButton4.mas_bottom).offset(17);
        make.left.equalTo(bottomBgView.mas_left).offset(95);
        make.right.equalTo(bottomBgView.mas_right).offset(-15);
        make.height.mas_equalTo(@(35));
    }];
    
    UILabel *tit5Label = [[UILabel alloc] init];
    tit5Label.text = @"付款姓名:";
    tit5Label.font = [UIFont systemFontOfSize:15];
    tit5Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit5Label.textAlignment = NSTextAlignmentLeft;
    [bottomBgView addSubview:tit5Label];
    
    [tit5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameTextField.mas_centerY);
        make.left.equalTo(tit1Label.mas_left);
    }];
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"提交支付" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn delayEnable];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(bottomBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
}




@end
