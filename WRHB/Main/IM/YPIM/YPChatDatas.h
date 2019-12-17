//
//  YPChatDatas.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessagelLayout.h"


@interface YPChatDatas : NSObject

/**
 处理消息数组 一般进入聊天界面会初始化之前的消息展示

 @param messages 消息数组
 @return 返回消息模型布局后的数组
 */
+(NSMutableArray *)receiveMessages:(NSArray *)messages;




/**
 接收一条消息
 
 @param message 消息内容
 @return 消息模型布局
 */
+(ChatMessagelLayout *)receiveMessage:(id)message;


/**
 消息内容生成消息布局模型
 
 @param data 消息内容
 @return 消息布局模型  <YPChatMessagelLayout>
 */
+(ChatMessagelLayout *)getMessageWithData:(YPMessage *)data;




/**
 发送消息回调

 @param model 消息
 @param error 发送是否成功
 @param progress 发送进度
 */
typedef void (^MessageBlock)(ChatMessagelLayout *model, NSError *error, NSProgress *progress);


/**
 发送一条消息

 @param message 消息主体
 @param messageBlock 发送消息回调
 */
+(void)sendMessage:(YPMessage *)message messageBlock:(MessageBlock)messageBlock;



@end
