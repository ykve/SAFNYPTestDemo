//
//  AFReceiveMessageDelegate.h
//  
//
//  Created by AFan on 2019/3/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  聊天委托
 */
@protocol AFChatManagerDelegate <NSObject>
// 1 即将发送消息回调
// 2 发送消息完成回调
// 3 收到消息回调
// 4 收到消息被撤回的通知

@optional
/**
 *  即将发送消息回调
 *  @discussion 因为发消息之前可能会有个准备过程,所以需要在收到这个回调时才将消息加入到 Datasource 中
 *  @param message 当前发送的消息
 */
- (YPMessage *)willSendMessage:(YPMessage *)message;

/*!
 即将在会话页面插入消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
 */
- (YPMessage *)willAppendAndDisplayMessage:(YPMessage *)message;

/**
 即将在会话页面确认自己发送的消息的回调
 
 @param reqId 消息ID
 @param sessionId 会话ID
 @param state 消息投递状态
 */
- (void)willConfirmSendMessageReqId:(NSString *)reqId sessionId:(NSInteger)sessionId messageId:(NSInteger)messageId state:(MessageDeliveryState)state;

/*!
 即将在会话页面插入系统消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
 */
- (YPMessage *)willAppendAndDisplaySystemMessage:(YPMessage *)message redpId:(NSString *)redpId;

#pragma mark - 自己发送的红包 去重复
/**
 自己发送的红包 去重复
 
 @param redId 红包ID
 @param messageId 消息 ID
 */
- (void)receiveSendbyYourselfRedPacketId:(NSString *)redId messageId:(NSInteger)messageId;

/**
 转账
 
 @param message 消息体
 */
- (void)receiveSendbyYourselfTransferMessage:(YPMessage *)message;

/**
 红包结算状态

 @param redPacketId 红包ID
 @param remain 红包剩余数量
 */
- (void)receiveRedPacketStatusRedPacketId:(NSString *)redPacketId remain:(NSInteger)remain;
/**
 转账状态
 
 @param transferModel 转账模型
 */
- (void)receiveTransferStatusModel:(TransferModel *)transferModel;

/*!
 服务器返回的用户已读信息通知
 */
- (void)willSetReadMessages:(YPMessage *)message;

/**
 即将撤回消息（服务器已经发送回来撤回命令 客服端还未处理时）

 @param messageId  消息ID
 */
- (void)willRecallMessage:(NSInteger)messageId;


/**
 下拉获取服务器返回的消息

 @param messageArray 消息数组
 */
- (void)downPullGetMessageArray:(NSArray *)messageArray;


#pragma mark -  客服相关
/*!
 即将在会话页面插入消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
 */
- (YPMessage *)cService_willAppendAndDisplayMessage:(YPMessage *)message;
/**
 即将在会话页面确认自己发送的消息的回调
 
 @param reqId 消息ID
 @param sessionId 会话ID
 @param state 消息投递状态
 */
- (void)cService_willConfirmSendMessageReqId:(NSString *)reqId sessionId:(NSInteger)sessionId messageId:(NSInteger)messageId state:(MessageDeliveryState)state;

@end



/**
 *  聊天协议
 */
@protocol AFReceiveMessageDelegate <NSObject>

// 1 发送消息
// 2 异步发送消息
// 3 取消正在发送的消息
// 4 重发消息
// 5 刷新群组消息已读、未读数量
// 5 撤回消息

@optional
/*!
 接收消息的回调方法
 
 @param message     当前接收到的消息
 @param messageCount  未读消息总数  获取未读消息时有
 @param left        还剩余的未接收的消息数，left>=0      参考融云sdk
 */
- (void)onIMReceiveMessage:(YPMessage *)message messageCount:(NSInteger)messageCount left:(NSInteger)left;


//  默认 NO 播放  返回YES 不再播放声音
- (BOOL)onIMCustomAlertSound:(YPMessage *)message;















/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
//- (void)addDelegate:(id<NIMChatManagerDelegate>)delegate;
/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
//- (void)removeDelegate:(id<NIMChatManagerDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
