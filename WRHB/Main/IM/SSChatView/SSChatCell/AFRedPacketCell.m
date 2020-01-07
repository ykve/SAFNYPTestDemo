//
//  EnvelopeCollectionViewCell.m
//  WRHB
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "AFRedPacketCell.h"
#import "EnvelopeMessage.h"
#import "NSTimer+CQBlockSupport.h"
#import "CountDown.h"

@class RCloudImageView;


@interface AFRedPacketCell ()


/// 剩余数量
@property (nonatomic, strong) UILabel *remNumber;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger startCountDownNum;
@property (nonatomic, assign) NSInteger restCountDownNum;

/// 
@property (nonatomic, strong) NSMutableArray *minesButtonArray;

/// 已领取标记
@property (nonatomic, strong) UIImageView *yilingquIcon;
/// 已领取Label
@property (nonatomic, strong) UILabel *yilingquLabel;



@end

@implementation AFRedPacketCell



-(void)initChatCellUI {
    [super initChatCellUI];
    [self setupSubViews];
}

- (void)dealloc {
//    NSLog(@"%s dealloc",object_getClassName(self));
}


#pragma mark - 更新数据
-(void)setModel:(ChatMessagelLayout *)model {
    [super setModel:model];
    
    RedPacketCellStatus cellStatus = model.message.redPacketInfo.cellStatus;
    RedPacketType redEnveType = model.message.redPacketInfo.redpacketType;
    
    // ****** 设置背景图片 ******
    UIImage *bubbleImage = [self backImage:redEnveType cellStatus:cellStatus dirFrom:model.message.messageFrom];
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = bubbleImage;
    
    // ****** 红包类型 ******
    self.redTypeLabel.text = [self redTypeString:redEnveType];
    
    
    // ****** 已领取标记 ******
    self.yilingquIcon.hidden = YES;
    self.yilingquLabel.hidden = YES;
    if (cellStatus == RedPacketCellStatus_MyselfReceived) {
        self.yilingquIcon.hidden = NO;
        self.yilingquLabel.hidden = NO;
    }
    
    
    
    self.contentLabel.hidden = NO;
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.message.redPacketInfo.title];
    
    
    self.remNumber.hidden = NO;
    if (!model.message.redPacketInfo.remain) {
        self.remNumber.text = [NSString stringWithFormat:@"%d/%d个", model.message.redPacketInfo.total, model.message.redPacketInfo.total];
    } else {
        self.remNumber.text = [NSString stringWithFormat:@"%zd/%d个", model.message.redPacketInfo.remain, model.message.redPacketInfo.total];
    }
    
    // 已过期或者已被领完
    [self reloadRedPackTimeOver:model];
    
    self.mineNumIcon.hidden = YES;
    if (model.message.messageFrom == MessageDirection_SEND) {
        
        if (redEnveType == RedPacketType_SingleMine) {
            self.mineNumIcon.hidden = NO;
            self.mineLabel.text = model.message.redPacketInfo.mime;
            [self.mineNumIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bubbleBackView.mas_right).offset(-8);
                make.top.equalTo(self.bubbleBackView.mas_top).offset(5);
                make.size.mas_equalTo(CGSizeMake(36, 36));
            }];
        }
        
        
        
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(8);
            make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
        }];
        
    } else {
        
        if (redEnveType == RedPacketType_SingleMine) {
            self.mineNumIcon.hidden = NO;
            self.mineLabel.text = model.message.redPacketInfo.mime;
            [self.mineNumIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bubbleBackView.mas_right).offset(-5);
                make.top.equalTo(self.bubbleBackView.mas_top).offset(5);
                make.size.mas_equalTo(CGSizeMake(36, 36));
            }];
        }
        
        
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(12);
            make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
        }];
    }
    
    
    
    if (redEnveType == RedPacketType_BanRob) {
        
        // 分割字符串  切割
        NSArray *mineArray = [model.message.redPacketInfo.mime componentsSeparatedByString:@","];
        
        for (NSInteger index= 0; index < self.minesButtonArray.count; index++) {
            UIImageView *image = self.minesButtonArray[index];
            image.hidden = YES;
            
            if (index < mineArray.count) {
                image.hidden = NO;
                for (UILabel *label in image.subviews) {
                    label.text = mineArray[index];
                }
            }
        }
 
    }
}

-(void)reloadRedPackTimeOver:(ChatMessagelLayout*)model
{
    NSString *mes = [self cellFromStatus:model.message.redPacketInfo.cellStatus];
    if (mes.length > 0) {
        self.countDownOrDescLabel.text = mes;
         if (model.message.redPacketInfo.expireMrak.integerValue == 1 || model.message.redPacketInfo.remain == 0 || model.message.redPacketInfo.cellStatus == RedPacketCellStatus_NoPackage) {
             self.remNumber.hidden = YES;
         }
    }
    // 已过期或者已被领完
    if (model.message.redPacketInfo.expireMrak.intValue == 1 || model.message.redPacketInfo.remain == 0 || model.message.redPacketInfo.cellStatus == RedPacketCellStatus_NoPackage) {
        if (self.countDownOrDescLabel.text.length == 0) {
            self.remNumber.hidden = YES;
            if (model.message.redPacketInfo.remain == 0) {
                self.countDownOrDescLabel.text = @"已结束";
            } else {
                self.countDownOrDescLabel.text = @"查看红包";
            }
        }
        self.remNumber.hidden = (model.message.redPacketInfo.expireMrak || model.message.redPacketInfo.remain == 0 || model.message.redPacketInfo.cellStatus == RedPacketCellStatus_NoPackage);
    }
}

- (void)setCountDownOrDescLabel:(UILabel *)countDownOrDescLabel {
    [super setCountDownOrDescLabel:countDownOrDescLabel];
}

- (void)setContentLabel:(UILabel *)contentLabel {
    _contentLabel = contentLabel;
    
}

- (NSMutableArray *)minesButtonArray {
    if (!_minesButtonArray) {
        _minesButtonArray = [NSMutableArray array];
    }
    return _minesButtonArray;
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    _mineNumIcon = [UIImageView new];
    [self.bubbleBackView addSubview:_mineNumIcon];
    _mineNumIcon.image = [UIImage imageNamed:@"redp_minenum_icon"];
    
    _mineLabel = [UILabel new];
    [_mineNumIcon addSubview:_mineLabel];
    _mineLabel.font = [UIFont systemFontOfSize:18];
    _mineLabel.textColor = [UIColor whiteColor];
    
    [_mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mineNumIcon.mas_centerX).offset(-5);
        make.centerY.equalTo(self.mineNumIcon.mas_centerY).offset(4);
    }];
    
    
    _contentLabel = [UILabel new];
    [self.bubbleBackView addSubview:_contentLabel];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.text = kRedpackedGongXiFaCaiMessage;
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackView.mas_top).offset(10);
        make.left.equalTo(self.bubbleBackView.mas_left).offset(44.5);
        make.right.lessThanOrEqualTo(self.bubbleBackView.mas_right).offset(-15);
    }];
    
//    _descLabel = [UILabel new];
//    [self.bubbleBackView addSubview:_descLabel];
//    _descLabel.textAlignment = NSTextAlignmentLeft;
//    _descLabel.font = [UIFont systemFontOfSize:11];
//    _descLabel.textColor = [UIColor whiteColor];
//
//
//    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(1);
//        make.left.equalTo(self.contentLabel.mas_left);
//    }];
    
    _redTypeLabel = [UILabel new];
    [self.bubbleBackView addSubview:_redTypeLabel];
    _redTypeLabel.font = [UIFont systemFontOfSize:9];
    _redTypeLabel.textColor = Color_6;
    
    [_redTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleBackView.mas_left).offset(10);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
    }];
    
    UIImageView *yilingquIcon = [[UIImageView alloc] init];
    yilingquIcon.image = [UIImage imageNamed:@"redp_yilingqu"];
    [self.bubbleBackView addSubview:yilingquIcon];
    _yilingquIcon = yilingquIcon;
    
    [yilingquIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-5);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UILabel *yilingquLabel = [UILabel new];
    yilingquLabel.text = @"已抢";
    [self.bubbleBackView addSubview:yilingquLabel];
    yilingquLabel.font = [UIFont systemFontOfSize:9];
    yilingquLabel.textColor = [UIColor redColor];
    _yilingquLabel = yilingquLabel;
    
    [yilingquLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yilingquIcon.mas_left).offset(-3);
        make.centerY.equalTo(yilingquIcon.mas_centerY);
    }];
    
    self.countDownOrDescLabel = [UILabel new];
    [self.bubbleBackView addSubview:self.countDownOrDescLabel];
    self.countDownOrDescLabel.font = [UIFont systemFontOfSize:10];
    self.countDownOrDescLabel.textColor = [UIColor whiteColor];
    //    _countDownLabel.backgroundColor = [UIColor greenColor];
    
    [self.countDownOrDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentLabel.mas_centerY);
//        make.right.equalTo(self.bubbleBackView.mas_right).offset(-42);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(1);
        make.left.equalTo(self.contentLabel.mas_left);
    }];
    
    
    _remNumber = [UILabel new];
    //    _remNumber.text = @"7/7个";
    [self.bubbleBackView addSubview:_remNumber];
    _remNumber.textAlignment = NSTextAlignmentRight;
    _remNumber.font = [UIFont systemFontOfSize:10];
    _remNumber.textColor = [UIColor whiteColor];
    //     _remNumber.backgroundColor = [UIColor cyanColor];
    
    [_remNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countDownOrDescLabel.mas_centerY);
        make.left.equalTo(self.bubbleBackView.mas_centerX).offset(10);
    }];
    
    CGFloat buttonWH = 17;
    
    UIView *minesBackView = [[UIView alloc] init];
//    minesBackView.backgroundColor = [UIColor greenColor];
    [self.bubbleBackView addSubview:minesBackView];
    
    [minesBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackView.mas_top).offset(5);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-8);
        make.size.mas_equalTo(CGSizeMake(buttonWH*4, 2*buttonWH));
    }];
    
    
    
    CGFloat margin = 0;
    for (int i = 0; i < 7; i++) {
        
        UIImageView *mineNumIcon = [UIImageView new];
        mineNumIcon.image = [UIImage imageNamed:@"redp_norob_minenum_icon"];
        
        mineNumIcon.frame = CGRectMake((buttonWH*4 - buttonWH) -(i / 2) * (buttonWH+margin),  (i % 2)  * (buttonWH+margin), buttonWH, buttonWH);
        
        mineNumIcon.hidden = YES;
        [minesBackView addSubview:mineNumIcon];
        
        
        UILabel *mineLabel = [UILabel new];
        [mineNumIcon addSubview:mineLabel];
        mineLabel.font = [UIFont systemFontOfSize:9];
        mineLabel.textColor = [UIColor whiteColor];
        mineLabel.tag = i;
        
        [mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(mineNumIcon.mas_centerX).offset(-2);
            make.centerY.equalTo(mineNumIcon.mas_centerY).offset(2);
        }];
        [self.minesButtonArray addObject:mineNumIcon];
    }
}



- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    //    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
    //        [self.delegate didTapMessageCell:self.model];
    //    }
}


// 设置背景图片
- (UIImage *)backImage:(RedPacketType)redEnveType cellStatus:(NSInteger)cellStatus dirFrom:(ChatMessageFrom)dirFrom {
    
    UIImage *image = [[UIImage alloc] init];
    
    if (dirFrom == MessageDirection_SEND) {
        
        if (redEnveType == RedPacketType_Fu) {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_fu_S"]:[UIImage imageNamed:@"redp_back_fu_disabled_S"];
        } else if (redEnveType == RedPacketType_CowCowNoDouble || redEnveType == RedPacketType_CowCowDouble) {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_cow_S"]:[UIImage imageNamed:@"redp_back_cow_disabled_S"];
        } else {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_S"]:[UIImage imageNamed:@"redp_back_disabled_S"];
        }
        
    } else {
        
        if (redEnveType == RedPacketType_Fu) {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_fu_R"]:[UIImage imageNamed:@"redp_back_fu_disabled_R"];
        } else if (redEnveType == RedPacketType_CowCowNoDouble || redEnveType == RedPacketType_CowCowDouble) {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_cow_R"]:[UIImage imageNamed:@"redp_back_cow_disabled_R"];
        } else {
            image = (cellStatus == 0 || cellStatus == 1)?[UIImage imageNamed:@"redp_back_R"]:[UIImage imageNamed:@"redp_back_disabled_R"];
        }
    }
    
    return image;
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
            break;
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


- (NSString *)cellFromStatus:(RedPacketCellStatus)cellStatus {
    
    
    switch (cellStatus) {
        case RedPacketCellStatus_Invalid:
        case RedPacketCellStatus_Normal: // 没有点击(红包没抢)
            if (self.model.message.redPacketInfo.redpacketType == RedPacketType_Fu || self.model.message.redPacketInfo.redpacketType == RedPacketType_Private || self.model.message.redPacketInfo.redpacketType == RedPacketType_Normal) {
                return @"待领取";
            }
            return @"";
            break;
        case RedPacketCellStatus_MyselfReceived:
            return @"已领取";
            break;
        case RedPacketCellStatus_NoPackage:
            return @"已被领完";
            break;
        case RedPacketCellStatus_Expire:
            return @"已结束";
            break;
        default:
            break;
    }
    return nil;
}


@end
