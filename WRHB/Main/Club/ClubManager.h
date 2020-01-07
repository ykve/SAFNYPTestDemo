//
//  ClubManager.h
//  WRHB
//
//  Created by AFan on 2019/12/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClubInfo.h"
#import "ClubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClubManager : NSObject<NSCoding>
+ (ClubManager *)sharedInstance;

/// 俱乐部
@property (nonatomic, strong) ClubModel *clubModel;
/// 俱乐部信息
@property (nonatomic, strong) ClubInfo *clubInfo;

/// 是否点击 tabbar 进入的， 使用后，立即复位
@property (nonatomic, assign) BOOL isClickTabBarInChat;

@end

NS_ASSUME_NONNULL_END
