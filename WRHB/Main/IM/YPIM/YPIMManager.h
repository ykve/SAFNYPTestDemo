//
//  YPIMManager.h
//  WRHB
//
//  Created by AFan on 2019/4/2.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PushMessageNumModel;
@class TransferModel;


NS_ASSUME_NONNULL_BEGIN

@interface YPIMManager : NSObject<AFReceiveMessageDelegate>

+ (YPIMManager *)sharedInstance;

/**
 更新红包信息
 
 @param redPacketInfo 更改后的红包模型
 */
- (void)updateRedPacketInfo:(EnvelopeMessage *)redPacketInfo;
- (void)updateTransferInfo:(TransferModel *)redPacketInfo;

- (void)updateMessageNum:(PushMessageNumModel *)curPushModel left:(NSInteger)left;


/**
 通知服务器 登录了
 */
- (void)notificationLogin;

/**
 用户主动退出登录
 */
- (void)userSignout;



@end

NS_ASSUME_NONNULL_END
