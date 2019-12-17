//
//  YPStatusDefine.h
//  WRHB
//
//  Created by AFan on 2019/11/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#ifndef YPStatusDefine_h
#define YPStatusDefine_h

typedef NS_ENUM(NSInteger, UIType) {
    ///  游戏大厅
    UIType_GameClub = 1,
    ///  选择房间
    UIType_SelectedRoom = 2
};

// 微聊 Top 下标类型
typedef NS_ENUM(NSInteger, TopIndexType) {
    ///  我的消息
    TopIndexType_MyMessage = 0,
    ///  在线客服
    TopIndexType_KeFu = 1,
    ///  我的好友
    TopIndexType_MyFriend = 2,
    ///  我的群组
    TopIndexType_MyGroup = 3,
    ///  系统消息
    TopIndexType_SysMessage = 4
    
};

// 俱乐部游戏类型
typedef NS_ENUM(NSInteger, GameOrLMType) {
    /// 游戏大厅
    GameOrLMType_Game = 0,
    /// 大联盟
    GameOrLMType_LM = 1
    
};


/// 消息显示最大数量
#define kMessageMaxNum 100

#define kBannerHeight 80
#define kTopItemHeight 100
#define JJScorllTextLableHeight 30
#define kGameTopHeight 120
/// 本地图片字符串长度
#define kAvatarLength 20
/// 客服 ID
#define kCustomerServiceID 9999999

#endif /* YPStatusDefine_h */
