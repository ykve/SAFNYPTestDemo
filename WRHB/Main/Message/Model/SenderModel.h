//
//  SenderModel.h
//  WRHB
//
//  Created by AFan on 2019/10/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SenderModel : NSObject

/// 名称
@property (nonatomic, assign) NSInteger ID;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 开红包人 的抢包结果
@property (nonatomic, copy) NSString *value;
/// 发包者输赢结果
@property (nonatomic, copy) NSString *result;
/////单聊发红包新字段
//红包总个数
@property (nonatomic, assign) NSInteger packet_count;
//红包剩余个数
@property (nonatomic, copy) NSString  *remain_count;
//红包标题
@property (nonatomic, copy) NSString  *title;
//红包数量
@property (nonatomic, copy) NSString  *amount;


@end

NS_ASSUME_NONNULL_END
