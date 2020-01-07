//
//  RedPacketDetListModel.h
//  WRHB
//
//  Created by AFan on 2019/10/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;
@class GrabPackageInfoModel;
@class SenderModel;
@class PopSummaryModel;


NS_ASSUME_NONNULL_BEGIN

@interface RedPacketDetModel : NSObject

/// 红包ID
@property (nonatomic, assign) NSInteger packetId;
///
@property (nonatomic, copy) NSString *title;
/// 发红包者
@property (nonatomic, strong) SenderModel *sender;
/// 发红包者
@property (nonatomic, strong) SenderModel *banker_info;
/// 已抢包金额
@property (nonatomic, copy) NSString *grab_value;
/// 抢包人信息
@property (nonatomic, strong) NSArray<GrabPackageInfoModel *> *grab_logs;
/// 抢包人信息私聊 type=6
@property (nonatomic, strong) GrabPackageInfoModel *graber;

/** 红包类型, 1: 竞抢, 2: 牛牛 */
@property (nonatomic, readwrite, assign) RedPacketType redpacketType;
/// 红包金额总数
@property (nonatomic, copy) NSString *total;
/// 剩余红包数量
@property (nonatomic, assign) NSInteger remain_piece;
/// 已抢包数量
@property (nonatomic, assign) NSInteger grab_piece;
/// popView
@property (nonatomic, strong) PopSummaryModel *summary;


// ************** 牛牛专有 **************
/// 剩余红包金额
@property (nonatomic, copy) NSString *remain_value;
/// 庄赢的次数
@property (nonatomic, assign) NSInteger banker_wins;
/// 闲赢的次数
@property (nonatomic, assign) NSInteger player_wins;



/// 是否是发送者
@property (nonatomic, assign) BOOL is_sender;
/// 红包状态
@property (nonatomic, assign) NSInteger status;
/// 发送者的金额
@property (nonatomic, assign) CGFloat itselfMoney;
@property (nonatomic, copy) NSString *exceptOverdueTimes;

/// 庄家点数
@property (nonatomic, assign) NSInteger bankerPointsNum;
/// 是否自己赢
@property (nonatomic, assign) NSInteger isItselfWin;
/// 自己的点数
@property (nonatomic, assign) NSInteger itselfPointsNum;

/// 庄家抢的金额
@property (nonatomic, assign) CGFloat bankerMoney;



@end

NS_ASSUME_NONNULL_END
