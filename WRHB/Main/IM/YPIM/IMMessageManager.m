//
//  AFSocketMessageManager.m
//  
//
//  Created by AFan on 2019/3/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "IMMessageManager.h"
#import <AVFoundation/AVFoundation.h>

#import "AFSocketManager.h"
#import <MJExtension/MJExtension.h>
#import "WHC_ModelSqlite.h"
#import "ChatMessagelLayout.h"
#import "YPChatDatas.h"
#import "EnvelopeMessage.h"

#import "ChatViewController.h"


#import "Login.pbobjc.h"
#import "Common.pbobjc.h"
#import "Error.pbobjc.h"
#import "Msg.pbobjc.h"
#import "Notify.pbobjc.h"
#import "State.pbobjc.h"

#import "NoRobSettleModel.h"
#import "CowCowSettleVSModel.h"
#import "SystemNotificationModel.h"
#import "ImageModel.h"
#import "AudioModel.h"
#import "VideoModel.h"
#import "YPUserStateModel.h"
#import "SingleMineSettleModel.h"

#import "AppDelegate.h"
#import "YPContacts.h"
#import "TeamMessageReceipt.h"
#import "CServiceChatController.h"

@interface IMMessageManager ()

@property (nonatomic, strong) AVAudioPlayer *player;
// 是否已经获取到我加入的群数据
@property (nonatomic, assign) BOOL isGetMyJoinGroups;
// 是否已经获取到离线消息
@property (nonatomic, assign) BOOL isGetOfflineMessage;

@end

@implementation IMMessageManager

+ (IMMessageManager *)sharedInstance{
    static IMMessageManager *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isConnectIM = NO;
        _isGetMyJoinGroups = NO;
        _isGetOfflineMessage = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneGetMyJoinedGroupsNotification) name:kDoneGetMyJoinedGroupsNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initWithAppKey:(NSString *)appKey {
    [self startConnecting:appKey];
}


- (void)sendLoginLink {
    
    CLogin *user = [[CLogin alloc] init];
    user.userId = [AppModel sharedInstance].user_info.userId;;
    user.HTTPToken = [AppModel sharedInstance].token;
    user.deviceType = CLogin_DeviceType_Ios;
    
    MyPacket *myPacket = [[MyPacket alloc] init];
    myPacket.cmd = Cmd_CmsgLogin;
    myPacket.uid = [AppModel sharedInstance].user_info.userId;;
    myPacket.reqId = [NSString stringWithFormat:@"%f",[FunctionManager getNowTime]/1000];
    myPacket.extend = [user data];
    
    [[AFSocketManager shareManager] af_sendData:[myPacket data]];
}



#pragma mark - 🔴socket消息处理
- (void)startConnecting:(NSString *)appKey {
    
    appKey = [[FunctionManager sharedInstance] encodedWithString:appKey];
    NSString *wsURL= [AppModel sharedInstance].wsSocketURL;
    NSLog(@"======url======>%@", wsURL);
    
    __weak __typeof(self)weakSelf = self;
    [[AFSocketManager shareManager] af_open:wsURL connect:^{
        NSLog(@"✅ === tcp连接IM成功  === ✅");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf sendLoginLink];
    } receive:^(id message, AFSocketReceiveType type) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (type == AFSocketReceiveTypeForMessage) {
            //            NSLog(@"接收 类型1--%@",message);
            
            MyPacket *myP = [MyPacket parseFromData:message error:nil];
            Cmd command = myP.cmd;
            
            if (command == Cmd_SmsgLogin) {
                SLogin *login =[SLogin parseFromData:myP.extend error:nil];
                Error error = login.result;
                if (error == Error_Success) {
                    strongSelf.isConnectIM = YES;
                    [AFSocketManager shareManager].isInvalidToken = NO;
                    NSLog(@"✅✅✅✅✅✅ === 登录IM成功  === ✅✅✅✅✅✅");
                } else if (error == Error_TokenInvalid) {
                    NSLog(@"登录失败,无效token!");
                    strongSelf.isConnectIM = NO;
                    [AFSocketManager shareManager].isInvalidToken = YES;
                } else {
                    NSLog(@"未知登录信息");
                }
                
            } else if (command == Cmd_SmsgSendMessage) {   // 确认消息 自己发的 代表服务器收到了
                SSendMessage *sendMessConfirm =[SSendMessage parseFromData:myP.extend error:nil];
                [strongSelf receiveConfirmSendMessageReqId:myP.reqId sendMessage:sendMessConfirm];
                //                NSLog(@"确认消息 自己发的 代表服务器收到了");
                
            } else if (command == Cmd_SmsgNotifyNewMessage) {   // 新消息 ， 别人发的
                SNotifyNewMessage *messageModel =[SNotifyNewMessage parseFromData:myP.extend error:nil];
                [strongSelf receiveMessageArray:messageModel.msgsArray isOfflineMsg:NO messageCount:0];
                
            } else if (command == Cmd_SmsgRecvMessage) {   // 系统已接收回执
                SRecvMessage *sreMsg =[SRecvMessage parseFromData:myP.extend error:nil];
                NSLog(@"****** 已读设置成功 %@******",sreMsg);
                
            } else if (command == Cmd_SmsgHello) {
                SHello *hello =[SHello parseFromData:myP.extend error:nil];
                // 心跳处理
                NSLog(@"****** 心跳包接收 %@******",hello);
                
            } else if (command == Cmd_SmsgDelMessage) {   // 撤回消息
                
                SDelMessage *delMessage =[SDelMessage parseFromData:myP.extend error:nil];
                // 撤回消息
                [strongSelf userRecallMessage:delMessage];
            } else if (command == Cmd_SmsgKickOut) { // 强制下线  被挤掉也是这个
                
                SKickOut *kickOut =[SKickOut parseFromData:myP.extend error:nil];
                // 强制下线
                [strongSelf forcedOffline:kickOut];
                
                
            } else if (command == Cmd_SmsgNotifySessionAdd) { // 会话添加通知
                NSLog(@"********* 会话添加通知 *********");
                [[NSNotificationCenter defaultCenter] postNotificationName: kSessionUpdateNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_SmsgNotifySessionDel) { // 会话删除通知
                [[NSNotificationCenter defaultCenter] postNotificationName: kSessionUpdateNotification object: nil];
                NSLog(@"********* 会话删除通知 *********");
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_SmsgNotifySessionUpdate) { // 会话改变通知
                [[NSNotificationCenter defaultCenter] postNotificationName: kSessionInfoUpdateNotification object: nil];
                NSLog(@"********* 会话改变通知 *********");
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_SmsgNotifySessionMemberAdd) { // 会话成员新增通知
                NSLog(@"********* 会话成员新增通知 *********");
                
                //                SNotifySessionUpdate *seUpdate =[SNotifySessionUpdate parseFromData:myP.extend error:nil];
                //                SNotifySessionMemberAdd *memberAdd =[SNotifySessionMemberAdd parseFromData:seUpdate.membersArray error:nil];
                
                // 会话成员新增通知
                [[NSNotificationCenter defaultCenter] postNotificationName: kSessionMemberUpdateNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            }  else if (command == Cmd_SmsgNotifySessionMemberDel) { // 会话成员删除通知
                NSLog(@"********* 会话成员删除通知 *********");
                // 会话成员删除通知
                [[NSNotificationCenter defaultCenter] postNotificationName: kSessionMemberUpdateNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
            } else if (command == Cmd_SmsgNotifyAddFriends) { // 添加好友通知   申请好友通知   （添加好友->对方通过 通知）
//                SNotifyAddFriends *notAddFri =[SNotifyAddFriends parseFromData:myP.extend error:nil];
                [AppModel sharedInstance].sysMessageNum = [AppModel sharedInstance].sysMessageNum + 1;
                NSLog(@"********* 添加好友通知 *********");
                // 通讯录更新
                [[NSNotificationCenter defaultCenter] postNotificationName: kAddressBookUpdateNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_SmsgNotifyAnnouncement) { // 公告通知
                NSLog(@"********* 公告通知 *********");
                SNotifyAnnouncement *notifyAnnoun =[SNotifyAnnouncement parseFromData:myP.extend error:nil];
                [strongSelf sysNotificationMessage:notifyAnnoun.infosArray];
                
            } else if (command == Cmd_SmsgNotifyUserInfoUpdate) { // 用户信息更新通知  通讯录更新
                NSLog(@"********* 用户信息更新通知 *********");
                // 通讯录更新
                [[NSNotificationCenter defaultCenter] postNotificationName: kAddressBookUpdateNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_CmsgNotifyAck) { // 其它新增通知
                /** 注意：以后新增的通知协议，旧客户端没有办法处理的，直接返回通知确认 */
                NSLog(@"********* 其它新增通知 *********");
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else if (command == Cmd_SmsgNotifyStateChange) { // 好友在线状态改变通知
                SNotifyStateChange *notState =[SNotifyStateChange parseFromData:myP.extend error:nil];
                
                for (UserState *user in notState.userStateArray) {
                    YPUserStateModel *newModel = [AppModel sharedInstance].userStateDict[@(user.userId)];
                    newModel.state = user.state;
                    newModel.offlineTime = user.offlineTime;
                }
                // 用户状态改变
                [[NSNotificationCenter defaultCenter] postNotificationName: kAddressBookUserStatusUpdateNotification object: nil];
                NSLog(@"********* 好友在线状态改变通知 *********");
            } else if (command == Cmd_SmsgStateUser) { // 全部好友的状态
                SStateUser *allState =[SStateUser parseFromData:myP.extend error:nil];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (UserState *user in allState.userStateArray) {
                    YPUserStateModel *model = [[YPUserStateModel alloc] init];
                    model.userId = user.userId;
                    model.state = user.state;
                    model.offlineTime = user.offlineTime;
                    [dict setObject:model forKey:@(user.userId)];
                }
                [AppModel sharedInstance].userStateDict = [dict copy];
                // 用户状态改变
                [[NSNotificationCenter defaultCenter] postNotificationName: kAddressBookUserStatusUpdateNotification object: nil];
                NSLog(@"********* 全部好友的状态 *********");
            } else if (command == Cmd_SmsgReadMessage) { // 已读消息
                SReadMessage *readMe =[SReadMessage parseFromData:myP.extend error:nil];
                [self receiveReadedMessageReqId:myP.reqId readMessage:readMe];
                //
                NSLog(@"********* 已读消息 *********");
            } else if (command == Cmd_SmsgKefuQueueInfo) { // 客服排队
                //
                NSLog(@"********* 客服排队 *********");
            } else if (command == Cmd_SmsgDisconnectKefuSession) { // 断开客服会话
                //
                NSLog(@"********* 断开客服会话 *********");
            } else if (command == Cmd_SmsgNotifyPush) { // 通用通知
                //
                NSLog(@"********* 通用通知 *********");
                
                SNotifyPush *spush =[SNotifyPush parseFromData:myP.extend error:nil];
                
                if ([spush.action isEqualToString:@"club_join_request"]) {
                    // 俱乐部加入申请
                    [AppModel sharedInstance].appltJoinClubNum = [AppModel sharedInstance].appltJoinClubNum + 1;
                }
                //
                [[NSNotificationCenter defaultCenter] postNotificationName: kApplicationJoinClubNotification object: nil];
                [self confirmReceivedNotificationId:myP.reqId cmd:Cmd_CmsgNotifyAck];
                
            } else {
                
                NSLog(@"🔴***********command未知类型:%zd ***********🔴",command);
            }
            
        } else if (type == AFSocketReceiveTypeForPong){
            NSLog(@"🔴接收 类型2--%@",message);
        }
    } failure:^(NSError *error) {    // code 2145
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isConnectIM = NO;   // 1 本地dns没有设置也会出现连接不上   2 超时连接服务器 服务器可能挂了
        NSLog(@"🔴🔴🔴 ====== 连接失败 ====== 🔴🔴🔴%@",error);
    }];
}



#pragma mark -  通知确认已接收
- (void)confirmReceivedNotificationId:(NSString *)reqId cmd:(Cmd)cmd {
    CNotifyAck *cnot = [[CNotifyAck alloc] init];
    
    MyPacket *myPacket = [[MyPacket alloc] init];
    myPacket.cmd = cmd;
    myPacket.uid = [AppModel sharedInstance].user_info.userId;;
    myPacket.reqId = reqId;
    myPacket.extend = [cnot data];
    
    [[AFSocketManager shareManager] af_sendData:[myPacket data]];
}


#pragma mark - 接收对方已读 通知
/**
 接收对方已读通知
 
 @param reqId 消息ID
 @param readMessage 消息体
 */
- (void)receiveReadedMessageReqId:(NSString *)reqId readMessage:(SReadMessage *)readMessage {
    
    for (NSInteger index = 0; index < readMessage.msgIdsArray.count; index++) {
        NSInteger messageId = [readMessage.msgIdsArray valueAtIndex:index];
        
        NSString *whereStr = [NSString stringWithFormat:@"sessionId=%llu AND messageId=%ld", readMessage.sessionId,messageId];
        YPMessage *oldMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
        if (!oldMessage) {
            continue;
        }
        oldMessage.isReceivedMsg = YES;
        oldMessage.isRemoteRead = YES;
        oldMessage.teamReceiptInfo.readCount = oldMessage.teamReceiptInfo.readCount+1;
        //            oldMessage.teamReceiptInfo.unreadCount = oldMessage.teamReceiptInfo.readCount+1;  // 未读人数
        
        BOOL isCurrentSession = NO;
        ChatViewController *vc = [ChatViewController currentChat];
        if (vc) {
            if (vc.sessionId == readMessage.sessionId) {
                isCurrentSession = YES;
            }
        }
        
        // 是否在当前会话界面
        if (self.delegate && [self.delegate respondsToSelector:@selector(willSetReadMessages:)] && isCurrentSession) {
            [self.delegate willSetReadMessages:oldMessage];
        } else {
            // 更新消息列表通知
            [[NSNotificationCenter defaultCenter] postNotificationName: kSessionUpdateNotification object: nil];
        }
        
        // 更新数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess =  [WHC_ModelSqlite update:oldMessage where:whereStr];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[YPMessage class]];
            }
        });
    }
}
#pragma mark - 发送已读
/**
 发送已读
 
 @param sessionId 会话 ID
 @param readArray 未读数组
 @param isAll 是否这个会话全部设置已读
 */
- (void)sendReadedCmdSessionId:(NSInteger)sessionId readArray:(NSArray<YPMessage *> *)readArray isAll:(BOOL)isAll {
    
    NSArray *unreadArrayTemp = nil;
    if (isAll) {
        NSString *whereStr = [NSString stringWithFormat:@"sessionId=%zd AND messageFrom =2 and isRemoteRead=0", sessionId];
        unreadArrayTemp = [WHC_ModelSqlite query:[YPMessage class] where:whereStr];
    } else {
        unreadArrayTemp = [readArray copy];
    }
    
    if (unreadArrayTemp.count <= 0) {
        return;
    }
    
    CReadMessage *readMessage = [[CReadMessage alloc] init];
    readMessage.sessionId = sessionId;
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (YPMessage *ypMessage in unreadArrayTemp) {
        ReadInfo *readInfo = [[ReadInfo alloc] init];
        readInfo.sender = ypMessage.messageSendId;
        readInfo.msgId = ypMessage.messageId;
        [arrayM addObject:readInfo];
        
    }
    
    readMessage.readInfoArray = arrayM;
    [self sendMessageToIMServerCmd:Cmd_CmsgReadMessage extend:[readMessage data] reqId:nil];
    
    
    for (YPMessage *ypMessage in unreadArrayTemp) {
        NSString *whereStr = [NSString stringWithFormat:@"sessionId=%lu AND messageId=%ld", sessionId,sessionId];
        // 更新数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess =  [WHC_ModelSqlite update:ypMessage where:whereStr];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[YPMessage class]];
            }
        });
    }
    
}



#pragma mark - 接收确认服务器收到自己发送的消息
/**
 接收确认服务器收到自己发送的消息
 
 @param reqId 消息ID
 @param sendMessage 消息体
 */
- (void)receiveConfirmSendMessageReqId:(NSString *)reqId sendMessage:(SSendMessage *)sendMessage {
    
    BOOL isCService = NO;
    CServiceChatController *csvc = [CServiceChatController currentChat];
    if (csvc) {
        if (csvc.sessionId == sendMessage.sessionId) {
            isCService = YES;
        }
    }
    
    NSString *whereStr = [NSString stringWithFormat:@"sessionId=%llu AND messageId=%ld", sendMessage.sessionId,reqId.integerValue];
    if (isCService) {
        whereStr = [NSString stringWithFormat:@"sessionId=%d AND messageId=%ld", kCustomerServiceID,reqId.integerValue];
    }
    
    YPMessage *oldMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    if (!oldMessage) {
        return;
        //        oldMessage = [[YPMessage alloc] init];
    }
    oldMessage.isReceivedMsg = YES;
    
    YPMessage *message = nil;
    if (sendMessage.result == Error_Success) {  // 成功
        oldMessage.messageId = sendMessage.maxMsgId;  // 替换本地消息 ID
        oldMessage.deliveryState = MessageDeliveryState_Successful;
    } else {
        message = [[YPMessage alloc] init];
        oldMessage.deliveryState = MessageDeliveryState_Failed;
        
        if (sendMessage.result == Error_NoSpeak) {  // 不能说话
            message.text = @"本群禁止聊天，无法发送消息";
        } else if (sendMessage.result == Error_FrequentMessage) {  // 消息频繁
            message.text = @"发送消息过于频繁";
        } else if (sendMessage.result == Error_NotEmpty) {  // 不能空消息
            message.text = @"不能发送空消息";
        } else {
            message.text = @"未知原因 发送消息失败";
            NSLog(@"**************** 未知原因 发送消息失败 %d ****************", sendMessage.result);
        }
    }
    
    
    
    BOOL isCurrentSession = NO;
    ChatViewController *vc = [ChatViewController currentChat];
    if (vc) {
        if (vc.sessionId == sendMessage.sessionId) {
            isCurrentSession = YES;
        }
    }
    // 是否在当前会话界面
    if (self.delegate && [self.delegate respondsToSelector:@selector(willConfirmSendMessageReqId:sessionId:messageId:state:)] && isCurrentSession && !isCService) {
        [self.delegate willConfirmSendMessageReqId:reqId sessionId:sendMessage.sessionId messageId:sendMessage.maxMsgId state:oldMessage.deliveryState];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(cService_willConfirmSendMessageReqId:sessionId:messageId:state:)] && isCService) {
        [self.delegate cService_willConfirmSendMessageReqId:reqId sessionId:sendMessage.sessionId messageId:sendMessage.maxMsgId state:oldMessage.deliveryState];
    }
    
    if (sendMessage.result != Error_Success) {  // 用户发送的消息没有成功
        
        message.messageType = MessageType_ChatNofitiText;
        message.sessionId = sendMessage.sessionId;
        message.messageId = [FunctionManager getNowTime];
        message.deliveryState = MessageDeliveryState_Delivering;
        message.messageFrom = ChatMessageFrom_System;
        message.chatSessionType = oldMessage.chatSessionType;
        message.timestamp = message.messageId;
        message.create_time = [NSDate date];
        message.isReceivedMsg = YES;
        
        
        // 是否在当前会话界面
        if (self.delegate && [self.delegate respondsToSelector:@selector(willAppendAndDisplayMessage:)] && isCurrentSession && !isCService) {
            message = [self.delegate willAppendAndDisplayMessage:message];
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(cService_willAppendAndDisplayMessage:)] && isCService) {
            message = [self.delegate cService_willAppendAndDisplayMessage:message];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite insert:message];
            if (!isSuccess) {
                [WHC_ModelSqlite removeModel:[YPMessage class]];
                [WHC_ModelSqlite insert:message];
            }
        });
    }
    
    
    //    if (!oldMessage) {
    //        return;
    //    }
    // 更新数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess =  [WHC_ModelSqlite update:oldMessage where:whereStr];
        if (!isSuccess) {
            [WHC_ModelSqlite removeModel:[YPMessage class]];
        }
    });
    
}

#pragma mark - 新消息接收
/**
 common 11 or other 消息接收
 
 @param msgsArray 消息列表
 @param isOfflineMsg 是否离线消息
 */
- (void)receiveMessageArray:(NSArray<Message *> *)msgsArray isOfflineMsg:(BOOL)isOfflineMsg messageCount:(NSInteger)messageCount {
    
    
    if (msgsArray.count == 0) {
        return;
    }
    NSMutableArray *rmArray = [NSMutableArray array];
    
    NSInteger messageLeftNum = 0;
    for (Message *mess in msgsArray) {
        messageLeftNum = msgsArray.count;
        messageLeftNum--;
        Content *content = mess.content;
        
        BOOL isCService = NO;
        CServiceChatController *csvc = [CServiceChatController currentChat];
        if (csvc) {
            if (csvc.sessionId == mess.sessionId) {
                isCService = YES;
            }
        }
        
        BOOL isCurrentSession = NO;
        ChatViewController *vc = [ChatViewController currentChat];
        if (vc) {
            if (vc.sessionId == mess.sessionId) {
                isCurrentSession = YES;
            }
        }
        
        
#pragma mark 红包状态
        if (content.segmentType == SegmentType_SegmentTypeRedpacketStatus) {  // 红包状态   暂时不保存数据  优化-也不发已读确认
            if (self.delegate && [self.delegate respondsToSelector:@selector(receiveRedPacketStatusRedPacketId:remain:)] && isCurrentSession) {
                RedPacketStatusSegment *redpacketStatus =[RedPacketStatusSegment parseFromData:content.data_p error:nil];
                [self.delegate receiveRedPacketStatusRedPacketId:redpacketStatus.id_p remain:redpacketStatus.remain];
            }
            //            NSLog(@"**************** 消息类型-红包状态 ****************");
            continue;
        }
        
        YPMessage *message = [[YPMessage alloc] init];
        //        message.messageType = MessageType_ChatNofitiText;   下面赋值
        message.sessionId = mess.sessionId;
        message.messageId = mess.msgId;
        //        message.deliveryState = MessageDeliveryState_Delivering;
        message.messageFrom = MessageDirection_RECEIVE;
        message.chatSessionType = mess.sessionType;
        message.timestamp = mess.sendTime;
        message.create_time = [NSDate date];
        message.isReceivedMsg = YES;
        
        message.messageSendId = mess.sender;
        BaseUserModel *userModel = [[BaseUserModel alloc] init];
        userModel.userId = mess.sender;
        message.user = userModel;
        
        
        BOOL isSysMsg = NO;
        
        if (content.segmentType == SegmentType_SegmentTypeText) {  // 文本
            TextSegment *messageContent =[TextSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Text;
            message.text = messageContent.text;
            //            NSLog(@"**************** 消息类型-文本 ****************");
        } else if (content.segmentType == SegmentType_SegmentTypeImage) {  // 图片
            ImageSegment *imageSe =[ImageSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Image;
            
            ImageModel *imageModel = [[ImageModel alloc] init];
            imageModel.name = imageSe.name;
            imageModel.size = imageSe.size;
            imageModel.id_p = imageSe.id_p;
            imageModel.height = imageSe.height;
            imageModel.width = imageSe.width;
            imageModel.URL = imageSe.URL;
            imageModel.thumbnail = imageSe.thumbnail;
            message.imageModel = imageModel;
            //            NSLog(@"**************** 消息类型-图片 ****************");
            
        } else if (content.segmentType == SegmentType_SegmentTypeAudio) {  // 语音
            AudioSegment *audioSe =[AudioSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Voice;
            
            AudioModel *audioModel = [[AudioModel alloc] init];
            audioModel.name = audioSe.name;
            audioModel.size = audioSe.size;
            audioModel.id_p = audioSe.id_p;
            audioModel.time = audioSe.time;
            audioModel.URL = audioSe.URL;
            
            message.audioModel = audioModel;
            //            NSLog(@"**************** 消息类型-语音 ****************");
            
        } else if (content.segmentType == SegmentType_SegmentTypeVideo) {  // 视频
            VideoSegment *videoSe =[VideoSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Video;
            
            VideoModel *videoModel = [[VideoModel alloc] init];
            videoModel.name = videoSe.name;
            videoModel.size = videoSe.size;
            videoModel.id_p = videoSe.id_p;
            videoModel.time = videoSe.time;
            videoModel.thumbnail = videoSe.thumbnail;
            videoModel.URL = videoSe.URL;
            
            message.videoModel = videoModel;
            //            NSLog(@"**************** 消息类型-视频 ****************");
            
        } else if (content.segmentType == SegmentType_SegmentTypeSendRedpacket) { // 红包
            SendRedPacketSegment *messageContent =[SendRedPacketSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_RedPacket;
            
            if (message.messageSendId == [AppModel sharedInstance].user_info.userId) {
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(receiveSendbyYourselfRedPacketId:messageId:)] && isCurrentSession && !isCService) {
                    [self.delegate receiveSendbyYourselfRedPacketId:messageContent.id_p messageId:message.messageId];
                }
                NSLog(@"****************  自己发送的红包去重 ****************");
                continue;
            }
            
            EnvelopeMessage *reMessage = [[EnvelopeMessage alloc] init];
            reMessage.redp_id = messageContent.id_p;
            reMessage.redpacketType = messageContent.redpacketType;
            reMessage.sender = messageContent.sender;
            reMessage.create = messageContent.create;
            reMessage.expire = messageContent.expire;
            reMessage.mime = messageContent.mime;
            reMessage.title = messageContent.title;
            reMessage.sendTime = messageContent.sendTime;
            reMessage.total = messageContent.total;
            reMessage.remain = messageContent.remain;
            
            if (reMessage.remain == 0) {
                reMessage.cellStatus = RedPacketCellStatus_NoPackage;
            } else if ([self getNowTimeWithCreate:reMessage.create expire:reMessage.expire] <= 0) {
                reMessage.cellStatus = RedPacketCellStatus_Expire;
            } else {
                NSLog(@"********** 未知红包状态 **********");
            }
            
            message.redPacketInfo  = reMessage;
            //            NSLog(@"**************** 消息类型-红包 ****************");
        } else if (content.segmentType == SegmentType_SegmentTypeEmoji) {  // 表情
            EmojiSegment *messageContent =[EmojiSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Text;
            NSLog(@"**************** 消息类型-表情 ****************");
        } else if (content.segmentType == SegmentType_SegmentTypeSettleRedpacket) {  // 结算红包  牛牛- 禁抢
            SettleRedPacketSegment *messageContent =[SettleRedPacketSegment parseFromData:content.data_p error:nil];
            
            if (messageContent.type == 1) {  // 禁抢
                message.messageType = MessageType_NoRob_SettleRedpacket;
                NoRobSettleModel *noRobModel = [NoRobSettleModel mj_objectWithKeyValues:[messageContent.data_p mj_JSONObject]];
                message.noRobModel  = noRobModel;
                NSString *text = [NSString stringWithFormat:@"发包用户【%@】\n金额数量【%@】\n雷号玩法【%@】\n雷数赔率【%@】\n赔付金额【%@】\n%@",noRobModel.send_user,noRobModel.value,noRobModel.mimes_play_type,noRobModel.odds,noRobModel.pay_number,noRobModel.result];
                message.text = text;
                
            } else if (messageContent.type == 2) {  // 牛牛
                message.messageType = MessageType_CowCow_SettleRedpacket;
                CowCowSettleVSModel *cowCowModel = [CowCowSettleVSModel mj_objectWithKeyValues:[messageContent.data_p mj_JSONObject]];
                message.cowCowVSModel  = cowCowModel;
            } else {
                NSLog(@"**************** 消息类型-结算红包  未知类型 ****************");
            }
            //            NSLog(@"**************** 消息类型-结算红包 ****************");
        } else if (content.segmentType == SegmentType_SegmentTypeSingleSettleRedpacket) {  // 单人结算红包
            isSysMsg = YES;
            SingleSettleRedPacketSegment *singleSettle =[SingleSettleRedPacketSegment parseFromData:content.data_p error:nil];
            message.messageType = MessageType_Single_SettleRedpacket;
            message.messageFrom = ChatMessageFrom_System;
            
            SingleMineSettleModel *singModel = [[SingleMineSettleModel alloc] init];
            singModel.id_p = singleSettle.id_p;
            singModel.sendTime = singleSettle.sendTime;
            singModel.senderName = singleSettle.senderName;
            singModel.grabNum = singleSettle.grabNum;
            singModel.loseNum = singleSettle.loseNum;
            singModel.gotMime = singleSettle.gotMime;
            singModel.receiver = singleSettle.receiver;
            
            message.singleMineModel = singModel;
            
            NSString *textStr = nil;
            if (singleSettle.gotMime) {  // 中雷
                textStr = [NSString stringWithFormat:@"您在[%@]发出的红包中抢到%@元,中雷赔付%@元,再接再厉。", singleSettle.senderName,singleSettle.grabNum,singleSettle.loseNum];
            } else {
                textStr = [NSString stringWithFormat:@"恭喜您,在[%@]发出的红包中抢到%@元。", singleSettle.senderName,singleSettle.grabNum];
            }
            message.text = textStr;
            
            // 是否在当前会话界面
            if (self.delegate && [self.delegate respondsToSelector:@selector(willAppendAndDisplaySystemMessage:redpId:)] && isCurrentSession && !isCService) {
                message = [self.delegate willAppendAndDisplaySystemMessage:message redpId:singleSettle.id_p];
            }
            
            
            //            NSLog(@"**************** 消息类型-单人结算红包 ****************");
        } else {
            NSLog(@"🔴**************** 🔴未知消息类型🔴 ****************🔴");
            continue;
        }
        
        BOOL isSaveMessage = NO;  // 是否保存消息
        if (isCurrentSession || isCService || (message.chatSessionType != ChatSessionType_SystemRoom && message.chatSessionType != ChatSessionType_ManyPeople_Game)) {
            isSaveMessage = YES;
        }
        
        // 是否在当前会话界面
        if (self.delegate && [self.delegate respondsToSelector:@selector(willAppendAndDisplayMessage:)] && isCurrentSession && !isCService && !isSysMsg) {
            message = [self.delegate willAppendAndDisplayMessage:message];
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(cService_willAppendAndDisplayMessage:)] && isCService) {
            message = [self.delegate cService_willAppendAndDisplayMessage:message];
        }
        
        
        // 消息数量保存 最后消息保存
        if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onIMReceiveMessage: messageCount:left:)] && (message.chatSessionType != ChatSessionType_SystemRoom && message.chatSessionType != ChatSessionType_ManyPeople_Game)) {
            [self.receiveMessageDelegate onIMReceiveMessage:message messageCount:messageCount left:messageLeftNum];
        }
        
        // 声音
        if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onIMCustomAlertSound:)] && !([AppModel sharedInstance].user_info.userId == message.messageSendId) && !isCurrentSession && (message.chatSessionType != ChatSessionType_SystemRoom && message.chatSessionType != ChatSessionType_ManyPeople_Game)) {
            
            if (![AppModel sharedInstance].turnOnSound && ![self.receiveMessageDelegate onIMCustomAlertSound:message]) {
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
                [self.player play];
#endif
            }
            
        }
        
        /// 客服特殊处理
        if (message.chatSessionType == ChatSessionType_CustomerService) {
            message.sessionId = kCustomerServiceID;
        }
        
        if (isSaveMessage) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL isSuccess = [WHC_ModelSqlite insert:message];
                if (!isSuccess) {
                    [WHC_ModelSqlite removeModel:[YPMessage class]];
                    [WHC_ModelSqlite insert:message];
                }
            });
        }
        
        RecvMsg *rm = [[RecvMsg alloc] init];
        rm.sessionId = mess.sessionId;
        rm.msgId = mess.msgId;
        [rmArray addObject:rm];
    }
    
    [self confirmReceivedMessageArray:rmArray];
}


/**
 本地消息数保存

 @param message 消息模型
 */
- (void)sendMessageToLocalNumSave:(YPMessage *)message {
    // 消息数量保存 最后消息保存
    if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onIMReceiveMessage: messageCount:left:)] && message.chatSessionType != ChatSessionType_SystemRoom && message.chatSessionType != ChatSessionType_ManyPeople_Game) {
        [self.receiveMessageDelegate onIMReceiveMessage:message messageCount:0 left:0];
    }
}




-(NSDate *)dateWithLongLong:(long long)longlongValue{
    NSNumber *time = [NSNumber numberWithLongLong:longlongValue];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

-(NSInteger)getNowTimeWithCreate:(NSInteger)create expire:(NSInteger)expire {
    
    NSTimeInterval starTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate  = [self dateWithLongLong:starTimeStamp];
    
    NSInteger finishTime = create + expire;
    NSDate *finishDate = [self dateWithLongLong:finishTime];
    
    NSInteger timeInterval =[finishDate timeIntervalSinceDate:startDate];  //倒计时时间
    
    return timeInterval;
}


/**
 消息确认已接收
 
 @param array 需确认的消息数组
 */
- (void)confirmReceivedMessageArray:(NSArray *)array {
    // 设置已读消息  系统接收到的已读
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CRecvMessage *recvMessage = [[CRecvMessage alloc] init];
        recvMessage.userId = [AppModel sharedInstance].user_info.userId;
        recvMessage.recvMsgArray = [array copy];
        
        MyPacket *myPacket = [[MyPacket alloc] init];
        myPacket.cmd = Cmd_CmsgRecvMessage;
        myPacket.uid = [AppModel sharedInstance].user_info.userId;;
        myPacket.reqId = [NSString stringWithFormat:@"%f",[FunctionManager getNowTime]/1000];
        myPacket.extend = [recvMessage data];
        
        [[AFSocketManager shareManager] af_sendData:[myPacket data]];
        
    });
}



#pragma mark - 系统通知类
/**
 common  系统公告
 
 @param array 列表数据
 */

- (void)sysNotificationMessage:(NSArray *)array {
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (Announcement *annModel in array) {
        SystemNotificationModel *model = [[SystemNotificationModel alloc] init];
        model.ID = annModel.id_p;
        model.desTitle = annModel.detail;
        model.detail = annModel.description_p;
        model.sort = annModel.sort;
        [mArray addObject:model];
    }
    // 刷新系统公告
    [[NSNotificationCenter defaultCenter] postNotificationName: kSystemAnnouncementNotification object: mArray];
    
}

#pragma mark - 发送普通文本消息
/**
 发送普通文本消息
 
 @param model YPMessage
 */
- (void)sendTextMessage:(YPMessage *)model {
    
    TextSegment *messageText =[[TextSegment alloc] init];
    messageText.text = model.text;
    
    Content *content = [[Content alloc] init];
    content.segmentType = SegmentType_SegmentTypeText;
    //            NSData *textData =[model.text dataUsingEncoding:NSUTF8StringEncoding];
    content.data_p = [messageText data];
    
    CSendMessage *cSendMessage = [[CSendMessage alloc] init];
    cSendMessage.sessionId = model.sessionId;
    cSendMessage.sender = model.user.userId;
    cSendMessage.sendTime = model.messageId;
    cSendMessage.content = content;
    
    NSString *reqId = [NSString stringWithFormat:@"%zd", model.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgSendMessage extend:[cSendMessage data] reqId:reqId];
}

#pragma mark - 客服 自动询问
/**
 客服 自动询问

 @param ID 自动询问问题 ID
 */
- (void)sendCSAutoAskMessage:(YPMessage *)model ID:(NSString *)ID {
    
    AutoReplySegment *autoSe = [[AutoReplySegment alloc] init];
    autoSe.id_p = ID;
    autoSe.text = model.text;
    
    Content *content = [[Content alloc] init];
    content.segmentType = SegmentType_SegmentTypeText;
    content.data_p = [autoSe data];
    
    CSendMessage *cSendMessage = [[CSendMessage alloc] init];
    cSendMessage.sessionId = model.sessionId;
    cSendMessage.sender = model.user.userId;
    cSendMessage.sendTime = model.messageId;
    cSendMessage.content = content;
    
    NSString *reqId = [NSString stringWithFormat:@"%zd", model.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgSendMessage extend:[cSendMessage data] reqId:reqId];
}


#pragma mark - 发送普通图片
/**
 发送普通图片
 
 @param model YPMessage
 */
- (void)sendImageMessage:(YPMessage *)model {
    
    ImageSegment *imageSe = [[ImageSegment alloc] init];
    imageSe.name = model.imageModel.name;
    imageSe.size = model.imageModel.size;
    imageSe.id_p = model.imageModel.id_p;
    imageSe.height = model.imageModel.height;
    imageSe.width = model.imageModel.width;
    imageSe.URL = model.imageModel.URL;
    imageSe.thumbnail = model.imageModel.thumbnail;
    
    Content *content = [[Content alloc] init];
    content.segmentType = SegmentType_SegmentTypeImage;
    content.data_p = [imageSe data];
    
    CSendMessage *cSendMessage = [[CSendMessage alloc] init];
    cSendMessage.sessionId = model.sessionId;
    cSendMessage.sender = model.user.userId;
    cSendMessage.sendTime = model.timestamp;
    cSendMessage.content = content;
    
    NSString *reqId = [NSString stringWithFormat:@"%zd", model.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgSendMessage extend:[cSendMessage data] reqId:reqId];
    
}

#pragma mark - 发送语音
/**
 发送语音
 
 @param model YPMessage
 */
- (void)sendVoiceMessage:(YPMessage *)model {
    
    AudioSegment *audioSe = [[AudioSegment alloc] init];
    audioSe.name = model.audioModel.name;
    audioSe.size = model.audioModel.size;
    audioSe.id_p = model.audioModel.id_p;
    audioSe.time = model.audioModel.time;
    audioSe.URL = model.audioModel.URL;
    
    
    Content *content = [[Content alloc] init];
    content.segmentType = SegmentType_SegmentTypeAudio;
    content.data_p = [audioSe data];
    
    CSendMessage *cSendMessage = [[CSendMessage alloc] init];
    cSendMessage.sessionId = model.sessionId;
    cSendMessage.sender = model.user.userId;
    cSendMessage.sendTime = model.timestamp;
    cSendMessage.content = content;
    
    NSString *reqId = [NSString stringWithFormat:@"%zd", model.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgSendMessage extend:[cSendMessage data] reqId:reqId];
    
}
#pragma mark - 发送视频
/**
 发送视频
 
 @param model YPMessage
 */
- (void)sendVideoMessage:(YPMessage *)model {
    
    VideoSegment *videoSe = [[VideoSegment alloc] init];
    videoSe.name = model.videoModel.name;
    videoSe.size = model.videoModel.size;
    videoSe.id_p = model.videoModel.id_p;
    videoSe.time = model.videoModel.time;
    videoSe.thumbnail = model.videoModel.thumbnail;
    videoSe.URL = model.videoModel.URL;
    
    
    Content *content = [[Content alloc] init];
    content.segmentType = SegmentType_SegmentTypeVideo;
    content.data_p = [videoSe data];
    
    CSendMessage *cSendMessage = [[CSendMessage alloc] init];
    cSendMessage.sessionId = model.sessionId;
    cSendMessage.sender = model.user.userId;
    cSendMessage.sendTime = model.timestamp;
    cSendMessage.content = content;
    
    NSString *reqId = [NSString stringWithFormat:@"%zd", model.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgSendMessage extend:[cSendMessage data] reqId:reqId];
    
}




#pragma mark - 发送获取全部好友状态
/**
 发送获取全部好友状态
 
 @param array array
 */
- (void)sendGetAllFriendStatusCmd:(NSArray *)array {
    
    GPBUInt64Array *arrM = [[GPBUInt64Array alloc] init];
    for (NSArray *tempArray in array) {
        for (YPContacts *con in tempArray) {
            [arrM addValue:(uint64_t)con.user_id];
        }
    }
    
    CStateUser *cstate = [[CStateUser alloc] init];
    cstate.userIdArray = arrM;
    
    [self sendMessageToIMServerCmd:Cmd_CmsgStateUser extend:[cstate data] reqId:nil];
    
}

#pragma mark - 撤回消息
/**
 撤回消息
 
 @param message YPMessage
 */
- (void)sendWithdrawMessage:(YPMessage *)message {
    
    CDelMessage *delMessage = [[CDelMessage alloc] init];
    delMessage.sessionId = message.sessionId;
    delMessage.msgIdArray = [GPBUInt64Array arrayWithValue:message.messageId];
    [self sendMessageToIMServerCmd:Cmd_CmsgDelMessage extend:[delMessage data] reqId:nil];
    
}

// 撤回消息回执
- (void)userRecallMessage:(SDelMessage *)delMessage {
    
    for (NSUInteger index = 0; index < delMessage.msgIdArray.count; index++) {
        uint64_t messageId = [delMessage.msgIdArray valueAtIndex:index];
        NSString *whereStr = [NSString stringWithFormat:@"sessionId=%llu AND messageId=%llu", delMessage.sessionId,messageId];
        YPMessage *ypMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
        ypMessage.isDeleted = YES;
        ypMessage.isRecallMessage = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willRecallMessage:)]) {
            [self.delegate willRecallMessage:messageId];
        }
        
        if (ypMessage) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WHC_ModelSqlite update:ypMessage where:whereStr];
            });
        }
    }
}


/**
 发送消息
 
 @param cmd cmd
 @param data 实体
 */
- (void)sendMessageToIMServerCmd:(Cmd)cmd extend:(NSData *)data reqId:(NSString *)reqId  {
    MyPacket *myPacket = [[MyPacket alloc] init];
    myPacket.cmd = cmd;
    myPacket.uid = [AppModel sharedInstance].user_info.userId;;
    myPacket.reqId = reqId ? reqId : [NSString stringWithFormat:@"%f",[FunctionManager getNowTime]];;
    myPacket.extend = data;
    [[AFSocketManager shareManager] af_sendData:[myPacket data]];
}



#pragma mark - 退出登录
- (void)userSignout {
    [[AFSocketManager shareManager] af_close:nil];
    self.isConnectIM = NO;
    [AFSocketManager shareManager].isViewLoad = NO;
    //    [WHC_ModelSqlite removeModel:[YPMessage class]];
}

// 强制下线提醒
- (void)forcedOffline:(SKickOut *)model {
    dispatch_async(dispatch_get_main_queue(),^{
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate logOut];
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //        [view showWithText:[NSString stringWithFormat:@"%@", model.msg] button:@"确定" callBack:nil];
        [view showWithText:model.msg button:@"确定" callBack:nil];
    });
}

#pragma mark - 更新红包信息
// 更新红包信息  
- (void)updateRedPacketInfo:(EnvelopeMessage *)redPacketInfo {
    
    NSString *whereStr = [NSString stringWithFormat:@"redPacketInfo.redp_id=%@", redPacketInfo.redp_id];
    YPMessage *ypMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    ypMessage.redPacketInfo = redPacketInfo;
    if (ypMessage) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           BOOL isS = [WHC_ModelSqlite update:ypMessage where:whereStr];
            NSLog(@"1");
        });
    }
}

- (void)updateMessage:(NSInteger)messageId {
    
    NSString *whereStr = [NSString stringWithFormat:@"messageId=%ld", messageId];
    YPMessage *ypMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    ypMessage.deliveryState = MessageDeliveryState_Failed;
    if (ypMessage) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite update:ypMessage where:whereStr];
        });
    }
}



- (AVAudioPlayer *)player {
    if (!_player) {
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"af_sms-received.caf" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        //        _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}


@end



