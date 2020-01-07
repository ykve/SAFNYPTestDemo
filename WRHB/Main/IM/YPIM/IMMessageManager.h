//
//  AFSocketMessageManager.h
//  
//
//  Created by AFan on 2019/3/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface IMMessageManager : NSObject

// 设置代理
@property (weak, nonatomic)id <AFChatManagerDelegate> delegate;
@property (weak, nonatomic)id <AFReceiveMessageDelegate> receiveMessageDelegate;



// 是否连接Socket  IM
@property (nonatomic, assign) BOOL isConnectIM;

+ (IMMessageManager *)sharedInstance;

- (void)initWithAppKey:(NSString *)appKey;


#pragma mark - 客服 自动询问
/**
 客服 自动询问
 
 @param ID 自动询问问题 ID
 */
- (void)sendCSAutoAskMessage:(YPMessage *)model ID:(NSString *)ID;
#pragma mark - 客服 盈商询问
/**
 客服 盈商询问
 
 @param ID 盈商 ID
 */
- (void)sendCSYSAutoAskMessage:(YPMessage *)model ID:(NSString *)ID;

#pragma mark - 发送普通文本消息
/**
 发送普通文本消息
 
 @param model YPMessage
 */
- (void)sendTextMessage:(YPMessage *)model;

#pragma mark - 发送图片
/**
 发送图片
 
 @param model YPMessage
 */
- (void)sendImageMessage:(YPMessage *)model;
/**
 发送语音
 
 @param model YPMessage
 */
- (void)sendVoiceMessage:(YPMessage *)model;
#pragma mark - 发送视频
/**
 发送视频
 
 @param model YPMessage
 */
- (void)sendVideoMessage:(YPMessage *)model;

#pragma mark - 发送已读
/**
 发送已读
 
 @param sessionId 会话 ID
 @param readArray 未读数组
 @param isAll 是否这个会话全部设置已读
 */
- (void)sendReadedCmdSessionId:(NSInteger)sessionId readArray:(NSArray<YPMessage *> *)readArray isAll:(BOOL)isAll;


/**
 本地消息数保存
 
 @param message 消息模型
 */
- (void)sendMessageToLocalNumSave:(YPMessage *)message;
    
#pragma mark - 发送获取全部好友状态
/**
 发送获取全部好友状态
 
 @param array array
 */
- (void)sendGetAllFriendStatusCmd:(NSArray *)array;
/**
 撤回消息
 
 @param message YPMessage
 */
- (void)sendWithdrawMessage:(YPMessage *)message;



/**
 更新红包信息

 @param redPacketInfo 更改后的红包模型
 */
- (void)updateRedPacketInfo:(EnvelopeMessage *)redPacketInfo;
- (void)updateTransferInfo:(TransferModel *)transferModel;

- (void)updateMessage:(NSInteger)messageId;

/**
 用户主动退出登录
 */
- (void)userSignout;


@end

NS_ASSUME_NONNULL_END
