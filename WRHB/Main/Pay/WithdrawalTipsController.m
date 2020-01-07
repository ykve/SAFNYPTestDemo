//
//  WithdrawalTipsController.m
//  WRHB
//
//  Created by AFan on 2019/12/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "WithdrawalTipsController.h"
#import "VVAlertModel.h"
#import "NSString+Size.h"
#import "WitAlertTextCell.h"
#import "NSTimer+CQBlockSupport.h"

@interface WithdrawalTipsController ()
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

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *textLabel;

@property (strong, nonatomic) UIButton *submitBtn;


/// 倒计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger startCountDownNum;
@property (nonatomic, assign) NSInteger restCountDownNum;

@end

@implementation WithdrawalTipsController


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
    
    
    _startCountDownNum = 3;
    [self startCountDown];
}


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

#pragma mark -  倒计时
- (void)startCountDown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _restCountDownNum = _startCountDownNum;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer cq_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf handleCountDowning];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer.fireDate = [NSDate distantPast];
}

- (void)endCountDown:(BOOL)isAuto {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (isAuto) {
        _restCountDownNum = _startCountDownNum;
        [self endAction];
    }
}


- (void)handleCountDowning {
    [self countDownTimeing];
    
    if (_restCountDownNum == 0) { // 倒计时完成
        [self endCountDown:NO];
        [self.submitBtn setTitle:@"继续提现" forState:UIControlStateNormal];
        self.contentView.userInteractionEnabled = YES;
        return;
    }
    _restCountDownNum --;
}


- (void)endAction {
    
//    NSString *text = [NSString stringWithFormat:@"%zds", self.restCountDownNum];
    [self.submitBtn setTitle:@"继续提现" forState:UIControlStateNormal];

//    [self getChangLongData];
//    [self startCountDown];
}

- (void)countDownTimeing {
    NSString *text = [NSString stringWithFormat:@"继续提现(%zds)", self.restCountDownNum];
    [self.submitBtn setTitle:text forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endCountDown:NO];
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
    _contentView = [[UIView alloc] init];
    _contentView.userInteractionEnabled = NO;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 8;
    _contentView.clipsToBounds = YES;
    _contentView.layer.masksToBounds = YES;
    [self.shadowView addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shadowView.mas_centerY);
        make.centerX.equalTo(self.shadowView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(302, 308));
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
        make.centerY.equalTo(self->_contentView.mas_top);
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
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"      您的打码量不足，当前未达到提现要求，如需提现将收取提现手续费，以及高额的行政费。\n      如对本需求不满，可以到公司砍死主程。";
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor = [UIColor colorWithHex:@"#333333"];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:textLabel];
    _textLabel = textLabel;
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titHeadImgView.mas_bottom).offset(20);
        make.left.equalTo(self->_contentView.mas_left).offset(15);
        make.right.equalTo(self->_contentView.mas_right).offset(-15);
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
        make.size.mas_equalTo(CGSizeMake(182, 40));
        make.centerX.equalTo(self->_contentView.mas_centerX);
        make.bottom.equalTo(self->_contentView.mas_bottom).offset(-20);
    }];
    
    UIButton *submitBtn = [UIButton new];
//    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 40/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor colorWithHex:@"#FF4444"];
    [submitBtn setTitle:@"继续提现" forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(182, 40));
        make.centerX.equalTo(self->_contentView.mas_centerX);
        make.bottom.equalTo(cancelBtn.mas_top).offset(-15);
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


