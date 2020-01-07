//
//  AFTransferCell.h
//  WRHB
//
//  Created by AFan on 2020/1/3.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "AFChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFTransferCell : AFChatBaseCell
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *redTypeLabel;
@property (nonatomic, strong) UIImageView *iocnImgView;

@end

NS_ASSUME_NONNULL_END
