//
//  PasswordTipController.m
//  WRHB
//
//  Created by AFan on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "PasswordTipController.h"
#import "VVAlertModel.h"
#import "NSString+Size.h"
#import "WitAlertTextCell.h"
#import "PayAssetsModel.h"
#import "WithdrawBankModel.h"
#import "PWView.h"

@interface PasswordTipController ()
{
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *lskcLabel;



@end

@implementation PasswordTipController


- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    
    _contentMargin = UIEdgeInsetsMake(25, 20, 0, 20);
    _contentViewWidth = kSCREEN_WIDTH -30*2;
    _buttonHeight = 45;
    _firstDisplay = YES;
    //    _messageAlignment = NSTextAlignmentCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.bgView];
    
    //创建对话框
    [self creatShadowView];
    [self creatContentView];
    
    
    //    self.titleLabel.text = self.titleStr;
    
}


- (void)onCancelBtn {
    [self hidDisappearAnimation];
}
- (void)onCloseBtn {
    [self hidDisappearAnimation];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];
    //显示弹出动画
    [self showAppearAnimation];
}


#pragma mark - 显示弹出动画
- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.bgView.alpha = 0.0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.shadowView.transform = CGAffineTransformIdentity;
            self.shadowView.alpha = 1;
            self.bgView.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - 事件响应
- (void)didClickCloseBtn:(UIButton *)sender {
    //    CKAlertAction *action = self.actions[sender.tag-10];
    //    if (action.actionHandler) {
    //        action.actionHandler(action);
    //    }
    
    [self hidDisappearAnimation];
}


#pragma mark - 消失动画
- (void)hidDisappearAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.contentView.alpha = 0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)onShadowViewDisappear {
    //    [self hidDisappearAnimation];
}
- (void)onContentViewDisappear {
    NSLog(@"1");
}


#pragma mark - 创建内部视图

//阴影层
- (void)creatShadowView {
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    self.shadowView.layer.shadowRadius = 20;
    self.shadowView.layer.shadowOpacity = 1;
    [self.bgView addSubview:self.shadowView];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShadowViewDisappear)];
    //将手势添加到需要相应的view中去
    [self.shadowView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
}

//内容层
- (void)creatContentView {
    
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
    
    
    CGFloat contentViewHeight = 255;
    
    UIView *contentView = [[UIView alloc] init];
    //    contentView.userInteractionEnabled = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    contentView.layer.masksToBounds = YES;
    [self.shadowView addSubview:contentView];
    _contentView = contentView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shadowView.mas_top).offset(Height_NavBar+15);
        make.centerX.equalTo(self.shadowView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH-30*2, contentViewHeight));
    }];
    
    
    UILabel *tpLabel = [[UILabel alloc] init];
    tpLabel.text = @"请输入交易密码";
    tpLabel.font = [UIFont systemFontOfSize:15];
    tpLabel.textColor = [UIColor colorWithHex:@"#343434"];
    tpLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:tpLabel];
    
    [tpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(15);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#000000"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tpLabel.mas_bottom).offset(20);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    
    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"￥";
    sLabel.font = [UIFont boldSystemFontOfSize:35];
    sLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [contentView addSubview:sLabel];
    
    [sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(20);
        make.centerX.equalTo(contentView.mas_centerX).offset(-90);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont boldSystemFontOfSize:42];
    moneyLabel.textColor = [UIColor colorWithHex:@"#343434"];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sLabel.mas_centerY);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    
    UILabel *ttpLabel = [[UILabel alloc] init];
    ttpLabel.text = @"支付方式";
    ttpLabel.font = [UIFont systemFontOfSize:15];
    ttpLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [contentView addSubview:ttpLabel];
    
    [ttpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sLabel.mas_bottom).offset(15);
        make.left.equalTo(contentView.mas_left).offset(16);
    }];
    
    UILabel *tyetLabel = [[UILabel alloc] init];
    tyetLabel.text = @"余额";
    tyetLabel.font = [UIFont systemFontOfSize:15];
    tyetLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [contentView addSubview:tyetLabel];
    
    [tyetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ttpLabel.mas_centerY);
        make.right.equalTo(contentView.mas_right).offset(-20);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"ts_money"];
    [contentView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tyetLabel.mas_centerY);
        make.right.equalTo(tyetLabel.mas_left).offset(-5);
        make.size.mas_equalTo(25);
    }];
    
//    UILabel *tqpLabel = [[UILabel alloc] init];
//    tqpLabel.text = @"流水扣除";
//    tqpLabel.font = [UIFont systemFontOfSize:15];
//    tqpLabel.textColor = [UIColor colorWithHex:@"#343434"];
//    [contentView addSubview:tqpLabel];
//    
//    [tqpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(ttpLabel.mas_bottom).offset(20);
//        make.left.equalTo(ttpLabel.mas_left);
//    }];
//    
//    UILabel *lskcLabel = [[UILabel alloc] init];
//    lskcLabel.text = @"-";
//    lskcLabel.font = [UIFont systemFontOfSize:15];
//    lskcLabel.textColor = [UIColor colorWithHex:@"#343434"];
//    [contentView addSubview:lskcLabel];
//    _lskcLabel = lskcLabel;
//    
//    [lskcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(tqpLabel.mas_centerY);
//        make.right.equalTo(contentView.mas_right).offset(-20);
//    }];
    
    PWView *pwView = [[PWView alloc] initWithFrame:CGRectMake(20, contentViewHeight-70-5, kSCREEN_WIDTH-30*2 - 20*2, 70)];
    pwView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:pwView];
    _pwView = pwView;
    
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"pay_tx_tips_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(onCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    [closeBtn delayEnable];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(17);
        make.top.equalTo(self->_contentView.mas_top).offset(12.5);
        make.right.equalTo(self->_contentView.mas_right).offset(-12.5);
    }];
}


@end




