//
//  AppModel.h
//  Project
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


/// 客服|好友会话|我加入的群组
@property (nonatomic ,strong) NSMutableArray *myChatsDataList;
/// 我的好友列表
@property (nonatomic ,strong) NSMutableDictionary *myFriendListDict;
/// 所有群成员列表
@property (nonatomic ,strong) NSDictionary *myGroupFriendListDict;

/// 系统消息数量
@property (nonatomic ,assign) NSInteger sysMessageNum;
/// 未读总消息数量
@property (nonatomic ,assign) NSInteger unReadAllCount;
/// 最后更新的未读消息数
@property (nonatomic ,assign) NSInteger lastBadgeNum;
/// 好友的用户状态 在线-离线
@property (nonatomic ,strong) NSDictionary *userStateDict;

/// 俱乐部申请加入 数量
@property (nonatomic ,assign) NSInteger appltJoinClubNum;


// 单聊 或 群聊
@property (nonatomic, assign) NSInteger chatSessionType;

@property (nonatomic ,strong) NSDictionary *commonInfo;

@property (nonatomic, assign) BOOL isClubChat;

+ (instancetype)sharedInstance;
- (void)saveAppModel;   ///<登录存档
- (UIViewController *)rootVc;
-(NSArray *)ipArray;

@end
