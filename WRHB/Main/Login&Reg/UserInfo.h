//
//  UserInfo.h
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户性别
 */
typedef NS_ENUM(NSInteger, UserGender) {
    /// 未定义
    UserGender_Invalid = 0,
    /**
     *  未知性别
     */
    UserGender_Unknown = 1,
    /**
     *  性别男
     */
    UserGender_Male = 2,
    /**
     *  性别女
     */
    UserGender_Female = 3,
};



@interface UserInfo : NSObject<NSCoding>

/// 用户ID
@property (nonatomic, assign) NSInteger userId;
/// 用户名
@property (nonatomic, copy) NSString *name;
/// 用户头像
@property (nonatomic, copy) NSString *avatar;
/// 用户电话
@property (nonatomic, copy) NSString *mobile;
/// 推荐人
@property (nonatomic, copy) NSString *recommend;
/// 用户性别
@property (nonatomic, assign) UserGender sex;
/// 是否是代理
@property (nonatomic, assign) BOOL is_agent;
/// 今日充值
@property (nonatomic, copy) NSString *recharge;
/// 今日提现
@property (nonatomic, copy) NSString *withdraw;
/// 今日盈利
@property (nonatomic, copy) NSString *profit;
/// 今日优惠
@property (nonatomic, copy) NSString *reward;

/// 个性签名
@property (nonatomic, copy) NSString  *des;

@property (nonatomic, assign) BOOL isLogined;
/// 是否是游客登录
@property (nonatomic, assign) BOOL isGuestLogin;


@property (nonatomic, assign) BOOL managerFlag; // 是否管理员
@property (nonatomic, assign) BOOL groupowenFlag; // 是否是群主
@property (nonatomic ,assign) BOOL innerNumFlag; // yes  内部号 不限制说话字符


@end

