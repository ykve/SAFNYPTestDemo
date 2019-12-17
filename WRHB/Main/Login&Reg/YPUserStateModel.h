//
//  YPUserStateModel.h
//  WRHB
//
//  Created by AFan on 2019/11/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  好友状态枚举
 */
typedef NS_ENUM(NSInteger, YPUserState) {
    /** 手机离线 */
    UserState_Offline = 0,
    /** 手机在线 */
    UserState_Online = 1,
    /** 手机退到后台 */
    UserState_Background = 2,
};


@interface YPUserStateModel : NSObject<NSCopying>

/// 用户ID
@property (nonatomic, assign) NSInteger userId;
/** 用户状态 */
@property(nonatomic, assign) YPUserState state;
/** 离线时间 */
@property(nonatomic, readwrite) int64_t offlineTime;

@end

NS_ASSUME_NONNULL_END
