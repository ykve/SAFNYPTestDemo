//
//  RedPacketProtocol.h
//  WRHB
//
//  Created by AFan on 2019/10/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#ifndef RedPacketProtocol_h
#define RedPacketProtocol_h

// 定义一个 协议
@protocol SendRedPacketDelegate <NSObject>

- (void)sendRedPacketMessageModel:(YPMessage *)message;

@end

#endif /* RedPacketProtocol_h */
