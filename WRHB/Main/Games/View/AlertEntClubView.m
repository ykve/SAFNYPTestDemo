//
//  AlertEntClubView.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AlertEntClubView.h"

@implementation AlertEntClubView

-(void)dealloc{
    NSLog(@"已释放====:%@",NSStringFromClass([self class]));
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] init];
    //    textField.tag = 100;
    textField.backgroundColor = [UIColor colorWithHex:@"#DEDEDE"];  // 背景颜色
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;  //边框类型
    textField.font = [UIFont systemFontOfSize:15.0];  // 字体
    textField.textColor = [UIColor blackColor];  // 字体颜色
    textField.placeholder = @"-"; // 占位文字
    textField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    textField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    //    textField.secureTextEntry = YES; // 密码
    //    textField.layer.cornerRadius = 5.0; // 圆角 导入QuartzCore.framework, 引用#import <QuartzCore/QuartzCore.h>
    //    textField.borderStyle = UITextBorderStyleRoundedRect; // 光标过于靠前
    [self addSubview:textField];
    _textField = textField;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(40);
    }];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.font = [UIFont boldSystemFontOfSize2:20];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"";
    titLabel.font = [UIFont systemFontOfSize:14];
    titLabel.textColor = [UIColor colorWithHex:@"#666666"];
    titLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titLabel];
    _titLabel = titLabel;
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textField.mas_top).offset(-10);
        make.left.equalTo(textField.mas_left);
    }];
    
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"-" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.backgroundColor = [UIColor clearColor];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.tag = 1000;
    [self addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
    
    UIButton *closedBtn = [[UIButton alloc] init];
    [closedBtn setBackgroundImage:[UIImage imageNamed:@"nav_closed"] forState:UIControlStateNormal];
    [closedBtn addTarget:self action:@selector(onClosedBtn) forControlEvents:UIControlEventTouchUpInside];
    [closedBtn setImage:[UIImage imageNamed:@"dial_mute"] forState:UIControlStateNormal];
    [self addSubview:closedBtn];
    
    [closedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    
}


- (void)onSubmitBtn {
    if (self.submitBtnBlock) {
        self.submitBtnBlock();
    }
}

- (void)onClosedBtn {
    if (self.coubBlock) {
        self.coubBlock();
    }
}
-(void)observerSure:(EntClubActionBlock)coubBlock{
    self.coubBlock = coubBlock;
}


@end
