//
//  YPIMSessionViewController.h
//  WRHB
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessagelLayout.h"
#import "YPIMManager.h"
#import "YPChatKeyBoardInputView.h"
#import "IMMessageManager.h"
#import "YPContacts.h"
@class ChatsModel;

@interface IMSessionMessageController : UIViewController

//底部输入框 携带表情视图和多功能视图
@property (nonatomic, strong) YPChatKeyBoardInputView *sessionInputView;
// 会话id
@property (nonatomic, assign) NSInteger    sessionId;
// 会话类型
@property (nonatomic, assign) ChatSessionType chatSessionType;
// 会话模型
@property (nonatomic, strong) ChatsModel *chatsModel;
//名字
@property (nonatomic, copy) NSString    *titleString;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) BOOL reloadFinish;

- (void)didTapMessageCell:(YPMessage *)model;
//发送文本 列表滚动至底部
-(void)onChatKeyBoardInputViewSendText:(NSString *)text;


/*!
 初始化会话页面
 
 @param chatSessionType 会话类型
 @param targetId         目标会话ID
 
 @return 会话页面对象
 */
- (id)initWithConversationType:(ChatSessionType)chatSessionType targetId:(NSInteger)targetId;

//多功能视图点击回调  图片10  视频11  位置12
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)tag;

//+ (IMSessionMessageController *)currentChat;

@property (weak, nonatomic)id <AFChatManagerDelegate> delegate;

#pragma mark -  上传图片
/**
 上传图片
 */
- (void)loadImage;

#pragma mark - 更新未读消息
/**
 更新未读消息
 */
- (void)updateUnreadMessage;


@end
