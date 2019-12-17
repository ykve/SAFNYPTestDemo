//
//  TeamMessageReceipt.h
//  WRHB
//
//  Created by AFan on 2019/11/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  群已读回执信息
 *  @discussion 只有当当前消息为 Team 消息且 teamReceiptEnabled 为 YES 时才有效，需要对端调用过发送已读回执的接口
 */
@interface TeamMessageReceipt : NSObject

/**
 *  已读人数
 *  @discussion 只有当当前消息为 Team 消息且 teamReceiptEnabled 为 YES 时这个字段才有效，需要对端调用过发送已读回执的接口
 */
@property (nonatomic,assign)       NSInteger readCount;

/**
 *  未读人数
 *  @discussion 只有当当前消息为 Team 消息且 teamReceiptEnabled 为 YES 时这个字段才有效，需要对端调用过发送已读回执的接口
 */
@property (nonatomic,assign)       NSInteger unreadCount;

@end

NS_ASSUME_NONNULL_END
