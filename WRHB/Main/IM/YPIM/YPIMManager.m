//
//  YPIMManager.m
//  Project
//
//  Created by AFan on 2019/4/2.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YPIMManager.h"
#import "IMMessageManager.h"
#import "ChatViewController.h"
#import "CServiceChatController.h"
#import "SqliteManage.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import "MessageSingle.h"
#import "PushMessageNumModel.h"
#import "YPContacts.h"




@implementation YPIMManager


static YPIMManager *instance = nil;
static dispatch_once_t predicate;
+ (YPIMManager *)sharedInstance {
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self onConnectSocket];
        [IMMessageManager sharedInstance].receiveMessageDelegate = self;
        [IMMessageManager sharedInstance].receiveMessageDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnectSocket) name:kOnConnectSocketNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoggedSuccess) name:kLoggedSuccessNotification object:nil];
        
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/**
 更新红包信息
 
 @param redPacketInfo 更改后的红包模型
 */
- (void)updateRedPacketInfo:(EnvelopeMessage *)redPacketInfo {
    [[IMMessageManager sharedInstance] updateRedPacketInfo:redPacketInfo];
}

- (void)onConnectSocket {
    
    if ([IMMessageManager sharedInstance].isConnectIM) {
        return;
    }
    
    // 用户token
    if ([AppModel sharedInstance].token) {
        
        [[IMMessageManager sharedInstance] initWithAppKey:[AppModel sharedInstance].token];
    } else {
        if([AppModel sharedInstance].user_info.isLogined == YES) {
//            [[AppModel sharedInstance] logout];
        }
    }
}
- (void)onLoggedSuccess {
    [self notificationLogin];
}

- (void)onTokenInvalid {
    [IMMessageManager sharedInstance].isConnectIM = NO;
    [AppModel sharedInstance].token = nil;
    [AppModel sharedInstance].token = nil;
}


#pragma mark - AFReceiveMessageDelegate 消息来源
- (void)onIMReceiveMessage:(YPMessage *)message messageCount:(NSInteger)messageCount left:(NSInteger)left {
    NSInteger number = 0;
    NSInteger tid = 0;
    
    if (message.chatSessionType == ChatSessionType_CustomerService) {
        CServiceChatController *csvc = [CServiceChatController currentChat];
        if (csvc) {
            tid = csvc.sessionId;
        }
    } else {
        ChatViewController *vc = [ChatViewController currentChat];
        if (vc) {
            tid = vc.sessionId;
        }
    }
    number = (tid == message.sessionId) ? 0 : 1;
    
    NSString *lastMessage = nil;
    
    if (message.messageType == MessageType_Text) {
        lastMessage = message.text;
    } else if (message.messageType == MessageType_Image) {
        lastMessage = @"[图片]";
    } else if (message.messageType == MessageType_Voice) {
        lastMessage = @"[语音]";
    } else if (message.messageType == MessageType_Video) {
        lastMessage = @"[视频]";
    } else if (message.messageType == MessageType_RedPacket) {
        lastMessage = @"[红包]";
    } else if (message.messageType == MessageType_CowCow_SettleRedpacket) {
        lastMessage = @"[牛牛红包结算]";
    } else if (message.messageType == MessageType_NoRob_SettleRedpacket) {
        lastMessage = @"[禁抢红包结算]";
    } else if (message.messageType == MessageType_Nofitiction) {
        lastMessage = message.text;;
    } else {
        lastMessage = @"[未知消息]";
    }
    
    
    
    PushMessageNumModel *curPushModel = [[PushMessageNumModel alloc] init];
    
    if (message.chatSessionType == ChatSessionType_CustomerService) {
        curPushModel.sessionId = kCustomerServiceID;
    } else {
        curPushModel.sessionId = message.sessionId;
    }
    curPushModel.number = number;
    curPushModel.lastMessage = lastMessage;
    curPushModel.messageCountLeft = messageCount;
    curPushModel.create_time = message.create_time;
    curPushModel.userId = [AppModel sharedInstance].user_info.userId;
    if (message.messageFrom == MessageDirection_SEND) {
        curPushModel.isYourselfSend = YES;
    } else {
       curPushModel.isYourselfSend = NO;
    }
    
    [self updateMessageNum:curPushModel left:left];
   
}

- (void)updateMessageNum:(PushMessageNumModel *)curPushModel left:(NSInteger)left {
    
    NSString *whereStr = [NSString stringWithFormat:@"sessionId=%zd and userId=%zd",curPushModel.sessionId, [AppModel sharedInstance].user_info.userId];
    NSString *ramQueryId = [NSString stringWithFormat:@"%ld_%ld",curPushModel.sessionId,[AppModel sharedInstance].user_info.userId];
    PushMessageNumModel *oldModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[ramQueryId];
    
    if (oldModel) {
        if (curPushModel.number == 0) {
            [AppModel sharedInstance].unReadAllCount -= oldModel.number;
            oldModel.number = 0;
        } else {
            if (oldModel.number > kMessageMaxNum) {
                return;
            }
            oldModel.number += 1;
            oldModel.create_time = curPushModel.create_time;
            [AppModel sharedInstance].unReadAllCount += 1;
            oldModel.messageCountLeft = curPushModel.messageCountLeft;
        }
        
        if (curPushModel.lastMessage.length > 0) {
            oldModel.lastMessage = curPushModel.lastMessage;
            oldModel.isYourselfSend = curPushModel.isYourselfSend;
        }
        
        [[MessageSingle sharedInstance].unreadAllMessagesDict setObject:oldModel forKey:ramQueryId];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite update:oldModel where:whereStr];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[PushMessageNumModel class]];
            }
        });
        
    } else {
        if (curPushModel.number == 0 && curPushModel.lastMessage.length == 0) {   // 如果在这个会话 就不能丢弃
            return;
        }
        
        [AppModel sharedInstance].unReadAllCount += curPushModel.number;
        [[MessageSingle sharedInstance].unreadAllMessagesDict setObject:curPushModel forKey:ramQueryId];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite insert:curPushModel];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[PushMessageNumModel class]];
                [WHC_ModelSqlite insert:curPushModel];
            }
        });
    }
    
    if ((left == 0 && oldModel.number <= kMessageMaxNum) || (curPushModel.messageCountLeft > 0 && left == 0)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"ChatspListNotification"];
    }
    if ([AppModel sharedInstance].unReadAllCount <= kMessageMaxNum) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"kUpdateSetBadgeValue"];
    }
    
    
    
}



//设置群组通知消息没有提示音  NO 有声音
- (BOOL)onIMCustomAlertSound:(YPMessage *)message {
    
    //    当应用处于前台运行，收到消息不会有提示音。
    NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", [AppModel sharedInstance].user_info.userId,message.sessionId];
    // 读取
    BOOL isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
    return isSwitch;
}

/**
 用户主动退出登录
 */
- (void)userSignout {
    [[IMMessageManager sharedInstance] userSignout];
    [WHC_ModelSqlite removeModel:[PushMessageNumModel class]];
    [[MessageSingle sharedInstance].unreadAllMessagesDict removeAllObjects];
    instance = nil;
    predicate = 0;
}

@end
