//
//  CowCowVSMessageCell.m
//  Project
//
//  Created by AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CowCowVSMessageCell.h"
#import "CowCowSettleVSModel.h"

@interface CowCowVSMessageCell()

@property (nonatomic, strong) UILabel *bankerLabel;
@property (nonatomic, strong) UILabel *playerWinLabel;
@property (nonatomic, strong) UIImageView *bankerHeadImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *pointNumImageView;

// 通杀  通赔
@property (nonatomic, strong) UIImageView *passKillPayIcon;
//
@property (nonatomic, strong) YPMessage *message;


@end

@implementation CowCowVSMessageCell

-(void)initChatCellUI {
    [super initChatCellUI];
    [self setupSubViews];
}

#pragma mark - subView
- (void)setupSubViews {
    
    UIView *backView = [[UIView alloc] init];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_seeDetails)];
    [backView addGestureRecognizer:tapGesturRecognizer];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    NSInteger xx = CD_WidthScal(60, 320);
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(xx);
        make.right.equalTo(self.mas_right).offset(-xx);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"cow_back_vs"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.height.equalTo(@(CowBackImageHeight));
    }];
    
    UIImageView *passKillPayIcon = [[UIImageView alloc] init];
    [backView addSubview:passKillPayIcon];
    _passKillPayIcon = passKillPayIcon;
    
    [passKillPayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(12);
        make.top.equalTo(backView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(45, 40));
    }];
    
    
    // 庄闲点数视图
    UIView *bankerPlayerWinView = [[UIView alloc] init];
    bankerPlayerWinView.backgroundColor = [UIColor clearColor];
    
    [backImageView addSubview:bankerPlayerWinView];
    
    [bankerPlayerWinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left);
        make.right.equalTo(backImageView.mas_right);
        make.bottom.equalTo(backImageView.mas_bottom);
        make.height.mas_equalTo(@(30));
    }];
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right);
        make.top.equalTo(backImageView.mas_bottom);
        make.height.mas_equalTo(@(40));
    }];
    
    
    UIImageView *bankerHeadImageView = [UIImageView new];
    [bottomView addSubview:bankerHeadImageView];
    _bankerHeadImageView = bankerHeadImageView;
    bankerHeadImageView.layer.cornerRadius = 5;
    bankerHeadImageView.layer.masksToBounds = YES;
    
    [bankerHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(@(34));
        make.left.equalTo(bottomView.mas_left).offset(6);
        make.centerY.equalTo(bottomView);
    }];
    
    UILabel *nameLabel = [UILabel new];
    [bottomView addSubview:nameLabel];
    _nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = Color_0;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankerHeadImageView.mas_top);
        make.left.equalTo(bankerHeadImageView.mas_right).offset(8);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"cow_banker"];
    [bottomView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankerHeadImageView.mas_right).offset(8);
        make.bottom.equalTo(bankerHeadImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(34, 16));
    }];
    
    UIImageView *pointNumImageView = [[UIImageView alloc] init];
    [bottomView addSubview:pointNumImageView];
    _pointNumImageView = pointNumImageView;
    pointNumImageView.layer.cornerRadius = 5;
    pointNumImageView.layer.masksToBounds = YES;
    
    [pointNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 14.5));
    }];
    
    
    UIButton *desBtn = [[UIButton alloc] init];
    desBtn.userInteractionEnabled = NO;
    [desBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [desBtn addTarget:self action:@selector(action_seeDetails) forControlEvents:UIControlEventTouchUpInside];
    desBtn.titleLabel.font = [UIFont vvFontOfSize:12];
    [desBtn setTitleColor:COLOR_X(120, 120, 120) forState:UIControlStateNormal];
    [desBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    desBtn.titleEdgeInsets = UIEdgeInsetsMake(18, 0, 0, 0);
    [bottomView addSubview:desBtn];
    
    [desBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(bottomView.mas_right);
        make.width.equalTo(@80);
    }];
    
    
    
    
    /******************/
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = ApHexColor(@"#FFFFFF", 0.5);
    [bankerPlayerWinView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = ApHexColor(@"#FFFFFF", 0.5);
    [bankerPlayerWinView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(bankerPlayerWinView);
        make.right.equalTo(rightView.mas_left);
        make.width.equalTo(rightView.mas_width);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView.mas_top);
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(bankerPlayerWinView.mas_right);
        make.height.equalTo(leftView);
    }];
    
    UILabel *bankerTitleLabel = [UILabel new];
    bankerTitleLabel.text = @"庄赢";
    [leftView addSubview:bankerTitleLabel];
    bankerTitleLabel.textColor = Color_3;
    bankerTitleLabel.font = [UIFont vvBoldFontOfSize:16];
    
    [bankerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.centerX.equalTo(leftView.mas_centerX).offset(-10);
    }];
    
    _bankerLabel = [[UILabel alloc] init];
    [leftView addSubview:_bankerLabel];
    _bankerLabel.textColor = [UIColor redColor];
    _bankerLabel.font = [UIFont vvBoldFontOfSize:16];
    
    [_bankerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankerTitleLabel.mas_centerY);
        make.left.equalTo(bankerTitleLabel.mas_right).offset(3);
    }];
    
    
    UILabel *playerWinTitleLabel = [UILabel new];
    playerWinTitleLabel.text = @"闲赢";
    [rightView addSubview:playerWinTitleLabel];
    playerWinTitleLabel.textColor = Color_3;
    playerWinTitleLabel.font = [UIFont vvBoldFontOfSize:16];
    [playerWinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView.mas_centerY);
        make.centerX.equalTo(rightView.mas_centerX).offset(-10);;
    }];
    
    _playerWinLabel = [[UILabel alloc] init];
    [rightView addSubview:_playerWinLabel];
    _playerWinLabel.textColor = [UIColor redColor];
    _playerWinLabel.font = [UIFont vvBoldFontOfSize:16];
    
    [_playerWinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playerWinTitleLabel.mas_centerY);
        make.left.equalTo(playerWinTitleLabel.mas_right).offset(3);
    }];
    
}

-(void)setModel:(ChatMessagelLayout *)model {
    [super setModel:model];
    self.message = model.message;
    if (model.message.cowCowVSModel.banker_win_times > 0 && model.message.cowCowVSModel.player_win_times == 0) {
        self.passKillPayIcon.image = [UIImage imageNamed:@"cow_will"];
        self.passKillPayIcon.hidden = NO;
    } else if (model.message.cowCowVSModel.banker_win_times == 0 && model.message.cowCowVSModel.player_win_times > 0) {
        self.passKillPayIcon.image = [UIImage imageNamed:@"cow_pay"];
        self.passKillPayIcon.hidden = NO;
    } else {
        self.passKillPayIcon.hidden = YES;
    }
    
    
    self.bankerLabel.text = [NSString stringWithFormat:@"%ld", model.message.cowCowVSModel.banker_win_times];
    self.playerWinLabel.text = [NSString stringWithFormat:@"%ld", model.message.cowCowVSModel.player_win_times];
    
    
    if (model.message.cowCowVSModel.avatar.length < kAvatarLength) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.message.cowCowVSModel.avatar]];
        if (image) {
            self.bankerHeadImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.message.cowCowVSModel.avatar]];
        } else {
           self.bankerHeadImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
        
    } else {
        [self.bankerHeadImageView cd_setImageWithURL:[NSURL URLWithString:model.message.cowCowVSModel.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    self.nameLabel.text = model.message.cowCowVSModel.name;
    
    
    
    self.pointNumImageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"cow_%ld",model.message.cowCowVSModel.banker_points]];
    
    //    [self initLayout];
}



/**
 查看详情
 */
- (void)action_seeDetails {
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapVSCowcowCell:)]){
        [self.delegate didTapVSCowcowCell:self.message];
    }
}

@end

