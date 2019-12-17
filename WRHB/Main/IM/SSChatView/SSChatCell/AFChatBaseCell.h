//
//  AFChatBaseCell.h
//  YPChatView
//
//  Created by soldoros on 2019/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessagelLayout.h"


@class AFChatBaseCell;
@class YPMessage;
@class UserInfo;
@class YPTextView;
@class EnvelopeMessage;

@protocol AFChatBaseCellDelegate <NSObject>

@optional;
// 点击头像 didSelectRowAtIndexPath
-(void)didTapCellChatHeaderImg:(UserInfo *)user_info;
// 长按头像
-(void)didLongPressCellChatHeaderImg:(UserInfo *)user_info;

// 点击Cell消息背景视图
- (void)didTapMessageCell:(YPMessage *)model;

// 点击文本cell
-(void)didChatTextCellIndexPath:(NSIndexPath*)indexPath index:(NSInteger)index layout:(ChatMessagelLayout *)layout;

// 点击cell图片和短视频
-(void)didChatImageVideoCellIndexPatch:(NSIndexPath *)indexPath layout:(ChatMessagelLayout *)layout;

// 点击定位cell
-(void)didChatMapCellIndexPath:(NSIndexPath*)indexPath layout:(ChatMessagelLayout *)layout;

// 删除消息
-(void)onDeleteMessageCell:(YPMessage *)model indexPath:(NSIndexPath *)indexPath;
/**
 撤回消息

 @param model 消息模型
 */
-(void)onWithdrawMessageCell:(YPMessage *)model;

/**
 点击重发
 
 @param model 消息模型
 */
-(void)onErrorBtnCell:(YPMessage *)model;

@end

@interface AFChatBaseCell : UITableViewCell

@property (nonatomic, strong) UIActivityIndicatorView *traningActivityIndicator;  //发送loading
@property (nonatomic, strong) UIButton *retryButton;                              //重试


@property (nonatomic, strong) NSIndexPath           *indexPath;
//撤销 删除 复制
@property (nonatomic, strong) UIMenuController *menu;
// 名称昵称
@property (nonatomic, strong) UILabel  *nicknameLabel;
// 头像
@property (nonatomic, strong) UIButton *mHeaderImgBtn;
// 时间
@property (nonatomic, strong) UILabel  *mMessageTimeLab;
// 气泡背景View
@property (nonatomic, strong) UIImageView  *bubbleBackView;
//文本消息
@property (nonatomic, strong) YPTextView     *mTextView;
//图片消息
@property (nonatomic, strong) UIImageView *mImgView;
//视频消息
@property (nonatomic, strong) UIButton *mVideoBtn;
@property (nonatomic, strong) UIImageView *mVideoImg;
// 错误标示
@property (nonatomic, strong) UIButton *errorBtn;
/// 过期时间  expireTimeLabel
@property (nonatomic, strong) UILabel *countDownOrDescLabel;


/// 已读标识背景
@property (nonatomic, strong) UIView *readedBackView;
/// 已读标识
@property (nonatomic, strong) UIImageView *readedImg;
/// 发送时间
@property (nonatomic, strong) UILabel *dateLabel;



@property (nonatomic, weak) id <AFChatBaseCellDelegate> delegate;
-(void)initChatCellUI;
@property (nonatomic, strong) ChatMessagelLayout  *model;


//消息按钮
-(void)buttonPressed:(UIImageView *)sender;

/**
 设置发送消息的状态
 */
- (void)setSendMessageStats;

/// 倒计时到0时回调
@property (nonatomic, copy) void(^countDownZero)(EnvelopeMessage *);


@end

