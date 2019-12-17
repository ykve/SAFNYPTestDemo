//
//  SendRedPacketModel.h
//  WRHB
//
//  Created by AFan on 2019/10/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 发送红包成功后  返回的数据模型
@interface SendRedPacketModel : NSObject

/// 红包编号
@property (nonatomic, assign) NSInteger packet;
/// 创建时间
@property (nonatomic, assign) NSInteger *create;
/// 过期时间
@property (nonatomic, assign) NSInteger expire;
/// 红包名称
@property (nonatomic, copy) NSString *title;
/// 红包类型
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
