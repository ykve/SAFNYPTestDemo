//
//  WithdrawView.m
//  WRHB
//
//  Created by AFan on 2019/2/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "WithdrawView.h"



@implementation WithdrawView

-(void)initView {
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 8;
//    self.tipLabel.text = [NSString stringWithFormat:@"当前零钱余额%@元，",[AppModel sharedInstance].user_info.balance];
    self.textField.delegate = self;
    
    self.bankIconImageView.layer.masksToBounds = YES;
    self.bankIconImageView.layer.cornerRadius = self.bankIconImageView.frame.size.width/2.0;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}






- (void)setupSubViews {
    
    UIView *topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topBackView];
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(168);
    }];
    
    UIButton *moneyBackBtn = [UIButton new];
    [moneyBackBtn addTarget:self action:@selector(onMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [topBackView addSubview:moneyBackBtn];
    //    moneyBackBtn.backgroundColor = [UIColor redColor];
    
    [moneyBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBackView.mas_centerX);
        make.top.equalTo(topBackView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    
    
    UIImageView *moneyImageView = [[UIImageView alloc] init];
    moneyImageView.image = [UIImage imageNamed:@"me_pay_money"];
    [moneyBackBtn addSubview:moneyImageView];
    
    [moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.top.equalTo(moneyBackBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(36, 25));
    }];
    
    UILabel *moneyYuELabel = [[UILabel alloc] init];
    moneyYuELabel.text = @"-";
    moneyYuELabel.font = [UIFont systemFontOfSize:12];
    moneyYuELabel.textColor = [UIColor colorWithHex:@"#333333"];
    moneyYuELabel.textAlignment = NSTextAlignmentCenter;
    [moneyBackBtn addSubview:moneyYuELabel];
    _moneyYuELabel = moneyYuELabel;
    
    [moneyYuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.bottom.equalTo(moneyBackBtn.mas_bottom).offset(-2);
    }];
    
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"可提现金额:";
    titLabel.font = [UIFont systemFontOfSize:12];
    titLabel.textColor = [UIColor darkGrayColor];
    titLabel.textAlignment = NSTextAlignmentLeft;
    [topBackView addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyYuELabel.mas_bottom).offset(15);
        make.left.equalTo(topBackView.mas_left).offset(15);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont systemFontOfSize:12];
    moneyLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [topBackView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.left.equalTo(titLabel.mas_right).offset(1);
    }];
    
    UILabel *unLabel = [[UILabel alloc] init];
    unLabel.text = @"元";
    unLabel.font = [UIFont systemFontOfSize:12];
    unLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    unLabel.textAlignment = NSTextAlignmentLeft;
    [topBackView addSubview:unLabel];
    
    [unLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.left.equalTo(moneyLabel.mas_right).offset(1);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.userInteractionEnabled = YES;
    iconImageView.image = [UIImage imageNamed:@"me_pay_state"];
    [topBackView addSubview:iconImageView];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScorllTextLableEvent)];
    //将手势添加到需要相应的view中去
    [iconImageView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.left.equalTo(unLabel.mas_right).offset(1);
        make.size.mas_equalTo(15);
    }];
    
    UIButton *allMoneyBtn = [[UIButton alloc] init];
    [allMoneyBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [allMoneyBtn addTarget:self action:@selector(allMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    allMoneyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [allMoneyBtn setTitleColor:[UIColor colorWithHex:@"#FF4444"] forState:UIControlStateNormal];
    [topBackView addSubview:allMoneyBtn];
    
    [allMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.right.equalTo(topBackView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    UILabel *yLabel = [[UILabel alloc] init];
    yLabel.text = @"￥";
    yLabel.font = [UIFont boldSystemFontOfSize2:22];
    yLabel.textColor = [UIColor colorWithHex:@"#343434"];
    yLabel.textAlignment = NSTextAlignmentLeft;
    [topBackView addSubview:yLabel];
    
    [yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topBackView.mas_bottom).offset(-20);
        make.left.equalTo(topBackView.mas_left).offset(15);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;  //边框类型
    textField.font = [UIFont boldSystemFontOfSize:24.0];  // 字体
    textField.textColor = [UIColor blackColor];  // 字体颜色
    textField.placeholder = @"请输入提现金额"; // 占位文字
    textField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
//    textField.returnKeyType = UIReturnKeyGo;
    [topBackView addSubview:textField];
    _textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yLabel.mas_centerY);
        make.left.equalTo(topBackView.mas_left).offset(45);
        make.right.equalTo(topBackView.mas_right).offset(-10);
        make.height.mas_equalTo(@(40));
    }];
    
    UIImageView *icon2ImageView = [[UIImageView alloc] init];
    icon2ImageView.image = [UIImage imageNamed:@"me_pay_state1"];
    [self addSubview:icon2ImageView];
    
    [icon2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(15);
        make.size.mas_equalTo(13);
    }];
    
    UILabel *ttiLabel = [[UILabel alloc] init];
    ttiLabel.text = @"每天最多可提现五次";
    ttiLabel.font = [UIFont systemFontOfSize:12];
    ttiLabel.textColor = [UIColor colorWithHex:@"#999999"];
    ttiLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:ttiLabel];
    _ttiLabel = ttiLabel;
    
    [ttiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon2ImageView.mas_centerY);
        make.left.equalTo(icon2ImageView.mas_right).offset(5);
    }];
    
    UIButton *btn = [UIButton new];
    [self addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    [btn setTitle:@"提现" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_TX) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor redColor];
    [btn delayEnable];
    _submitBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@(50));
        make.top.equalTo(topBackView.mas_bottom).offset(60);
    }];
}

- (void)onScorllTextLableEvent {
    if (self.desIconBlock) {
        self.desIconBlock();
    }
}

- (void)action_TX {
    NSLog(@"1");
}


-(void)allMoneyAction:(id)sender {
    self.textField.text = [NSString stringWithFormat:@"%@",self.moneyLabel.text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *s = textField.text;
    NSLog(@"%@  %@",s,string);
    
    if(s.length > 3 && string.length > 0){
        NSString *pot = [s substringWithRange:NSMakeRange(s.length -3 , 1)];
        if([pot isEqualToString:@"."])
            return NO;
    }
    
    return YES;
}
@end
