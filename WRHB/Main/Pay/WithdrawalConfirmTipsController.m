//
//  WithdrawalConfirmTipsController.m
//  WRHB
//
//  Created by AFan on 2019/12/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "WithdrawalConfirmTipsController.h"
#import "VVAlertModel.h"
#import "NSString+Size.h"
#import "WitAlertTextCell.h"
#import "PayAssetsModel.h"
#import "WithdrawBankModel.h"

@interface WithdrawalConfirmTipsController ()
{
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;

@property (strong, nonatomic) UILabel *moneyLabel1;
@property (strong, nonatomic) UILabel *sxfLabel2;
@property (strong, nonatomic) UILabel *xzfLabel3;
@property (strong, nonatomic) UILabel *dzMoneyLabel;
@property (strong, nonatomic) UILabel *txBankLabel;
@property (strong, nonatomic) UILabel *skrNameLabel;
//@property (strong, nonatomic) UILabel *xzfLabel2;
//@property (strong, nonatomic) UILabel *xzfLabel2;

@property (strong, nonatomic) UIButton *submitBtn;
@property (strong, nonatomic) UILabel *titLabel2;


@end

@implementation WithdrawalConfirmTipsController


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


- (void)setAssetsModel:(PayAssetsModel *)assetsModel {
    self.moneyLabel1.text = self.txMoney;
    self.sxfLabel2.text = assetsModel.fee_rate;
    self.xzfLabel3.text = assetsModel.cost;
    
    CGFloat dzMoney = 0;
    if (self.txType == 1) {
        dzMoney = [self.txMoney floatValue] - [assetsModel.fee_rate floatValue];
        self.titLabel2.text = @"提现手续费";
    } else {
        dzMoney = [self.txMoney floatValue] - [assetsModel.cost_fee floatValue]- [assetsModel.cost floatValue];
        self.titLabel2.text = @"行政手续费";
    }
    self.dzMoneyLabel.text = [NSString stringWithFormat:@"%0.2f", dzMoney];
    self.txBankLabel.text = self.selectBankModel.bank_name;
    self.skrNameLabel.text = self.selectBankModel.cardholder;
}

#pragma mark -  确认
- (void)onSubmitBtn {
    [self hidDisappearAnimation];
    if (self.onSubmitBtnBlock) {
        self.onSubmitBtnBlock();
    }
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
    
    CGFloat contentViewHeight = 420;
    if (self.txType == 1) {
        contentViewHeight = 370;
    }
    
    UIView *contentView = [[UIView alloc] init];
    //    contentView.userInteractionEnabled = NO;
    contentView.backgroundColor = [UIColor colorWithHex:@"#F6F6F6"];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    contentView.layer.masksToBounds = YES;
    [self.shadowView addSubview:contentView];
    _contentView = contentView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shadowView.mas_centerY);
        make.centerX.equalTo(self.shadowView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(302, contentViewHeight));
    }];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onContentViewDisappear)];
    //将手势添加到需要相应的view中去
    [_contentView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UIImageView *titHeadImgView = [[UIImageView alloc] init];
    titHeadImgView.image = [UIImage imageNamed:@"pay_tx_tips_title"];
    [self.shadowView addSubview:titHeadImgView];
    
    [titHeadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shadowView.mas_centerX);
        make.centerY.equalTo(contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(190, 46));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"温馨提示";
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titHeadImgView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titHeadImgView);
    }];
    
    
    
    
    CGFloat marWidht = 10;
    CGFloat cellHeight = 45;
    CGFloat mrHeight = 7;
    
    /// ********* 1 *********
    UIView *backView1 = [[UIView alloc] init];
    backView1.layer.cornerRadius = 5;
    backView1.layer.masksToBounds = YES;
    backView1.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView1];
    
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titHeadImgView.mas_bottom).offset(20);
        make.left.equalTo(contentView.mas_left).offset(marWidht);
        make.right.equalTo(contentView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UILabel *titLabel1 = [[UILabel alloc] init];
    titLabel1.text = @"提现金额";
    titLabel1.font = [UIFont systemFontOfSize:15];
    titLabel1.textColor = [UIColor colorWithHex:@"#333333"];
    [backView1 addSubview:titLabel1];
    
    [titLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(backView1.mas_left).offset(10);
    }];
    
    UILabel *moneyLabel1 = [[UILabel alloc] init];
    moneyLabel1.text = @"-";
    moneyLabel1.font = [UIFont systemFontOfSize:15];
    moneyLabel1.textColor = [UIColor colorWithHex:@"#333333"];
    moneyLabel1.textAlignment = NSTextAlignmentRight;
    [backView1 addSubview:moneyLabel1];
    _moneyLabel1 = moneyLabel1;
    
    [moneyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.right.equalTo(backView1.mas_right).offset(-10);
    }];
    
    
    /// ********* 2 *********
    UIView *backView2 = [[UIView alloc] init];
    backView2.layer.cornerRadius = 5;
    backView2.layer.masksToBounds = YES;
    backView2.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView1.mas_bottom).offset(mrHeight);
        make.left.equalTo(contentView.mas_left).offset(marWidht);
        make.right.equalTo(contentView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UILabel *titLabel2 = [[UILabel alloc] init];
    titLabel2.text = @"提现手续费";
    titLabel2.font = [UIFont systemFontOfSize:15];
    titLabel2.textColor = [UIColor colorWithHex:@"#333333"];
    [backView2 addSubview:titLabel2];
    _titLabel2 = titLabel2;
    
    [titLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(backView2.mas_left).offset(10);
    }];
    
    UILabel *sxfLabel2 = [[UILabel alloc] init];
    sxfLabel2.text = @"-";
    sxfLabel2.font = [UIFont systemFontOfSize:15];
    sxfLabel2.textColor = [UIColor colorWithHex:@"#333333"];
    sxfLabel2.textAlignment = NSTextAlignmentRight;
    [backView2 addSubview:sxfLabel2];
    _sxfLabel2 = sxfLabel2;
    
    [sxfLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.right.equalTo(backView2.mas_right).offset(-10);
    }];
    
   
    /// ********* 3 *********
    UIView *backView3 = [[UIView alloc] init];
    backView3.layer.cornerRadius = 5;
    backView3.layer.masksToBounds = YES;
    backView3.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView3];
    
    [backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView2.mas_bottom).offset(mrHeight);
        make.left.equalTo(contentView.mas_left).offset(marWidht);
        make.right.equalTo(contentView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UILabel *titLabel3 = [[UILabel alloc] init];
    titLabel3.text = @"提现行政费";
    titLabel3.font = [UIFont systemFontOfSize:15];
    titLabel3.textColor = [UIColor colorWithHex:@"#333333"];
    [backView3 addSubview:titLabel3];
    
    [titLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_left).offset(10);
    }];
    
    UILabel *xzfLabel3 = [[UILabel alloc] init];
    xzfLabel3.text = @"-";
    xzfLabel3.font = [UIFont systemFontOfSize:15];
    xzfLabel3.textColor = [UIColor colorWithHex:@"#333333"];
    xzfLabel3.textAlignment = NSTextAlignmentRight;
    [backView3 addSubview:xzfLabel3];
    _xzfLabel3 = xzfLabel3;
    
    [xzfLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.right.equalTo(backView3.mas_right).offset(-10);
    }];
    
    /// ********* 4 *********
    UIView *backView4 = [[UIView alloc] init];
    backView4.layer.cornerRadius = 5;
    backView4.layer.masksToBounds = YES;
    backView4.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView4];
    
    
    
    if (self.txType == 2) {
        [backView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView3.mas_bottom).offset(6);
            make.left.equalTo(contentView.mas_left).offset(marWidht);
            make.right.equalTo(contentView.mas_right).offset(-marWidht);
            make.height.mas_equalTo(cellHeight);
        }];
    } else {
        backView3.hidden = YES;
        [backView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView2.mas_bottom).offset(6);
            make.left.equalTo(contentView.mas_left).offset(marWidht);
            make.right.equalTo(contentView.mas_right).offset(-marWidht);
            make.height.mas_equalTo(cellHeight);
        }];
    }
    
    
    UILabel *titLabel4 = [[UILabel alloc] init];
    titLabel4.text = @"到账金额";
    titLabel4.font = [UIFont systemFontOfSize:15];
    titLabel4.textColor = [UIColor colorWithHex:@"#333333"];
    [backView4 addSubview:titLabel4];
    
    [titLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(backView4.mas_left).offset(10);
    }];
    
    UILabel *dzMoneyLabel = [[UILabel alloc] init];
    dzMoneyLabel.text = @"-";
    dzMoneyLabel.font = [UIFont systemFontOfSize:15];
    dzMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
    dzMoneyLabel.textAlignment = NSTextAlignmentRight;
    [backView4 addSubview:dzMoneyLabel];
    _dzMoneyLabel = dzMoneyLabel;
    
    [dzMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.right.equalTo(backView4.mas_right).offset(-10);
    }];
    
    /// ********* 5 *********
    UIView *backView5 = [[UIView alloc] init];
    backView5.layer.cornerRadius = 5;
    backView5.layer.masksToBounds = YES;
    backView5.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView5];
    
    [backView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView4.mas_bottom).offset(6);
        make.left.equalTo(contentView.mas_left).offset(marWidht);
        make.right.equalTo(contentView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UILabel *titLabel5 = [[UILabel alloc] init];
    titLabel5.text = @"提现银行";
    titLabel5.font = [UIFont systemFontOfSize:15];
    titLabel5.textColor = [UIColor colorWithHex:@"#333333"];
    [backView5 addSubview:titLabel5];
    
    [titLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView5.mas_centerY);
        make.left.equalTo(backView5.mas_left).offset(10);
    }];
    
    UILabel *txBankLabel = [[UILabel alloc] init];
    txBankLabel.text = @"-";
    txBankLabel.font = [UIFont systemFontOfSize:15];
    txBankLabel.textColor = [UIColor colorWithHex:@"#333333"];
    txBankLabel.textAlignment = NSTextAlignmentRight;
    [backView5 addSubview:txBankLabel];
    _txBankLabel = txBankLabel;
    
    [txBankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView5.mas_centerY);
        make.right.equalTo(backView5.mas_right).offset(-10);
    }];
    
    /// ********* 6 *********
    UIView *backView6 = [[UIView alloc] init];
    backView6.layer.cornerRadius = 5;
    backView6.layer.masksToBounds = YES;
    backView6.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView6];
    
    [backView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView5.mas_bottom).offset(6);
        make.left.equalTo(contentView.mas_left).offset(marWidht);
        make.right.equalTo(contentView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UILabel *titLabel6 = [[UILabel alloc] init];
    titLabel6.text = @"收款人";
    titLabel6.font = [UIFont systemFontOfSize:15];
    titLabel6.textColor = [UIColor colorWithHex:@"#333333"];
    [backView6 addSubview:titLabel6];
    
    [titLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView6.mas_centerY);
        make.left.equalTo(backView6.mas_left).offset(10);
    }];
    
    UILabel *skrNameLabel = [[UILabel alloc] init];
    skrNameLabel.text = @"-";
    skrNameLabel.font = [UIFont systemFontOfSize:15];
    skrNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    skrNameLabel.textAlignment = NSTextAlignmentRight;
    [backView6 addSubview:skrNameLabel];
    _skrNameLabel = skrNameLabel;
    
    [skrNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView6.mas_centerY);
        make.right.equalTo(backView6.mas_right).offset(-10);
    }];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.layer.cornerRadius = 40/2;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:cancelBtn];
    [cancelBtn delayEnable];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 40));
        make.left.equalTo(self->_contentView.mas_left).offset(15);
        make.bottom.equalTo(self->_contentView.mas_bottom).offset(-15);
    }];
    
    UIButton *submitBtn = [UIButton new];
    //    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 40/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor colorWithHex:@"#FF4444"];
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125, 40));
        make.right.equalTo(self->_contentView.mas_right).offset(-15);
        make.bottom.equalTo(self->_contentView.mas_bottom).offset(-15);
    }];
    
    
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



