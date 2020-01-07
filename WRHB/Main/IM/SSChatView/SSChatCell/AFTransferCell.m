//
//  AFTransferCell.m
//  WRHB
//
//  Created by AFan on 2020/1/3.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "AFTransferCell.h"
#import "TransferModel.h"


@interface AFTransferCell ()

@end

@implementation AFTransferCell



-(void)initChatCellUI {
    [super initChatCellUI];
    [self setupSubViews];
}

- (void)dealloc {
    NSLog(@"%s dealloc",object_getClassName(self));
}


#pragma mark - 更新数据
-(void)setModel:(ChatMessagelLayout *)model {
    [super setModel:model];
    
    // ****** 设置背景图片 ******
    UIImage *bubbleImage = [self backImageCellStatus:model.message.transferModel.cellStatus dirFrom:model.message.messageFrom];
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = bubbleImage;
    
    if (model.message.transferModel.cellStatus == TransferCellStatus_Normal || model.message.transferModel.cellStatus == TransferCellStatus_Expire) {
        self.iocnImgView.image = [UIImage imageNamed:@"redp_transfer_icon"];
    } else if (model.message.transferModel.cellStatus == TransferCellStatus_MyselfReceived) {
        self.iocnImgView.image = [UIImage imageNamed:@"redp_transfer_ok"];
    } if (model.message.transferModel.cellStatus == TransferCellStatus_Refund) {
        self.iocnImgView.image = [UIImage imageNamed:@"redp_transfer_return"];
    }
    
    
    
    self.redTypeLabel.text = @"现金转账";
//    NSString *mes = [self cellFromStatus:cellStatus];
//    if (mes.length > 0) {
//        self.countDownOrDescLabel.text = mes;
//    }
    
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@", model.message.transferModel.money];
    
    if (model.message.transferModel.cellStatus == TransferCellStatus_Normal) {
        if (model.message.transferModel.title.length > 0) {
            self.contentLabel.text = [NSString stringWithFormat:@"%@",model.message.transferModel.title];
        } else {
             if (model.message.messageFrom == MessageDirection_SEND) {
                 self.contentLabel.text = [NSString stringWithFormat:@"转账给%@",model.message.transferModel.receiveName];
             } else {
                 self.contentLabel.text = @"转账给你";
             }
        }
    } else {
        NSString *statusStr = [self cellFromStatus:model.message.transferModel.cellStatus];
        self.contentLabel.text = statusStr;
    }
    
    
    
    
    if (model.message.messageFrom == MessageDirection_SEND) {
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(8);
            make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
        }];
        
    } else {
        
        [self.redTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bubbleBackView.mas_left).offset(12);
            make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
        }];
    }
    
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    UIImageView *iocnImgView = [[UIImageView alloc] init];
    iocnImgView.image = [UIImage imageNamed:@"redp_transfer_icon"];
    [self.bubbleBackView addSubview:iocnImgView];
    _iocnImgView = iocnImgView;
    
    [iocnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bubbleBackView.mas_top).offset(7);
        make.left.equalTo(self.bubbleBackView.mas_left).offset(10);
        make.size.equalTo(@(32));
    }];
    
    
    _moneyLabel = [UILabel new];
//    _moneyLabel.backgroundColor = [UIColor grayColor];
    [self.bubbleBackView addSubview:_moneyLabel];
    _moneyLabel.font = [UIFont boldSystemFontOfSize:15];
    _moneyLabel.textColor = [UIColor whiteColor];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iocnImgView.mas_top);
        make.left.equalTo(iocnImgView.mas_right).offset(8);
        make.right.lessThanOrEqualTo(self.bubbleBackView.mas_right).offset(-15);
    }];
    
    _contentLabel = [UILabel new];
//    _contentLabel.backgroundColor = [UIColor greenColor];
    [self.bubbleBackView addSubview:_contentLabel];
    _contentLabel.numberOfLines = 1;
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.text = kRedpackedGongXiFaCaiMessage;
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iocnImgView.mas_bottom);
        make.left.equalTo(_moneyLabel.mas_left).offset(1);
        make.right.equalTo(self.bubbleBackView.mas_right).offset(-10);
//        make.width.mas_equalTo(115);
    }];

    
    _redTypeLabel = [UILabel new];
    [self.bubbleBackView addSubview:_redTypeLabel];
    _redTypeLabel.font = [UIFont systemFontOfSize:9];
    _redTypeLabel.textColor = Color_6;
    
    [_redTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleBackView.mas_left).offset(10);
        make.bottom.equalTo(self.bubbleBackView.mas_bottom).offset(-3);
    }];
 
}



- (void)tapTextMessage:(UIGestureRecognizer *)gestureRecognizer {
    //    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
    //        [self.delegate didTapMessageCell:self.model];
    //    }
}


// 设置背景图片
- (UIImage *)backImageCellStatus:(NSInteger)cellStatus dirFrom:(ChatMessageFrom)dirFrom {
    
    UIImage *image = [[UIImage alloc] init];
  
    if (dirFrom == MessageDirection_SEND) {
        image = (cellStatus == 0 || cellStatus == 1) ? [UIImage imageNamed:@"redp_back_transfer_S"]:[UIImage imageNamed:@"redp_back_transfer_dis_S"];
    } else {
        image = (cellStatus == 0 || cellStatus == 1) ? [UIImage imageNamed:@"redp_back_transfer_R"]:[UIImage imageNamed:@"redp_back_transfer_dis_R"];
    }
    
    return image;
}

- (NSString *)cellFromStatus:(TransferCellStatus)cellStatus {
    
    switch (cellStatus) {
        case TransferCellStatus_Invalid:
        case TransferCellStatus_Normal:
            return @"";
            break;
        case TransferCellStatus_MyselfReceived:
            
            if (self.model.message.messageFrom == MessageDirection_SEND) {
                return @"已被领取";
            }
            return @"已收款";
            break;
        case TransferCellStatus_Refund:
            return @"已退还";
            break;
        case TransferCellStatus_Expire:
            return @"已结束";
            break;
        default:
            break;
    }
    return nil;
}


@end

