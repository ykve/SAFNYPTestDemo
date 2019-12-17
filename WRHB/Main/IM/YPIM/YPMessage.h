//
//  YPMessage.h
//  Project
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+SSAdd.h"
#import "AFMessageConstants.h"


NS_ASSUME_NONNULL_BEGIN

@class EnvelopeMessage;
@class CowCowSettleVSModel;
@class NoRobSettleModel;
@class ImageModel;
@class AudioModel;
@class VideoModel;
@class BaseUserModel;
@class TeamMessageReceipt;
@class SingleMineSettleModel;

/**
 *  消息结构
 */
@interface YPMessage : NSObject<NSCopying>

/**
 *  消息类型
 */
@property (nonatomic, assign) MessageType messageType;

/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic, assign)         NSInteger sessionId;
/**
 消息ID,唯一标识
 */
@property (nonatomic, assign) NSInteger    messageId;


/**
 *  消息投递状态 仅针对发送的消息
 */
@property (nonatomic, assign)       MessageDeliveryState deliveryState;
/**
 消息 发送 or 接收 or 系统
 */
@property (nonatomic, assign) ChatMessageFrom messageFrom;
/**
 *  消息所属会话   群组还是个人 等
 */
@property (nonatomic, assign) ChatSessionType chatSessionType;

/**
 *  消息发送时间    时间戳
 *  @discussion 本地存储消息可以通过修改时间戳来调整其在会话列表中的位置，发完服务器的消息时间戳将被服务器自动修正
 */
@property (nonatomic, assign)                NSTimeInterval timestamp;
/**
 数据库的创建时间
 */
@property (nonatomic, strong) NSDate    *create_time;
/**
 *  是否是收到的消息
 *  @discussion 由于有漫游消息的概念,所以自己发出的消息漫游下来后仍旧是"收到的消息",这个字段用于消息出错是时判断需要重发还是重收
 */
@property (nonatomic, assign)       BOOL isReceivedMsg;



/**
 to   接收者 单聊
 */
@property (nonatomic, assign)         NSInteger toUserId;
/**
 to   接收者 对象
 */
@property (nonatomic, strong)         NSDictionary *receiver;
/**
 发送者
 */
@property (nonatomic, assign)  NSInteger messageSendId;
/**
 用户资料
 */
@property (nonatomic, strong) BaseUserModel    *user;



/**
 *  消息文本
 *  @discussion 消息中除 NIMMessageTypeText 和 NIMMessageTypeTip 外，其他消息 text 字段都为 nil
 */
@property (nullable,nonatomic, copy)                  NSString *text;
/**
 图片模型
 */
@property (nonatomic, strong) ImageModel *imageModel;
/**
 语音模型
 */
@property (nonatomic, strong) AudioModel *audioModel;
/**
 视频模型
 */
@property (nonatomic, strong) VideoModel *videoModel;

/**
 红包信息
 */
@property (nonatomic, strong) EnvelopeMessage    *redPacketInfo;
/**
 牛牛结算红包信息
 */
@property (nonatomic, strong) CowCowSettleVSModel    *cowCowVSModel;
/**
 禁抢结算红包信息
 */
@property (nonatomic, strong) NoRobSettleModel    *noRobModel;
/**
 单雷结算红包信息
 */
@property (nonatomic, strong) SingleMineSettleModel    *singleMineModel;

/**
 消息是否标记为已删除  为本地自己的
 */
@property (nonatomic, assign)       BOOL isDeleted;
/**
 消息是否标记为已撤回
 */
@property (nonatomic, assign)       BOOL isRecallMessage;


/**
 *  对端是否已读
 *  @discussion 只有当当前消息为 P2P 消息且 isOutgoingMsg 为 YES 时这个字段才有效，需要对端调用过发送已读回执的接口
 */
@property (nonatomic,assign)       BOOL isRemoteRead;
/**
 *  是否已发送群回执
 *  @discussion 只针对群消息有效
 */
@property (nonatomic,assign)       BOOL isTeamReceiptSended;
/**
 *  群已读回执信息
 *  @discussion 只有当当前消息为 Team 消息且 teamReceiptEnabled 为 YES 时才有效，需要对端调用过发送已读回执的接口
 */
@property (nonatomic,strong)   TeamMessageReceipt *teamReceiptInfo;




/**
 *  是否是往外发的消息
 *  @discussion 由于能对自己发消息，所以并不是所有来源是自己的消息都是往外发的消息，这个字段用于判断头像排版位置（是左还是右）。
 */
//@property (nonatomic, assign,readonly)       BOOL isOutgoingMsg;

/**
 *  消息发送者名字
 *  @discussion 当发送者是自己时,这个值可能为空,这个值表示的是发送者当前的昵称,而不是发送消息时的昵称。聊天室消息里，此字段无效。
 */
//@property (nullable,nonatomic, copy,readonly)         NSString *senderName;


/**
 *  是否在黑名单中
 *  @discussion YES 为被目标拉黑;
 */
//@property (nonatomic, assign,readonly) BOOL isBlackListed;

/// CellIDString
@property (nonatomic, copy) NSString     *cellString;
/// 是否需要显示时间
@property (nonatomic, assign) BOOL        showTime;
/// 单条消息背景图
@property (nonatomic, copy) NSString    *backImgString;





// ******************* 后面扩展使用 *******************

//@property (nonatomic, strong) NSMutableAttributedString  *attTextString;


// ********* 语音 *********
/// 音频时长(单位：秒) 展示时长  音频网络路径  本地路径  音频
@property (nonatomic, strong) NSString    *voiceRemotePath;
@property (nonatomic, strong) NSString    *voiceLocalPath;
/// 语音波浪图标及数组
@property (nonatomic, copy) NSString     *voiceImg;
@property (nonatomic, strong) NSArray     *voiceImgs;

// ********* 视频 *********
/// 短视频缩略图网络路径 本地路径  视频图片 local路径
@property (nonatomic, copy) NSString    *videoRemotePath;
@property (nonatomic, copy) NSString    *videoLocalPath;
/// @property (nonatomic, strong) UIImage     *videoImage;
@property (nonatomic, assign) NSInteger   videodDration;


// ********* Map *********
/// 地理位置纬度  经度   详细地址
@property (nonatomic, assign) double      latitude;
@property (nonatomic, assign) double      longitude;
@property (nonatomic, copy) NSString    *addressString;






/**
 判断当前时间是否展示
 
 @param lastTime 最后展示的时间
 @param currentTime 当前时间
 */
-(void)showTimeWithLastShowTime:(NSTimeInterval)lastTime currentTime:(NSTimeInterval)currentTime;


@end

NS_ASSUME_NONNULL_END


