//
//  AFSocketManager.h
//  
//
//  Created by AFan on 2019/3/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  socket状态
 */
typedef NS_ENUM(NSInteger,AFSocketStatus){
    AFSocketStatusConnected,// 已连接
    AFSocketStatusFailed,// 失败
    AFSocketStatusClosedByServer,// 系统关闭
    AFSocketStatusClosedByUser,// 用户关闭
    AFSocketStatusReceived// 接收消息
};
/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger,AFSocketReceiveType){
    AFSocketReceiveTypeForMessage,
    AFSocketReceiveTypeForPong
};

typedef void(^AFSocketDidConnectBlock)();
typedef void(^AFSocketDidFailBlock)(NSError *error);
typedef void(^AFSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
typedef void(^AFSocketDidReceiveBlock)(id message ,AFSocketReceiveType type);




@interface AFSocketManager : NSObject

@property (nonatomic, copy)AFSocketDidConnectBlock connect;
@property (nonatomic, copy)AFSocketDidReceiveBlock receive;
@property (nonatomic, copy)AFSocketDidFailBlock failure;
@property (nonatomic, copy)AFSocketDidCloseBlock close;


/**
 *  超时重连时间，默认1秒
 */
@property (nonatomic, assign)NSTimeInterval overtime;
/**
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
// 视图加载是否完成  messageController
@property (nonatomic, assign) BOOL isViewLoad;
// 是否无效token
@property (nonatomic, assign) BOOL isInvalidToken;


+ (instancetype)shareManager;
/**
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)af_open:(NSString *)urlStr connect:(AFSocketDidConnectBlock)connect receive:(AFSocketDidReceiveBlock)receive failure:(AFSocketDidFailBlock)failure;
/**
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)af_close:(AFSocketDidCloseBlock)close;
/**
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)af_sendData:(id)data;

@end
