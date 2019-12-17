//
//  AppModel.h
//  WRHB
//
//  Created by AFan on 2019/10/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatManagerModel : NSObject

+ (ChatManagerModel *)sharedInstance;

// 我的好友列表
@property (nonatomic ,strong) NSDictionary *myFriendListDict;
/// 未读总消息
@property (nonatomic ,assign) NSInteger unReadAllCount;
/// 最后更新的未读消息数
@property (nonatomic ,assign) NSInteger lastBadgeNum;

// 单聊 或 群聊
@property (nonatomic, assign) NSInteger chatSessionType;


@end

NS_ASSUME_NONNULL_END
