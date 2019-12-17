//
//  EnvelopeCollectionViewCell.h
//  Project
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//


#import "AFChatBaseCell.h"

@interface AFRedPacketCell : AFChatBaseCell
///*!
// 背景View
// */
//@property (nonatomic, strong) UIImageView *bubbleBackgroundView;
/*!
 文字
 */
@property (nonatomic, strong) UILabel *contentLabel;

/*!
 类型
 */
@property (nonatomic, strong) UILabel *redTypeLabel;
@property (nonatomic, strong) UIImageView *mineNumIcon;

/// 雷号
@property (nonatomic, strong) UILabel *mineLabel;


@end
