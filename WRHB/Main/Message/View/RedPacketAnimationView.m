//
//  EnvelopAnimationView.m
//  Project
//
//  Created by AFan on 2019/11/13.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "RedPacketAnimationView.h"
#import "EnvelopBackImg.h"
#import "EnvelopeMessage.h"
#import "RedPacketDetModel.h"
#import "SenderModel.h"


@interface RedPacketAnimationView()<CAAnimationDelegate>

@property (nonatomic, strong) EnvelopBackImg *redView;
@property (nonatomic, strong) UIControl *backControl;
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UILabel *redDescLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *small_iconImageView;
@property (nonatomic, strong) UIImageView *backImageView;


@end

@implementation RedPacketAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}



- (void)actionCloseButton {
    [self disMissRedView];
}

-(void)tapActionView:(UITapGestureRecognizer *)tap {
    if (self.isClickedDisappear) {
        [self disMissRedView];
    }
}

- (void)animation {
//    [_openBtn setTitle:nil forState:UIControlStateNormal];
    [_openBtn setBackgroundImage:[UIImage imageNamed:@"mees_money_icon"] forState:UIControlStateNormal];
    [_openBtn.layer addAnimation:[self confirmViewRotateInfo] forKey:@"transform"];
}

- (void)remoAnimation {
    [_openBtn.layer removeAllAnimations];
    [self disMissRedView];
    if (self.animationBlock) {
        self.animationBlock();
    }
}

- (void)actionDetail {
    [self disMissRedView];
    if (self.detailBlock) {
        self.detailBlock();
    }
}

- (void)openRedPacketAction {
    [self animation];
    if (self.openBtnBlock) {
        self.openBtnBlock();
    }
}

- (void)showInView:(UIView *)view{
    if (self == nil) {
        return;
    }
    self.backImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    self.backImageView.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _backControl.alpha = 0.0;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
        // 放大
        self.backImageView.transform = CGAffineTransformMakeScale(1, 1);
        self->_backControl.alpha = 0.6;
        self.backImageView.alpha = 1.0;
        
    } completion:nil];
    
}

- (CAKeyframeAnimation *)confirmViewRotateInfo
{
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0.5, 0)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI*2, 0, 0.5, 0)],
                           nil];
    
    theAnimation.cumulative = YES;
    theAnimation.duration = 0.9f;
    theAnimation.repeatCount = 100;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = self;
    
    return theAnimation;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    if (self.animationEndBlock) {
//        self.animationEndBlock();
//    }
}

- (NSString *)redTypeString:(RedPacketType)type {
    switch (type) {
        case RedPacketType_SingleMine:
            return @"扫雷红包";
            break;
        case RedPacketType_BanRob:
            return @"禁抢红包";
            break;
        case RedPacketType_CowCowNoDouble:
            return @"牛牛不翻倍";
            break;
        case RedPacketType_CowCowDouble:
            return @"牛牛翻倍";
            break;
        case RedPacketType_Normal:
            return @"普通红包";
            break;
        case RedPacketType_Private:
            return @"普通红包";
        case RedPacketType_Relay:
            return @"红包接力";
            break;
        case RedPacketType_Fu:
            return @"福利红包";
            break;
        case RedPacketType_Luckys:
            return @"Luckys红包";
        
            break;
        default:
            break;
    }
    return @"未知类型红包";;
}

- (void)updateMesgString:(NSString *)mesg {
    
    _redDescLabel.hidden = YES;
    _contentLabel.text = mesg;
    _openBtn.hidden = YES;
    self.isClickedDisappear = YES;
    
    [self setDetaiButton];
}


- (void)updateView:(YPMessage *)message redEnDetModel:(RedPacketDetModel *)redEnDetModel mesg:(NSString *)mesg {
    self.isClickedDisappear = NO;
    
    
    if (!redEnDetModel && mesg) {
        [self updateMesgString:mesg];
        return;
    }
    
    // 到时候去保存的数据库 匹配用户数据， 用户数据每次都需要拉取群更新
    if (redEnDetModel.sender.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", redEnDetModel.sender.avatar]];
        if (image) {
            _headIcon.image = image;
        } else {
            _headIcon.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [_headIcon cd_setImageWithURL:[NSURL URLWithString:redEnDetModel.sender.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    _nameLabel.text = redEnDetModel.sender.name;
    
    
    _redDescLabel.hidden = NO;
    _redDescLabel.text = [NSString stringWithFormat:@"发了一个%@，金额随机", [self redTypeString:redEnDetModel.redpacketType]];
    _contentLabel.text = kRedpackedGongXiFaCaiMessage;
    
    
    if (redEnDetModel.sender.ID == [AppModel sharedInstance].user_info.userId) {  // 自己
        _small_iconImageView.hidden = YES;
        if (redEnDetModel.remain_piece == 0) {
            [self contentShow:kNoMoreRedpackedMessage];
        }
        [self setDetaiButton];
    } else {
        if (redEnDetModel.remain_piece == 0) {
            [self contentShow:kNoMoreRedpackedMessage];
            [self setDetaiButton];
        } else {
            _detailButton.hidden = YES;
            _small_iconImageView.hidden = NO;
        }
    }
    
    // 禁抢 自己
    if (redEnDetModel.redpacketType == RedPacketType_BanRob && redEnDetModel.sender.ID == [AppModel sharedInstance].user_info.userId) {   // 禁抢自己不显示 开
        _openBtn.hidden = YES;
        [self setDetaiButton];
        return;
    }
}





- (void)contentShow:(NSString *)message {
    _contentLabel.text = message;
    _redDescLabel.hidden = YES;
    _openBtn.hidden = YES;
    self.isClickedDisappear = YES;
}


- (void)setDetaiButton {
    _detailButton.hidden = NO;
    [_detailButton setTitle:kLookLuckDetailsMessage forState:UIControlStateNormal];
    _small_iconImageView.hidden = YES;
}


- (void)onbackControl {
    if (!IS_IPHONE_Xr || self.isClickedDisappear) {
       [self disMissRedView];
    }
}

- (void)disMissRedView {
    
    if (self.disMissRedBlock) {
        self.disMissRedBlock();
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.backImageView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backImageView.alpha = 0.0;
        self->_backControl.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}




#pragma mark - subView
- (void)setupSubViews {
    
    _backControl = [[UIControl alloc]initWithFrame:self.bounds];
    [self addSubview:_backControl];
    _backControl.backgroundColor = ApHexColor(@"#000000", 0.6);
    [_backControl addTarget:self action:@selector(onbackControl) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat marginWidth = 30;
    
    CGFloat w = kSCREEN_WIDTH-marginWidth * 2;
    CGFloat h = (kSCREEN_WIDTH-marginWidth)/0.8125;
    CGFloat y = kSCREEN_HEIGHT /2 - h/2;
    
//    _redView = [[EnvelopBackImg alloc]initWithFrame:CGRectMake(marginWidth, y, w, h)];
//    [self addSubview:_redView];
//    //    _redView.backgroundColor = HexColor(@"#C5513F");
//    _redView.backgroundColor = [UIColor colorWithHex:@"FF3737"];
//    _redView.layer.cornerRadius = 16;
//    _redView.layer.masksToBounds = YES;
//
//    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionView:)];
//    [_redView addGestureRecognizer:tapGesturRecognizer];
    
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginWidth, y, w, h)];
    backImageView.image = [UIImage imageNamed:@"redp_view_bg"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    _backImageView = backImageView;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionView:)];
    [backImageView addGestureRecognizer:tapGesturRecognizer];
    
    
    CGFloat openWidth = 138;
    _openBtn = [[UIButton alloc]initWithFrame:CGRectMake(w/2-openWidth/2, h*0.665-openWidth/2, openWidth, openWidth)];
    [backImageView addSubview:_openBtn];
    //    _openBtn.layer.cornerRadius = openWidth/2;
    //    _openBtn.layer.masksToBounds = YES;
    //    _openBtn.backgroundColor = HexColor(@"#FFE6A2");
    //    [_openBtn setTitle:@"開" forState:UIControlStateNormal];
    [_openBtn setBackgroundImage:[UIImage imageNamed:@"mess_open"] forState:UIControlStateNormal];
    //    [_openBtn setTitleColor:HexColor(@"#4D4D4D") forState:UIControlStateNormal];
    _openBtn.titleLabel.font = [UIFont systemFontOfSize2:openWidth/2];
    [_openBtn addTarget:self action:@selector(openRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
    
    _headIcon = [UIImageView new];
    [backImageView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 5;
    _headIcon.layer.masksToBounds = YES;
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.top.equalTo(backImageView.mas_top).offset(CD_Scal(35, 667));
        make.width.height.equalTo(@(CD_Scal(45, 667)));
    }];
    
    _nameLabel = [UILabel new];
    [backImageView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize2:16];
    _nameLabel.textColor = HexColor(@"#FFE6A2");
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self -> _headIcon.mas_bottom).offset(CD_Scal(7, 667));
        make.centerX.equalTo(backImageView);
    }];
    
    _redDescLabel = [UILabel new];
    [backImageView addSubview:_redDescLabel];
    _redDescLabel.numberOfLines = 0;
    _redDescLabel.font = [UIFont systemFontOfSize2:14];
    _redDescLabel.textAlignment = NSTextAlignmentCenter;
    _redDescLabel.textColor = HexColor(@"#FFE6A2");
    [_redDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.top.equalTo(self->_nameLabel.mas_bottom).offset(CD_Scal(2, 667));
    }];
    
    _contentLabel = [UILabel new];
    [backImageView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 2;
    _contentLabel.font = [UIFont systemFontOfSize2:18];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.textColor = HexColor(@"#FFE6A2");
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(10);
        make.right.equalTo(backImageView.mas_right).offset(-10);
        make.centerX.equalTo(backImageView);
        make.top.equalTo(self->_redDescLabel.mas_bottom).offset(CD_Scal(15, 667));
    }];
    
    
    _detailButton = [UIButton new];
    [backImageView addSubview:_detailButton];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize2:14];
    [_detailButton addTarget:self action:@selector(actionDetail) forControlEvents:UIControlEventTouchUpInside];
    [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailButton setTitleColor:HexColor(@"#FFE6A2") forState:UIControlStateNormal];//:@"查看详情"
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom);
        make.centerX.equalTo(backImageView);
        make.height.equalTo(@44);
    }];
    
    UIImageView *imageCCView = [[UIImageView alloc] init];
    imageCCView.image = [UIImage imageNamed:@"mess_redp_cc"];
    [backImageView addSubview:imageCCView];
    _small_iconImageView = imageCCView;
    
    [imageCCView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-11);
        make.centerX.equalTo(backImageView);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    _closeButton = [UIButton new];
    [backImageView addSubview:_closeButton];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize2:14];
    [_closeButton addTarget:self action:@selector(actionCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"mess_close"] forState:UIControlStateNormal];
    [_closeButton setTitleColor:HexColor(@"#FFE6A2") forState:UIControlStateNormal];
    _closeButton.alpha = 0.3;
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(backImageView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}


@end
