//
//  TransferModel.h
//  WRHB
//
//  Created by AFan on 2020/1/3.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferModel : NSObject

/// 转账 ID
@property (nonatomic, assign) NSInteger transfer;
/// 转账人 ID
@property (nonatomic, assign) NSInteger send_Id;
/// 转账金额
@property (nonatomic, copy) NSString *money;
/// 标题
@property(nonatomic, readwrite, copy, null_resettable) NSString *title;
/// 创建时间
@property(nonatomic, readwrite) int64_t create;
/// 发送时间
@property(nonatomic, readwrite) int64_t sendTime;
/// 过期时间
@property(nonatomic, readwrite) int64_t expire;





/// 转账自己名称
@property (nonatomic, copy) NSString *sendName;
/// 转账对方 ID
@property (nonatomic, assign) NSInteger receiveId;
/// 转账对方名称
@property (nonatomic, copy) NSString *receiveName;


/// *********** 详情数据 ***********
/// 发送者ID
@property (nonatomic, assign) NSInteger sender;
/// 接收者ID
@property (nonatomic, assign) NSInteger receiver;
// Cell状态   1 等待 2 已领取 3 手动退还 4 超时退还     
@property (nonatomic, assign) TransferCellStatus cellStatus;
/// 发送时间
@property(nonatomic, readwrite) int64_t send_time;
/// 领取时间
@property(nonatomic, readwrite) int64_t receive_time;

@end

NS_ASSUME_NONNULL_END
