//
//  TransferController.m
//  WRHB
//
//  Created by AFan on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "TransferController.h"
#import "UIView+AZGradient.h"   // 渐变色
#import "ChatsModel.h"
#import "PasswordTipController.h"
#import "PWView.h"
#import "NSString+RegexCategory.h"
#import "PayFinishedController.h"
#import "TransferModel.h"
#import "SPAlertController.h"
#import "LoginForgetPsdController.h"

@interface TransferController ()<PWViewDelegate>
///
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UITextField *desTextField;
@property (nonatomic, copy) NSString *password;
@end

@implementation TransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"转账";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self setupUI];
    [self setUIValues];
    
    
    [self.moneyTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.desTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setUIValues {
    
    if (self.chatsModel.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", self.chatsModel.avatar]];
        if (image) {
            self.headImgView.image =  image;
        } else {
            self.headImgView.image =  [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImgView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:self.chatsModel.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    self.nameLabel.text = self.chatsModel.name;
    
}
-(void)textFieldTextChange:(UITextField *)textField {
    [self setBtnStatsText:textField.text];
}

- (void)setBtnStatsText:(NSString *)text {
    if (self.moneyTextField.text.length > 0) {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        // 渐变色
        [self.submitBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF8888"],[UIColor colorWithHex:@"#FF4444"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        self.submitBtn.userInteractionEnabled = YES;
    } else {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
        self.submitBtn.userInteractionEnabled = NO;
    }
}


/**
 转账
 */
- (void)onSubmitTransfer {
    
    NSString *money = self.moneyTextField.text;
    if(money.length == 0){
        [MBProgressHUD showTipMessageInWindow:@"请输入提现金额"];
        return;
    }
    money = [NSString stringWithFormat:@"%.02f",[money doubleValue]];
    if([money isEqualToString:@"0.00"]){
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的提现金额"];
        return;
    }
    
    if(![NSString checkIsNum:money]){
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的金额"];
        return;
    }
    
    /// 判断是否设置交易密码
    if (![AppModel sharedInstance].set_trade_password) {
        [self passwordAlert];
        return;
    }
    
    [self goto_PasswordTipPop];

}
- (void)passwordAlert {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"密码未设置" message:@"交易密码未设置，请设置好以后继续操作" preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    alertController.needDialogBlur = YES;
    
    __weak __typeof(self)weakSelf = self;
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"前往设置" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        LoginForgetPsdController *vc = [[LoginForgetPsdController alloc] init];
        vc.updateType = 2;
        vc.navigationItem.title = @"设置交易密码";
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
    // SPAlertActionStyleDestructive默认文字为红色(可修改)
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    // 设置第2个action的颜色
    action2.titleColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)goto_PasswordTipPop {
    PasswordTipController *vc = [[PasswordTipController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
    vc.pwView.delegate = self;
    vc.nameLabel.text = [NSString stringWithFormat:@"向 %@ 转账", self.chatsModel.name];
    vc.moneyLabel.text = self.moneyTextField.text;
}

#pragma mark -  密码完成后提交
- (void)submit {
    
    [self.view endEditing:YES];

    NSDictionary *parameters = @{
                                 @"number":self.moneyTextField.text,
                                 @"password":self.password,
                                 @"comment":self.desTextField.text,
                                 @"user":@(self.chatsModel.userId),   // 接收用户
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"transfer"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
        __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            PayFinishedController *vc = [[PayFinishedController alloc] init];
            [strongSelf presentViewController:vc animated:NO completion:nil];
            vc.nameLabel.text = self.chatsModel.name;
            vc.moneyLabel.text = self.moneyTextField.text;
            vc.onFinishedBlock = ^{
                [strongSelf finished];
            };
            
            if ([strongSelf.delegate respondsToSelector:@selector(didTransferFinished:)]) {
                YPMessage *message = [[YPMessage alloc] init];
                message.userId = [AppModel sharedInstance].user_info.userId;
                message.messageType = MessageType_SendTransfer;
                
                TransferModel *model = [[TransferModel alloc] init];
                model.transfer = [response[@"data"][@"transfer"] integerValue];
                model.title = strongSelf.desTextField.text;
                model.send_Id = [AppModel sharedInstance].user_info.userId;
                model.sendName = [AppModel sharedInstance].user_info.name;
                model.receiveId = strongSelf.chatsModel.userId;
                model.receiveName = strongSelf.chatsModel.name;
                model.money = strongSelf.moneyTextField.text;
                model.cellStatus = TransferCellStatus_Normal;
                message.transferModel = model;
                [strongSelf.delegate didTransferFinished:message];
            }
            
//            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
//            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)finished {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - PWViewDelegate
- (void)passWordBeginInput:(PWView *)passWord {
}
- (void)passWordDidChange:(PWView *)passWord {
    self.password = passWord.textStore;
    NSLog(@"1");
}
- (void)passWordCompleteInput:(PWView *)passWord {
    __weak __typeof(self)weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf submit];
        });
    }];
}



-(void)setupUI {
    
    UIImageView *headImgView = [[UIImageView alloc] init];
    headImgView.image = [UIImage imageNamed:@"cm_default_avatar"];
    headImgView.userInteractionEnabled = YES;
    headImgView.layer.cornerRadius = 5;
    headImgView.layer.masksToBounds = YES;
    [self.view addSubview:headImgView];
    _headImgView = headImgView;
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar+ 15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.equalTo(@(60));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(headImgView.mas_bottom).offset(10);
    }];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgView.mas_bottom).offset(56);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(185);
    }];
    
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [backView addSubview:lineView1];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(100);
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(0.7);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [backView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom).offset(-12);
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(0.7);
    }];
    
    UILabel *ttLabel = [[UILabel alloc] init];
    ttLabel.text = @"转账金额";
    ttLabel.font = [UIFont systemFontOfSize:13];
    ttLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView addSubview:ttLabel];
    
    [ttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(backView.mas_top).offset(15);
    }];
    
    
    UITextField *moneyTextField = [[UITextField alloc] init];
    //    textField.tag = 100;
    //    moneyTextField.backgroundColor = [UIColor grayColor];  // 更改背景颜色
    moneyTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    moneyTextField.font = [UIFont boldSystemFontOfSize:40.0];  // 字体
    moneyTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    //    moneyTextField.placeholder = @"请输入转账金额"; // 占位文字
    moneyTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    moneyTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
    moneyTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [backView addSubview:moneyTextField];
    _moneyTextField = moneyTextField;
    [moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(60);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.bottom.equalTo(lineView1.mas_top).offset(-5);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"￥";
    sLabel.font = [UIFont boldSystemFontOfSize:35];
    sLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView addSubview:sLabel];
    
    [sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(moneyTextField.mas_centerY);
    }];
    
    UILabel *sgLabel = [[UILabel alloc] init];
    sgLabel.text = @"添加转账说明";
    sgLabel.font = [UIFont systemFontOfSize:13];
    sgLabel.textColor = [UIColor redColor];
    [backView addSubview:sgLabel];
    
    [sgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(lineView1.mas_bottom).offset(8);
    }];
    
    UITextField *desTextField = [[UITextField alloc] init];
    //    textField.tag = 100;
    //    desTextField.backgroundColor = [UIColor grayColor];  // 更改背景颜色
    desTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    desTextField.font = [UIFont systemFontOfSize:15.0];  // 字体
    desTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    desTextField.placeholder = @"转账说明"; // 占位文字
    desTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    desTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    desTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    desTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [backView addSubview:desTextField];
    _desTextField = desTextField;
    [desTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.bottom.equalTo(lineView2.mas_top).offset(-2);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"转账" forState:UIControlStateNormal];
    //    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitTransfer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(backView.mas_bottom).offset(35);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
}

@end
