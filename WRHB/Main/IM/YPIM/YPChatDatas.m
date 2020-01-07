//
//  YPChatDatas.m
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//


#import "YPChatDatas.h"
#import "EnvelopeMessage.h"
#import "NSTimer+SSAdd.h"

#define headerImg1  @"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg"
#define headerImg2  @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg"
#define headerImg3  @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg"

@implementation YPChatDatas

//处理接收的消息数组
+(NSMutableArray *)receiveMessages:(NSArray *)messages{
    
    NSMutableArray *array = [NSMutableArray new];
    for(NSDictionary *dic in messages){
        ChatMessagelLayout *layout = [YPChatDatas getMessageWithData:dic];
        [array addObject:layout];
    }
    return array;
}

//接受一条消息
+(ChatMessagelLayout *)receiveMessage:(id)message{
    return [YPChatDatas getMessageWithData:message];
}

//消息内容生成消息模型
+(ChatMessagelLayout *)getMessageWithData:(YPMessage *)message {
  
    if(message.messageType == MessageType_Text || message.messageType == MessageType_NoRob_SettleRedpacket) {  // 文本
        message.cellString   = YPChatTextCellId;
        // 默认气泡图片
        if(message.messageFrom == MessageDirection_SEND){
            message.backImgString = @"chat_text_qipao_send";
        }else{
            message.backImgString = @"chat_text_qipao_receive";
        }
    } else if(message.messageType == MessageType_Image) {  // 图片
        message.cellString   = YPChatImageCellId;
    } else if(message.messageType == MessageType_Voice) {  // 语音
        message.cellString   = YPChatVoiceCellId;
        
        if(message.messageFrom == MessageDirection_SEND){
            message.backImgString = @"chat_text_qipao_send";
            message.voiceImg = @"chat_animation_white3";
            message.voiceImgs =
            @[[UIImage imageNamed:@"chat_animation_white1"],
              [UIImage imageNamed:@"chat_animation_white2"],
              [UIImage imageNamed:@"chat_animation_white3"]];
        } else {
            message.backImgString = @"chat_text_qipao_receive";
            message.voiceImg = @"chat_animation3";
            message.voiceImgs =
            @[[UIImage imageNamed:@"chat_animation1"],
              [UIImage imageNamed:@"chat_animation2"],
              [UIImage imageNamed:@"chat_animation3"]];
        }
        
    } else if(message.messageType == MessageType_Video) {  // 视频
        message.cellString   = YPChatVideoCellId;
    } else if(message.messageType == MessageType_RedPacket){  // 红包
        message.cellString   = AFRedPacketCellId;
        
    } else if(message.messageType == MessageType_SendTransfer){  // 转账
        message.cellString   = AFTransferCellId;
        
    } else if(message.messageType == MessageType_CowCow_SettleRedpacket){  // 牛牛结算
        message.cellString   = CowCowVSMessageCellId;
        
    } else if(message.messageFrom == ChatMessageFrom_System) {  // 系统消息
        message.cellString   = NotificationMessageCellId;
        message.showTime = NO;
        
    } else {
        NSLog(@"🔴*********** 转本地模型未知类型:%zd ***********🔴",message.messageFrom);
    }
    
    
    
    if (message.messageFrom != ChatMessageFrom_System) {  // 不是系统消息都需要 进入
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userKey = [NSString stringWithFormat:@"%ld_%ld", message.sessionId, [AppModel sharedInstance].user_info.userId];
        if([user valueForKey:userKey] == nil){
            [user setValue:@(message.timestamp/1000) forKey:userKey];
            message.showTime = YES;
        }else{
            [message showTimeWithLastShowTime:[[user valueForKey:userKey] doubleValue] currentTime:message.timestamp/1000];
            if(message.showTime){
                [user setValue:@(message.timestamp/1000) forKey:userKey];
            }
        }
    }
    
    ChatMessagelLayout *layout = [[ChatMessagelLayout alloc] initWithMessage:message];
    return layout;
    
}



@end
