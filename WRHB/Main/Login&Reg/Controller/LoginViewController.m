//
//  LoginViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "LoginViewController.h"
#import <SDCycleScrollView.h>
#import "RegisterViewController.h"
#import "LoginForgetPsdController.h"


#import "DHGuidePageHUD.h"
#import "AppDelegate.h"
#import "UIDevice+BAKit.h"

#import "BannerModels.h"
#import "BannerModel.h"
#import <SAMKeychain.h>
#import "SPAlertController.h"


@interface LoginViewController ()<SDCycleScrollViewDelegate>

///
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/// 图片数组
@property (nonatomic, strong) NSArray *imagesURLStrings;
///
@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UITextField *accountTextField;
///
@property (nonatomic, strong) UITextField *passwordTextField;
///
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *regBtn;
/// 试用用户 游客登录
@property (nonatomic, strong) UIButton *trialBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置APP引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        // 静态引导页
//        [self setStaticGuidePage];
        
        // 动态引导页
//         [self setDynamicGuidePage];
        
        // 视频引导页
        // [self setVideoGuidePage];
    }
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getBannerData];
    
    [self setupUI];
    [self setNavUI];
    
}

- (void)setNavUI {
    if ([AppModel sharedInstance].isDebugMode) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, Height_NavBar -20-16, kSCREEN_WIDTH, 14)];
        label.text = [NSString stringWithFormat:@"测试服:%@",[AppModel sharedInstance].serverApiUrl];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self.navigationController.navigationBar addSubview:label];
        label.textColor = [UIColor redColor];
    }
}

-(void)viewDidAppear:(BOOL)animated {
     [super viewDidAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [ud objectForKey:@"mobile"];
    
    if (mobile.length > 0) {
        self.accountTextField.text = mobile;
    }
    
    if([AppModel sharedInstance].isDebugMode) {
        self.passwordTextField.text = @"123456";
    }
    if (self.accountTextField.text.length == 0) {
        [self.accountTextField becomeFirstResponder];
    } else if(self.passwordTextField.text.length == 0) {
        [self.passwordTextField becomeFirstResponder];
    }
}



#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = @[@"guideImage1.jpg",@"guideImage2.jpg",@"guideImage3.jpg",@"guideImage4.jpg",@"guideImage5.jpg"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark - 设置APP动态图片引导页
- (void)setDynamicGuidePage {
    NSArray *imageNameArray = @[@"image11.gif",@"image12.gif"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:YES];
    guidePage.slideInto = YES;
    [self.navigationController.view addSubview:guidePage];
}

#pragma mark - 设置APP视频引导页
- (void)setVideoGuidePage {
    NSURL *videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guideMovie1" ofType:@"mov"]];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.bounds videoURL:videoURL];
    [self.navigationController.view addSubview:guidePage];
}



- (void)getBannerData {
    
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/banner/login"];
        entity.needCache = NO;

//        [MBProgressHUD showActivityMessageInView:nil];
        __weak __typeof(self)weakSelf = self;
        [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideHUD];
            if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
                BannerModels* model = [BannerModels mj_objectWithKeyValues:response[@"data"]];
                [strongSelf analysisData:model];
                
            } else {
                [[AFHttpError sharedInstance] handleFailResponse:response];
            }
        } failureBlock:^(NSError *error) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideHUD];
            [[AFHttpError sharedInstance] handleFailResponse:error];
        } progressBlock:nil];
    
}

- (void)analysisData:(BannerModels *)models {
    NSMutableArray *bannerUrlArray = [NSMutableArray array];
    for (BannerModel *model in models.banners) {
        [bannerUrlArray addObject:model.img_url];
    }
    self.cycleScrollView.imageURLStringsGroup = bannerUrlArray;
}

- (void)setBannerUI {
    
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.contentView addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;

}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}


- (void)setupUI {
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT -Height_NavBar - kiPhoneX_Bottom_Height)];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor = [UIColor redColor];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        // // 解决UIScrollView偏移64的问题 AFan  https://www.jianshu.com/p/311674ba806b
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.mas_equalTo(kSCREEN_HEIGHT -Height_NavBar - kiPhoneX_Bottom_Height);
    }];
    
    [self setBannerUI];
    
    UIView *textFieldbackView = [[UIView alloc] init];
    textFieldbackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:textFieldbackView];
    
    [textFieldbackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(40);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(110);
    }];
    UIView *verView1 = [[UIView alloc] init];
    verView1.backgroundColor = [UIColor clearColor];
    [textFieldbackView addSubview:verView1];
    
    [verView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(textFieldbackView);
        make.height.mas_equalTo(54);
    }];
    // 分割线
    UIView *lingView = [[UIView alloc] init];
    lingView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
    [textFieldbackView addSubview:lingView];
    
    [lingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView1.mas_bottom);
        make.left.equalTo(textFieldbackView.mas_left).offset(20);
        make.right.equalTo(textFieldbackView.mas_right);
        make.height.mas_equalTo(1);
    }];
    UIView *verView2 = [[UIView alloc] init];
    verView2.backgroundColor = [UIColor clearColor];
    [textFieldbackView addSubview:verView2];
    
    [verView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(textFieldbackView);
        make.height.mas_equalTo(54);
    }];
    
    UIImageView *phoneImageView = [[UIImageView alloc] init];
    phoneImageView.image = [UIImage imageNamed:@"login_phone"];
    [verView1 addSubview:phoneImageView];
    
    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verView1.mas_centerY);
        make.left.equalTo(verView1.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 21));
    }];
    
    UIImageView *psdImageView = [[UIImageView alloc] init];
    psdImageView.image = [UIImage imageNamed:@"login_possword"];
    [verView2 addSubview:psdImageView];
    
    [psdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verView2.mas_centerY);
        make.left.equalTo(verView2.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 18));
    }];
    
    
    UITextField *accountTextField = [[UITextField alloc] init];
    accountTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    accountTextField.font = [UIFont boldSystemFontOfSize:14.0];  // 字体
    accountTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    accountTextField.placeholder = @"请输入手机号"; // 占位文字
    accountTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    accountTextField.delegate = self;
    accountTextField.keyboardType = UIKeyboardTypePhonePad; // 键盘类型
    accountTextField.returnKeyType = UIReturnKeyGo;
    //    textField.secureTextEntry = YES; // 密码
    [verView1 addSubview:accountTextField];
    _accountTextField = accountTextField;
    
    [accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verView1.mas_centerY);
        make.left.equalTo(verView1.mas_left).offset(50);
        make.right.equalTo(verView1.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    passwordTextField.font = [UIFont boldSystemFontOfSize:14.0];  // 字体
    passwordTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    passwordTextField.placeholder = @"请输入密码"; // 占位文字
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    passwordTextField.delegate = self;
    passwordTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    passwordTextField.returnKeyType = UIReturnKeyGo;
    passwordTextField.secureTextEntry = YES; // 密码
    [verView2 addSubview:passwordTextField];
    _passwordTextField = passwordTextField;
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verView2.mas_centerY);
        make.left.equalTo(verView2.mas_left).offset(50);
        make.right.equalTo(verView2.mas_right).offset(-20);
        make.height.mas_equalTo(@(40));
    }];
    
    
    
    UIButton *forGot = [UIButton new];
    [self.contentView addSubview:forGot];
    [forGot addTarget:self action:@selector(action_forgot) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"忘记密码?"];
    NSRange rang = NSMakeRange(0, 5);
    [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize2:13] range:rang];
    [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#666666"] range:rang];
    //[AttributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:rang];
    
    [forGot setAttributedTitle:AttributedStr forState:UIControlStateNormal];
    [forGot delayEnable];
    [forGot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(textFieldbackView.mas_bottom).offset(10);
        make.width.equalTo(@70);
        make.height.equalTo(@(30));
    }];
    
    UIButton *trialBtn = [UIButton new];
    [self.contentView addSubview:trialBtn];
    trialBtn.layer.cornerRadius = 5;
    trialBtn.layer.borderWidth = 0.5;
    trialBtn.layer.borderColor = COLOR_X(230, 230, 230).CGColor;
    trialBtn.layer.masksToBounds = YES;
    trialBtn.backgroundColor = COLOR_X(254, 254, 254);
    trialBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [trialBtn setTitle:@"注册" forState:UIControlStateNormal];
    [trialBtn setTitleColor:COLOR_X(120, 120, 120) forState:UIControlStateNormal];
    //    regBtn.hidden = YES;
    [trialBtn addTarget:self action:@selector(action_register) forControlEvents:UIControlEventTouchUpInside];
    [trialBtn delayEnable];
    _regBtn = trialBtn;
    
    [trialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
        make.top.equalTo(textFieldbackView.mas_bottom).offset(45);
        make.height.equalTo(@(44));
    }];
    
    UIButton *regBtn = [UIButton new];
    [self.contentView addSubview:regBtn];
    regBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:12];
    [regBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor colorWithHex:@"#FF4444"] forState:UIControlStateNormal];
    //    regBtn.hidden = YES;
    [regBtn addTarget:self action:@selector(action_trialBtnLogin) forControlEvents:UIControlEventTouchUpInside];
    [regBtn delayEnable];
    _trialBtn = regBtn;
    
    [regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(trialBtn.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    UIButton *loginBtn = [UIButton new];
    [self.contentView addSubview:loginBtn];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = [UIColor redColor];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(action_login) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn delayEnable];
    _loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(textFieldbackView.mas_bottom).offset(45);
        make.height.equalTo(@(44));
    }];
    
    
    
    
    UILabel *ttLabel = [[UILabel alloc] init];
    ttLabel.text = @"抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身体。合理安排时间，享受健康生活。";
    ttLabel.font = [UIFont systemFontOfSize:12];
    ttLabel.adjustsFontSizeToFitWidth = YES;
    ttLabel.textColor = [UIColor colorWithHex:@"#666666"];
    ttLabel.numberOfLines = 2;
    ttLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ttLabel];
    
    [ttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-46);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    UILabel *ypLabel = [[UILabel alloc] init];
    ypLabel.text = @"一品科技股份有限公司     www.ypgames.com";
    ypLabel.font = [UIFont systemFontOfSize:10];
    ypLabel.textColor = [UIColor colorWithHex:@"#999999"];
    ypLabel.numberOfLines = 0;
    ypLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ypLabel];
    
    [ypLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
}

- (void)accountSwitch {
    __weak __typeof(self)weakSelf = self;
    [self.view endEditing:YES];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择服务器地址" preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *arr = [[AppModel sharedInstance] ipArray];
    
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        NSString *bankName = dic[@"apiUrl"];
        [newArr addObject:bankName];
    }
    
    [self actionSheetArray:newArr];
}

- (void)actionSheetArray:(NSArray *)array {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"切换服务器" message:nil preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.needDialogBlur = YES;
    
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSInteger serverIndex = [[ud objectForKey:@"serverIndex"] integerValue];
    
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:[NSString stringWithFormat:@"生产:%@", array[0]] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        [self saveSwitchValue:0];
    }];
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:[NSString stringWithFormat:@"测试:%@", array[1]] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        [self saveSwitchValue:1];
    }];
    
    SPAlertAction *action3 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了Cancel");
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3]; // 取消按钮一定排在最底部
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)saveSwitchValue:(NSInteger)index {
    NSArray *arr = [[AppModel sharedInstance] ipArray];
    if(index > arr.count) {
         return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:INT_TO_STR(index) forKey:@"serverIndex"];
    [ud synchronize];
    [MBProgressHUD showTipMessageInWindow:@"切换成功，重启生效"];
    [[FunctionManager sharedInstance] performSelector:@selector(exitApp) withObject:nil afterDelay:1.0];
}


#pragma mark -  游客登录
- (void)action_trialBtnLogin {
    
    NSDictionary *parameters = @{
                                 @"device_id":[UIDevice uniqueIdentifier]
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"touristLogin"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf updateUserInfo:response[@"data"]];
            
            //
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)action_forgot {
    NSLog(@"忘记密码");
    LoginForgetPsdController *vc = [[LoginForgetPsdController alloc] init];
    vc.navigationItem.title = @"找回密码";
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark -  登录
- (void)action_login {
    
    if([self.accountTextField.text isEqualToString:@"#888999"]) {
        [self accountSwitch];
        return;
    }
    
    if (self.accountTextField.text.length < 8) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的手机号"];
        return;
    }
    if (self.passwordTextField.text.length < 3) {
        [MBProgressHUD showTipMessageInWindow:@"请入密码"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"mobile":self.accountTextField.text,
                                 @"password":self.passwordTextField.text,
                                 @"device_type":@"1"  // 设备类型 1 苹果 2 安卓
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"loginByMobile"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf updateUserInfo:response[@"data"]];
            
            // 
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}
- (void)action_register {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 更新用户信息
 */
-(void)updateUserInfo:(NSDictionary *)dict {
    [MBProgressHUD showSuccessMessage:@"登录成功"];
    AppModel *appModel = [AppModel mj_objectWithKeyValues:dict];
    
    [AppModel sharedInstance].token = appModel.token;
    [AppModel sharedInstance].user_info = appModel.user_info;
    [AppModel sharedInstance].assets = appModel.assets;
    
    [AppModel sharedInstance].user_info.isLogined = YES;
    
    [[AppModel sharedInstance] saveAppModel];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(appModel.user_info.userId) forKey:@"userId"];
    [ud setObject:appModel.user_info.mobile forKey:@"mobile"];
    [ud synchronize];
    
    [SAMKeychain setPassword:self.passwordTextField.text forService:@"password" account:self.accountTextField.text];
    
    
   AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate setRootViewController];
}


@end






