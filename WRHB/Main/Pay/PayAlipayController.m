//
//  PayAlipayController.m
//  WRHB
//
//  Created by AFan on 2019/12/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayAlipayController.h"
#import "UIView+AZGradient.h"  // 渐变色
#import "PayTopupModel.h"
#import "TopupDetailsModel.h"
#import "SPAlertController.h"

@interface PayAlipayController ()

///
@property (nonatomic, strong) UIImageView *iconImg;
///
@property (nonatomic, strong) UILabel *moneyLabel;
/// 收款姓名
@property (nonatomic, strong) UILabel *receiNameLabel;
/// 付款姓名
@property (nonatomic, strong) UITextField *nameTextField;
/// 二维码
@property (nonatomic, strong) UIImageView *qrImgView;


@end

@implementation PayAlipayController

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
    self.navigationItem.title = @"支付宝存款";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    
    [self setupUI];
    [self setViewData];
}

/**
 提交支付
 */
- (void)onSubmitBtn {
    
    if (self.nameTextField.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入付款姓名"];
        return;
    }
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
        self.iconImg.image = [UIImage imageNamed:@"pay_alipay_icon"];
    } else {
        [self.iconImg cd_setImageWithURL:[NSURL URLWithString:self.detailsModel.icon] placeholderImage:[UIImage imageNamed:@"pay_alipay_icon"]];
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", self.detailsModel.money];
    self.receiNameLabel.text = self.detailsModel.qrcode_name;
    [self.qrImgView cd_setImageWithURL:[NSURL URLWithString:self.detailsModel.qrcode_url] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
}

/**
 保存
 */
-(void)longPressAction:(UILongPressGestureRecognizer*)sender {
    [self actionSheetAction];
}

- (void)actionSheetAction {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.needDialogBlur = YES;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"保存相册" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        UIImage *image = [self imageWithUIView:self.qrImgView];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了Cancel");
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:^{}];
}


#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [MBProgressHUD showSuccessMessage:msg];
}

- (UIImage*) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

/**
 复制
 */
-(void)onCopyAction:(UIButton *)sender {
    
    NSString *text = nil;
    if (sender.tag == 4000) {
        text = self.receiNameLabel.text;
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
    topImgView.image = [UIImage imageNamed:@"pay_alipay_topbg"];
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
    //    iconImg.backgroundColor = [UIColor redColor];
    iconImg.image = [UIImage imageNamed:@"pay_alipay_icon"];
    [backView addSubview:iconImg];
    _iconImg = iconImg;
    
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(10);
        make.left.equalTo(backView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(67, 65));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"当前使用支付宝方式存款";
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImg.mas_centerY);
        make.left.equalTo(iconImg.mas_right).offset(10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"尊敬的用户您好，您的存款订单已生成，请记录以下官方账户信息以及存款金额，并尽快登录您的支付宝进行转账，转账完成后请保留银行或APP回执，以遍确认转账信息。";
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor colorWithHex:@"#333333"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImg.mas_bottom).offset(15);
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
    moneyLabel.font = [UIFont boldSystemFontOfSize:24];
    moneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [midBgView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(midBgView.mas_centerY);
        make.left.equalTo(titLabel.mas_right).offset(5);
        make.right.equalTo(midBgView.mas_right).offset(-20);
    }];
    
    
    UIImageView *bottomImgBgView = [[UIImageView alloc] init];
    bottomImgBgView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"pay_alipay_qrbg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    bottomImgBgView.image = image;
    //    bottomImgBgView.backgroundColor = [UIColor whiteColor];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];//初始化一个长按手势
    [longPress setMinimumPressDuration:1];//设置按多久之后触发事件
    [bottomImgBgView addGestureRecognizer:longPress];//把长按手势添加给按钮
    
    [self.view addSubview:bottomImgBgView];
    
    [bottomImgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(283.5);
    }];
    
    CGFloat titleTextSpacing = 10;
    
    
    //    UIImage *img = CD_QrImg(self.detailsModel.qrcode_url, 800);
    UIImageView *qrImgView = [[UIImageView alloc] init];
    qrImgView.userInteractionEnabled = YES;
    [bottomImgBgView addSubview:qrImgView];
    _qrImgView = qrImgView;
    //    [qrImgView setImage:img];
    NSInteger width = 136;
    [qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.centerX.equalTo(bottomImgBgView.mas_centerX);
        make.top.equalTo(bottomImgBgView.mas_top).offset(15);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"长按保存二维码，打开支付宝扫一扫选择扫描本地图片";
    tipLabel.textColor = [UIColor colorWithHex:@"#333333"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:11];
    [bottomImgBgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomImgBgView);
        make.top.equalTo(qrImgView.mas_bottom).offset(10);
    }];
    
    
    
    UIButton *copyBtn = [UIButton new];
    [bottomImgBgView addSubview:copyBtn];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(onCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.cornerRadius = 5;
    copyBtn.tag = 4003;
    [copyBtn az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(10);
        make.right.equalTo(bottomImgBgView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
    
    UILabel *titreLabel = [[UILabel alloc] init];
    titreLabel.text = @"收款姓名:";
    titreLabel.font = [UIFont systemFontOfSize:15];
    titreLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titreLabel.textAlignment = NSTextAlignmentLeft;
    [ bottomImgBgView addSubview:titreLabel];
    
    [titreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyBtn.mas_centerY);
        make.left.equalTo(bottomImgBgView.mas_left).offset(20);
    }];
    
    UILabel *receiNameLabel = [[UILabel alloc] init];
    receiNameLabel.text = @"-";
    receiNameLabel.font = [UIFont systemFontOfSize:15];
    receiNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    receiNameLabel.textAlignment = NSTextAlignmentLeft;
    [ bottomImgBgView addSubview:receiNameLabel];
    _receiNameLabel = receiNameLabel;
    
    [receiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(copyBtn.mas_centerY);
        make.left.equalTo(titreLabel.mas_right).offset(titleTextSpacing);
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
    [ bottomImgBgView addSubview:nameTextField];
    _nameTextField = nameTextField;
    
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(copyBtn.mas_bottom).offset(12);
        make.left.equalTo(bottomImgBgView.mas_left).offset(95);
        make.right.equalTo(bottomImgBgView.mas_right).offset(-20);
        make.height.mas_equalTo(@(35));
    }];
    
    UILabel *tit5Label = [[UILabel alloc] init];
    tit5Label.text = @"付款姓名:";
    tit5Label.font = [UIFont systemFontOfSize:15];
    tit5Label.textColor = [UIColor colorWithHex:@"#333333"];
    tit5Label.textAlignment = NSTextAlignmentLeft;
    [ bottomImgBgView addSubview:tit5Label];
    
    [tit5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameTextField.mas_centerY);
        make.left.equalTo(bottomImgBgView.mas_left).offset(20);
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
        make.top.equalTo( bottomImgBgView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
}




@end

