//
//  NotificationMessageCell.m
//  Project
//
//  Created by AFan on 2019/2/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ChatNotifiCell.h"
#import "NSString+Size.h"
#import "SingleMineSettleModel.h"

@interface ChatNotifiCell()
//
@property (nonatomic, strong) UIView *textBackView;
///
@property (nonatomic, strong) UIImageView *headIcon;

@end

@implementation ChatNotifiCell


-(void)initChatCellUI {
    [self setupSubViews];
}

#pragma mark - subView
- (void)setupSubViews {
    
    _tipLabel = [UILabel new];
    [self.contentView addSubview:_tipLabel];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.textColor = [UIColor colorWithHex:@"#A8A8A8"]; // 微信样式
//    _tipLabel.backgroundColor = [UIColor colorWithRed:0.788 green:0.788 blue:0.788 alpha:1.000];
    _tipLabel.font = [UIFont systemFontOfSize:10];
//    _tipLabel.clipsToBounds = YES;
//    _tipLabel.layer.cornerRadius = 3;
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 15));
    }];
    
    UIImageView *headIcon = [[UIImageView alloc] init];
    headIcon.hidden = YES;
    headIcon.image = [UIImage imageNamed:@"imageName"];
    [self.contentView addSubview:headIcon];
    _headIcon = headIcon;
    
    [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipLabel.mas_left).offset(0);
        make.centerY.equalTo(self.tipLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
    
}

-(void)setModel:(ChatMessagelLayout *)model {
    [super setModel:model];
    
    if (model.message.messageFrom == ChatMessageFrom_System) {
        self.tipLabel.text = model.message.text;
        
        if (model.message.messageType == MessageType_Single_SettleRedpacket) {
            self.headIcon.hidden = NO;
            
            if (model.message.singleMineModel.gotMime) {
                self.headIcon.image = [UIImage imageNamed:@"redp_norob_minenum_icon"];
            } else {
               self.headIcon.image = [UIImage imageNamed:@"sub_bb"];
            }
            
        } else {
            self.headIcon.hidden = YES;
        }
        
        CGFloat width = [model.message.text widthWithFont:[UIFont systemFontOfSize:10] constrainedToHeight:15] +8*2;
        [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, 15));
        }];
    }
    
    
}


@end

