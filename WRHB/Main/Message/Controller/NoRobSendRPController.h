//
//  NoRobSendRPController.h
//  Project
//
//  Created by AFan on 2019/3/2.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketProtocol.h"

@class ChatsModel;

@interface NoRobSendRPController : UIViewController

/// 会话模型
@property (nonatomic ,strong) ChatsModel *chatsModel;
//代理属性
@property (nonatomic, weak) id<SendRedPacketDelegate> delegate;

@end

