//
//  MessageSingle.h
//  WRHB
//
//  Created by AFan on 2019/5/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageSingle : NSObject

+ (MessageSingle *)sharedInstance;
/// 用户ID + 所有群的ID
@property (nonatomic ,strong) NSMutableDictionary *unreadAllMessagesDict;

@end

NS_ASSUME_NONNULL_END



