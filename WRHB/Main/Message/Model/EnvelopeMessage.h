//
//  EnvelopeMessage.h
//  Project
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//

//#import <RongIMLib/RongIMLib.h>



//@interface EnvelopeMessage : RCMessageContent<NSCoding>
@interface EnvelopeMessage : NSObject<NSCoding>

/** 红包ID */ 
@property(nonatomic, copy) NSString *redp_id;
/** 个人红包ID */
@property(nonatomic, copy) NSString *redPacket;

/** 红包类型, 1: 竞抢, 2: 牛牛 */
@property(nonatomic, readwrite) RedPacketType redpacketType;

/** 发送者 */
@property(nonatomic, readwrite) uint64_t sender;

/** 创建时间 */
@property(nonatomic, readwrite) int64_t create;

/** 过期时间 */
@property(nonatomic, readwrite) int64_t expire;

/** 雷号 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *mime;

/** 标题 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;

/** 发送时间 */
@property(nonatomic, readwrite) int64_t sendTime;
/** 总红包数 */
@property(nonatomic, readwrite) int32_t total;
/// 剩余红包数  红包状态用这个
@property(nonatomic, assign) NSInteger remain;



// Cell状态   (红包标识符+ userId) 获得
@property (nonatomic, assign) RedPacketCellStatus cellStatus;





/// 过期标识
@property(nonatomic, copy) NSString *expireMrak;



@end
