//
//  Constants.h
//  WRHB
//
//  Created by AFan on 2019/9/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


///static NSString* const WXShareDescription  = @"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元";
static NSString* const WXShareTitle  = @"下载抢红包,每天签到领红包最高88.88，诚招代理0成本0门槛代理每天拉群抢最高8888元";

static NSString * const kMessRefundMessage = @"未领取的红包，将于5分钟后发起退款";
static NSString * const kMessCowRefundMessage = @"牛牛红包不结算红包金额，只结算输赢金额";

static NSString * const kRedpackedGongXiFaCaiMessage = @"恭喜发财，大吉大利";

static NSString * const kRedpackedExpiredMessage = @"该红包已超过5分钟，如已领取，可在<账单>中查询";

static NSString * const kGrabpackageNoMoneyMessage = @"金额不足，无法抢包";

static NSString * const kLookLuckDetailsMessage = @"看看大家的手气>";

static NSString * const kNoMoreRedpackedMessage = @"手慢了，红包派完了";

static NSString * const kSystemBusyMessage = @"系统繁忙，请稍后再试";

static NSString * const kOtherDevicesLoginMessage = @"您的账号在别的设备上登录，您被迫下线！";

static NSString * const kNetworkConnectionNotAvailableMessage = @"网络连接不可用，请稍后重试";

static NSString * const kAccountOrPasswordErrorMessage = @"账号或密码错误，请重新填写";


/// ************************ 通知 ************************
/// 需要刷新token通知
static NSString * const kOnConnectSocketNotification = @"kOnConnectSocketNotification";
/// token 失效通知
static NSString * const kTokenInvalidNotification = @"kTokenInvalidNotification";
/// 已注册通知
static NSString * const kRegistedNotification = @"kRegistedNotification";
/// 已登录通知
static NSString * const kLoginedNotification = @"kLoginedNotification";

/// 刷新群信息通知
static NSString * const kSystemAnnouncementNotification = @"kSystemAnnouncementNotification";



/// 未读消息数有变更
static NSString * const kUnreadMessageNumberChange = @"kUnreadMessageNumberChange";



/// TabBar BadgeValue update
static NSString * const kTabBarBadgeValueUpdateNotification = @"kTabBarBadgeValueUpdateNotification";


/// 更新我的好友或者客服列表
static NSString * const kUpdateMyFriendOrServiceMembersMessageList = @"kUpdateMyFriendOrServiceMembersMessageList";
/// 已经获取到我加入的群通知   完成后去发送请求离线消息
static NSString * const kDoneGetMyJoinedGroupsNotification = @"kDoneGetMyJoinedGroupsNotification";

/// 已登录IM
static NSString * const kLoggedIMSuccessNotification = @"kLoggedIMSuccessNotification";

/// 无网络通知
static NSString * const kNoNetworkNotification = @"kNoNetworkNotification";
/// 有网络通知
static NSString * const kYesNetworkNotification = @"kYesNetworkNotification";
/// 控制器已显示通知
static NSString * const kMessageViewControllerDisplayNotification = @"kMessageViewControllerDisplayNotification";

/// 中奖广播
static NSString * const kWinningBroadcastNotification = @"kWinningBroadcastNotification";
/// 系统消息列表
static NSString * const kSysMessageListNotification = @"kSysMessageListNotification";

/// 会话列表更新通知 新增、删除
static NSString * const kSessionListUpdateNotification = @"kSessionListUpdateNotification";
/// 聊天列表消息变更通知
static NSString * const kChatspListMessageChangeNotification = @"kChatspListMessageChangeNotification";
/// 刷新群信息通知  群信息变化也会引起列表变化   修改群名称 创建、删除群
static NSString * const kReloadMyMessageGroupList = @"kReloadMyMessageGroupList";


/// 会话信息更新通知 改变
static NSString * const kSessionInfoUpdateNotification = @"kSessionInfoUpdateNotification";
/// 会话成员更新通知 新增、删除、
static NSString * const kSessionMemberUpdateNotification = @"kSessionMemberUpdateNotification";

/// 通讯录更新   申请好友|
static NSString * const kAddressBookUpdateNotification = @"kAddressBookUpdateNotification";

/// 通讯录用户状态更新
static NSString * const kAddressBookUserStatusUpdateNotification = @"kAddressBookUserStatusUpdateNotification";
/// **************************** 刷新用户信息 ****************************
/// 刷新群信息通知
static NSString * const kRefreshUserInfoNotification = @"kRefreshUserInfoNotification";


/// 客服禁言通知
static NSString * const kKefuNoSpeakSessionNotification = @"kKefuNoSpeakSessionNotification";
/// 客服断开连接通知
static NSString * const kKefuDisconnectNotification = @"kKefuDisconnectNotification";


/// **************************** 俱乐部 ****************************
/// 俱乐部信息更新
static NSString * const kClubInfoUpdateNotification = @"kClubInfoUpdateNotification";
/// 申请加入俱乐部消息
static NSString * const kApplicationJoinClubNotification = @"kApplicationJoinClubNotification";




#endif /* Constants_h */
