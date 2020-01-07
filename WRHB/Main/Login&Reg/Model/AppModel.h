//
//  AppModel.h
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UserInfo;
@class PayAssetsModel;

@interface AppModel : NSObject<NSCoding,NSCopying>

/// 3个月变更   如果有退出也会变更
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *event;
@property (nonatomic, assign) BOOL set_trade_password;


/// 用户信息
@property (nonatomic ,strong) UserInfo *user_info;
/// 用户金额相关信息
@property (nonatomic ,strong) NSArray<PayAssetsModel *> *assets;

// NO 正式版    YES 测试版
/// 是否测试模式
@property (nonatomic ,assign) BOOL isDebugMode;
@property (nonatomic ,copy) NSString *serverApiUrl;
/// ws URL  Socket
@property (nonatomic ,copy) NSString *wsSocketURL;
/// 全局声音
@property (nonatomic ,assign) BOOL turnOnSound;

/// 我的好友列表
@property (nonatomic ,strong) NSMutableDictionary *myFriendListDict;
/// 所有群成员列表
@property (nonatomic ,strong) NSDictionary *myGroupFriendListDict;

/// 好友的用户状态 在线-离线
@property (nonatomic ,strong) NSDictionary *userStateDict;




// 单聊 或 群聊
@property (nonatomic, assign) NSInteger chatSessionType;

@property (nonatomic ,strong) NSDictionary *commonInfo;

@property (nonatomic, assign) BOOL isClubChat;

+ (instancetype)sharedInstance;

- (void)handleModelFromDic:(NSDictionary*)dic;

- (void)saveAppModel;   ///<登录存档>

- (UIViewController *)rootVc;
-(NSArray *)ipArray;

@end
