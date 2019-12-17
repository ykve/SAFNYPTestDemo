//
//  ChatViewController.m
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EnvelopeMessage.h"
#import "MessageNet.h"
#import "EnvelopeTipCell.h"
#import "EnvelopeTipMessage.h"

#import "MessageItem.h"
#import "GroupInfoViewController.h"
#import "WKWebViewController.h"
#import "EnvelopeNet.h"
#import "SqliteManage.h"
#import "RedPacketAnimationView.h"

#import "RedPacketDetListController.h"
#import "CowCowVSMessageCell.h"
#import "ImageDetailViewController.h"
#import "ChatNotifiCell.h"
#import "ShareDetailViewController.h"
#import "AlertViewCus.h"
#import "HelpCenterWebController.h"
#import "CustomerServiceAlertView.h"
#import "AgentCenterViewController.h"

#import "YPContacts.h"
#import "FriendChatInfoController.h"
#import "ChatsModel.h"
#import "SessionInfoModel.h"

#import "RedPacketDetModel.h"
#import "GrabPackageInfoModel.h"
#import "SenderModel.h"

#import "SendRedPacketController.h"
#import "NoRobSendRPController.h"
#import "WHC_ModelSqlite.h"
#import "CowCowSettleVSModel.h"
#import "UIButton+GraphicBtn.h"
#import "PayTopUpController.h"
#import "AppDelegate.h"
#import "ZMTabBarController.h"
#import "GamesTypeModel.h"
#import "CSAskFormController.h"
#import "PayTopUpTypeController.h"



@interface ChatViewController ()<AFSystemBaseCellDelegate, SendRedPacketDelegate>

// 红包详情模型
@property (nonatomic, strong) RedPacketDetModel *redEnDetModel;
// 抢红包视图
@property (nonatomic, strong) RedPacketAnimationView *redpView;
/// 会话信息
@property (nonatomic, strong) SessionInfoModel *sessionModel;

// 红包动画是否结束
@property (nonatomic, assign) BOOL isAnimationEnd;
// 抢红包结果数据
@property (nonatomic, assign) id response;
// 红包ID
@property (nonatomic, copy) NSString *redp_Id;
// 定时器
@property (nonatomic, strong) NSTimer *timerView;
// 聊天定时器
@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, assign) BOOL isChatTimer;


@property (nonatomic, strong) UIBarButtonItem *leftBtn;
@property (nonatomic, strong) NSArray *rightBtnArray;
//
@property (nonatomic, assign) BOOL isCreateRpView;
@property (nonatomic, assign) BOOL isVSViewClick;
// 播放音乐
@property (nonatomic, strong) AVAudioPlayer *player;

// 消息体数据
//@property (nonatomic, strong) RCMessageModel *messageModel;
@property (nonatomic, assign) NSInteger bankerId;



@property (nonatomic ,strong) NSMutableArray *dataList;



@end


// 群组类
@implementation ChatViewController

static ChatViewController *_chatVC;

// 信息列表过来的
+ (ChatViewController *)chatsFromModel:(ChatsModel *)model {
    
    _chatVC = [[ChatViewController alloc] initWithConversationType:model.sessionType
                                                          targetId:model.sessionId];
    //设置会话的类型，如单聊、群聊、聊天室、客服、公众服务会话等
    _chatVC.chatsModel = model;
    _chatVC.sessionId = model.sessionId;
    //设置聊天会话界面要显示的标题
    NSString *title = model.name;

    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    } else {
        _chatVC.title = title;
    }
    
    return _chatVC;
}


+ (ChatViewController *)currentChat {
    return _chatVC;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"1");
}

/// 禁止侧滑
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //    [[IQKeyboardManager sharedManager]setEnable:NO];
    self.extendedLayoutIncludesOpaqueBars = YES;  // 防止导航栏下移64   11.13 有用
    
    //设置聊天会话界面要显示的标题
    NSString *title = self.chatsModel.name;
    if (title.length > 12) {
        _chatVC.title = [NSString stringWithFormat:@"%@...", [title substringToIndex:12]];
    } else {
        _chatVC.title = title;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        _chatVC = nil;
    }
    if ((self.chatsModel.sessionType == ChatSessionType_SystemRoom  || self.chatsModel.sessionType == ChatSessionType_ManyPeople_Game) && [self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self action_exitGroup];
    } else if ([AppModel sharedInstance].isClubChat && [self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        self.tabBarController.selectedIndex = 0;
        if (self.chatsModel.sessionType == ChatSessionType_Clubs_Hall) {
            [self action_exitGroup];
        }
    }
    /// 启用侧滑手势
    if(self.chatsModel.sessionType != ChatSessionType_Clubs_Hall && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = BaseColor;
    
    if (!self.chatsModel.sessionId && self.chatSessionType == ChatSessionType_Private) {
        [self createSession];
    } else if (self.chatSessionType == ChatSessionType_CustomerService) {
        [self createServiceSession];
    }
    
    [self setNavUI];
    
    
    // 多条消息提示
    //    self.enableUnreadMessageIcon = YES;
    //    self.enableNewComingMessageIcon = YES;
    [self updateUnreadMessage];
    
    self.leftBtn = self.navigationItem.leftBarButtonItem;
    self.rightBtnArray = self.navigationItem.rightBarButtonItems;
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    
    //    self.view.backgroundColor = [UIColor greenColor];
    //    self.tableView.backgroundColor = [UIColor redColor];
    
    //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToBottom) name:@"scrollToBottom" object:nil];
    
    
//    if (self.chatsModel.sessionType == ChatSessionType_SystemRoom  || self.chatsModel.sessionType == ChatSessionType_ManyPeople_Game) {
//        // 创建悬浮视图
//        [self setEntrancePlazaView];
//    }
    
    /// 会话信息
    if (self.sessionId && (self.chatSessionType == ChatSessionType_SystemRoom || self.chatSessionType == ChatSessionType_ManyPeople_NormalChat  || self.chatsModel.sessionType == ChatSessionType_ManyPeople_Game)) {
        [self getSessionInfoData];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSessionData) name:kSessionInfoUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSessionInfoData) name:kSessionMemberUpdateNotification object:nil];
}

- (void)notifyUpdateUnreadMessageCount {
    // 解决点击 更多... 取消返回不了的bug
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItems = self.rightBtnArray;
}

 #pragma mark -  单人会话创建
/**
 单人会话创建
 */
- (void)createSession {
    NSDictionary *parameters = @{
                                 @"user":@(self.chatsModel.userId),   // 对方ID
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/createSession"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.sessionId = [response[@"data"][@"session"] integerValue];
            strongSelf.chatsModel.sessionId = strongSelf.sessionId;
            strongSelf.chatsModel.sessionType = ChatSessionType_Private;
            
            if (strongSelf.sessionId) {
                [strongSelf getSessionInfoData];
            }
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  客服会话创建
/**
 客服会话创建
 */
- (void)createServiceSession {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/createServiceSession"];
    entity.needCache = NO;
//    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.sessionId = [response[@"data"][@"session"] integerValue];
            strongSelf.chatsModel.sessionId = kCustomerServiceID;
            strongSelf.chatsModel.name = response[@"data"][@"title"];
            strongSelf.chatsModel.avatar = response[@"data"][@"avatar"];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  获取会话信息数据
- (void)getSessionInfoData {
    NSDictionary *parameters = @{
                                 @"session":@(self.sessionId)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/session/info"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.sessionModel = [SessionInfoModel mj_objectWithKeyValues:response[@"data"]];
            if (strongSelf.chatSessionType == ChatSessionType_Private) {
                strongSelf.chatsModel.play_type = strongSelf.sessionModel.play_type;
            }
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (BaseUserModel *model in strongSelf.sessionModel.group_users) {
                [dict setObject:model forKey:[NSString stringWithFormat:@"%ld_%ld", strongSelf.sessionId, model.userId]];   // 用户昵称
            }
            [AppModel sharedInstance].myGroupFriendListDict = [dict copy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark -  退出群组请求  退群
/**
 退出群组请求  退群
 */
- (void)action_exitGroup {
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/leaveSession"];
    NSDictionary *parameters = @{
                                 @"session":@(self.chatsModel.sessionId)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
//            [SqliteManage removeGroupSql:strongSelf.chatsModel.sessionId];
//            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
//             [MBProgressHUD showSuccessMessage:msg]; 
//            [strongSelf.navigationController popToViewController:[strongSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark -  发送红包后调用代理
- (void)sendRedPacketMessageModel:(YPMessage *)message {
    [self onLocalCreateMessage:message];
}

/**
 本地创建消息

 @param message 消息模型
 */
- (void)onLocalCreateMessage:(YPMessage *)message {
    
    message.sessionId = self.sessionId;
    message.messageId = [FunctionManager getNowTime];
    if (message.redPacketInfo.redpacketType == RedPacketType_Private) {
        message.chatSessionType = ChatSessionType_Private;
    } else if (message.redPacketInfo.redpacketType == RedPacketType_Normal) {
        message.chatSessionType = ChatSessionType_ManyPeople_NormalChat;
    } else {
        message.chatSessionType = ChatSessionType_SystemRoom;
    }
    
    
    message.messageFrom = MessageDirection_SEND;
    message.timestamp = message.messageId;
    message.create_time = [NSDate date];
    message.isReceivedMsg = YES;
    message.messageSendId = [AppModel sharedInstance].user_info.userId;
    message.deliveryState = MessageDeliveryState_Successful;
    
    message = [self.delegate willAppendAndDisplayMessage:message];
    
    // 消息数量保存 最后消息保存
    if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onIMReceiveMessage: messageCount:left:)]) {
        [self.receiveMessageDelegate onIMReceiveMessage:message messageCount:0 left:0];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [WHC_ModelSqlite insert:message];
        if (!isSuccess) {
            [WHC_ModelSqlite removeModel:[YPMessage class]];
            [WHC_ModelSqlite insert:message];
        }
    });
}
#pragma mark - 自己发送的红包  去重复
/**
 自己发送的红包 去重复
 
 @param redId 红包ID
 @param messageId 消息 ID
 */
- (void)receiveSendbyYourselfRedPacketId:(NSString *)redId messageId:(NSInteger)messageId {
    
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        ChatMessagelLayout *tableViewLayout = self.dataSource[index];
        if ([redId isEqualToString: tableViewLayout.message.redPacketInfo.redp_id]) {
            tableViewLayout.message.messageId = messageId;
            break;
        }
    }
    
    // 嵌套模型查询 school.city.name = '北京' 3层嵌套写法
    NSString *whereStr = [NSString stringWithFormat:@"sessionId=%zd AND redPacketInfo.redp_id = '%@'", self.sessionId,redId];
    YPMessage *ypMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    ypMessage.messageId = messageId;
    if (ypMessage) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [WHC_ModelSqlite update:ypMessage where:whereStr];
        });
    }
    
//    __weak __typeof(self)weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf.tableView reloadData];
//    });
}


#pragma mark - 红包结算状态
/**
 红包结算状态
 
 @param redId 红包ID
 @param remain 红包剩余数量
 */
- (void)receiveRedPacketStatusRedPacketId:(NSString *)redId remain:(NSInteger)remain {
    
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        ChatMessagelLayout *tableViewLayout = self.dataSource[index];
        if ([redId isEqualToString: tableViewLayout.message.redPacketInfo.redp_id]) {
            tableViewLayout.message.redPacketInfo.remain = remain;
            if (remain <= 0) {
                if (tableViewLayout.message.redPacketInfo.cellStatus > 0) {
                    break;
                }
                [self updateRedPackedStatus:tableViewLayout.message.redPacketInfo.redp_id cellStatus:RedPacketCellStatus_NoPackage];
            }
            break;
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
}

/**
 数据库更新红包状态
 
 @param redpId 红包 ID
 @param cellStatus 红包状态 0 没有点击(红包没抢)  1 已点击-(已领取)  2 已点击-(已被领完） 3 已点击-(红包已过期)
 */
- (void)updateRedPackedStatus:(NSString *)redpId cellStatus:(RedPacketCellStatus)cellStatus {
    
    for (ChatMessagelLayout *modelLayout in self.dataSource) {
        if ([redpId isEqualToString: modelLayout.message.redPacketInfo.redp_id]) {
            modelLayout.message.redPacketInfo.cellStatus = cellStatus;
            [[YPIMManager sharedInstance] updateRedPacketInfo:modelLayout.message.redPacketInfo];
            break;
        }
    }
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
}




#pragma mark goto发红包入口
/**
 发红包入口
 */
-(void)goto_sendRedPacketEnt {
    [self.view endEditing:YES];
    
    UINavigationController *vc;
    if (self.chatsModel.play_type == RedPacketType_BanRob) {
        
        NoRobSendRPController *vsendVC = [[NoRobSendRPController alloc] init];
        vc = [[UINavigationController alloc] initWithRootViewController:vsendVC];
        vsendVC.chatsModel = self.chatsModel;
        vsendVC.delegate = self;
    } else {
        
        if (self.chatsModel.play_type == RedPacketType_Fu) {
            [MBProgressHUD showTipMessageInWindow:@"当前会话不允许发红包"];
            return;
        }
        SendRedPacketController *vsendVC = [[SendRedPacketController alloc] init];
        vc = [[UINavigationController alloc] initWithRootViewController:vsendVC];
        vsendVC.chatsModel = self.chatsModel;
        vsendVC.delegate = self;
    }
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 抢红包
//- (void)action_tapCustom:(RCMessageModel *)messageModel {
- (void)action_tapCustom:(YPMessage *)messageModel {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"redpacket/grab"];
    NSDictionary *parameters = @{
                                 @"packet":messageModel.redPacketInfo.redp_id
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    self.response = nil;
    _timerView = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadTimer:) userInfo:nil repeats:NO];
    
    //    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.response = response;
        strongSelf.redp_Id = messageModel.redPacketInfo.redp_id;
        [strongSelf redPackedStatusJudgmentResponse:response];
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        [MBProgressHUD hideHUD];
        [strongSelf uploadTimer:nil];
        [[AFHttpError sharedInstance] handleFailResponse:error];
        [strongSelf.redpView disMissRedView];
    } progressBlock:nil];
    
}




#pragma mark - 获取红包详情

- (void)getRedPacketDetailsData:(YPMessage *)messageModel {
    
    NSDictionary *parameters = @{
                                 @"redpacket":messageModel.redPacketInfo.redp_id
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"redpacket/detail"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && ([[response objectForKey:@"status"] integerValue] == 1)) {
            [strongSelf analysisData:response];
            if (messageModel.redPacketInfo.cellStatus == RedPacketCellStatus_Normal) {
                [strongSelf goto_RedPackedDetail:messageModel.redPacketInfo.redp_id isCowCow:YES];
            } else {
                [strongSelf actionShowRedPackedView:messageModel];
            }
        } else {
            strongSelf.isCreateRpView = NO;
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isCreateRpView = NO;
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void)analysisData:(NSDictionary *)response {
    NSDictionary *data = [response objectForKey:@"data"];
    if (data != NULL) {
        
        RedPacketDetModel *redPacketDesModel = [RedPacketDetModel mj_objectWithKeyValues:data];
        _redEnDetModel = redPacketDesModel;
        [self.dataList removeAllObjects];
        
        NSInteger luckMaxIndex = 0;
        CGFloat moneyMax = 0.0;
        
        if (redPacketDesModel.remain_piece == 0) {
            
            for (NSInteger i = 0; i < redPacketDesModel.grab_logs.count; i++) {
                // 计算手气最佳
                GrabPackageInfoModel *grabInfo = redPacketDesModel.grab_logs[i];
                NSString *strMoney = [grabInfo.value stringByReplacingOccurrencesOfString:@"*" withString:@"0"];
                CGFloat money = [strMoney floatValue];
                if (money > moneyMax) {
                    moneyMax = money;
                    luckMaxIndex = i;
                }
            }
            
        }
        
        
        
        for (NSInteger i = 0; i < redPacketDesModel.grab_logs.count; i++) {
            
            GrabPackageInfoModel *grabInfo = redPacketDesModel.grab_logs[i];
            
            
            
            if (redPacketDesModel.redpacketType == 3) {
                // 禁抢暂不标雷
                //                    NSString *moneyLei = [objDict objectForKey:@"money"];
                //                    NSString *last = [moneyLei substringFromIndex:moneyLei.length-1];
                //                    NSDictionary *attrDict = [[self.redPackedInfoDetail objectForKey:@"attr"] mj_JSONObject];
                //
                //                    NSArray *bombListArray = (NSArray *)attrDict[@"bombList"];
                //
                //                    for (NSInteger index = 0; index < bombListArray.count; index++) {
                //                        NSString *bombNum = [NSString stringWithFormat:@"%ld", [bombListArray[index] integerValue]];
                //                        if ([last isEqualToString:bombNum]) {
                //                            [objDict setValue:@(YES) forKey:@"isMine"];
                //                            break;
                //                        } else {
                //                            [objDict setValue:@(NO) forKey:@"isMine"];
                //                        }
                //                    }
            }
            
            BOOL isItself = NO;
            //                SenderModel
            NSInteger userId = redPacketDesModel.sender.ID;
            if (userId == [AppModel sharedInstance].user_info.userId) {
                redPacketDesModel.is_sender = YES;
                isItself = YES;
            } else {
                isItself = NO;
            }
            
            if (redPacketDesModel.remain_piece == 0) {
                // 手气最佳
                if (luckMaxIndex == i) {
                    grabInfo.isLuck = YES;
                } else {
                    grabInfo.isLuck = NO;
                }
            }
            
            if (redPacketDesModel.redpacketType == 2) {  // 庄 闲
                // 是
                NSInteger sendUserId = redPacketDesModel.sender.ID;
                NSInteger userId =  redPacketDesModel.sender.ID;
                if (sendUserId == userId) {
                    grabInfo.is_banker = YES;
                } else {
                    grabInfo.is_banker = NO;
                }
                
                // 判断庄闲 输-赢
                if (redPacketDesModel.bankerPointsNum > grabInfo.nn_type) {
                    if (redPacketDesModel.is_sender) {
                        redPacketDesModel.isItselfWin = NO;
                    }
                } else if (redPacketDesModel.bankerPointsNum == grabInfo.nn_type) {
                    
                    if (redPacketDesModel.bankerMoney >= grabInfo.value.floatValue) {
                        if (redPacketDesModel.is_sender) {
                            redPacketDesModel.isItselfWin = NO;
                        }
                    } else {
                        if (redPacketDesModel.is_sender) {
                            redPacketDesModel.isItselfWin = YES;
                        }
                    }
                } else {
                    if (redPacketDesModel.is_sender) {
                        redPacketDesModel.isItselfWin = YES;
                    }
                }
            }
            //                [self.dataList addObject:model];
        }
    }
    
}







#pragma mark - Cell- 点击事件
// cell点击事件
- (void)didTapMessageCell:(YPMessage *)model {
    [super didTapMessageCell:model];
    [self.view endEditing:YES];
    
    if (model.messageType  == MessageType_RedPacket) {
        // 发送者ID
        self.bankerId = model.messageSendId;
        if (self.isCreateRpView) {
            return;
        }
        self.isCreateRpView = YES;
        if (model.redPacketInfo.redpacketType == RedPacketType_Private && model.messageSendId == [AppModel sharedInstance].user_info.userId) {
            [self goto_RedPackedDetail:model.redPacketInfo.redp_id isCowCow:NO];
        } else if (model.redPacketInfo.cellStatus == RedPacketCellStatus_MyselfReceived || model.redPacketInfo.cellStatus == RedPacketCellStatus_Expire || model.redPacketInfo.cellStatus == RedPacketCellStatus_NoPackage) {
            [self goto_RedPackedDetail:model.redPacketInfo.redp_id isCowCow:NO];
        } else if (model.redPacketInfo.redpacketType == RedPacketType_BanRob && model.messageSendId == [AppModel sharedInstance].user_info.userId) {
            [self goto_RedPackedDetail:model.redPacketInfo.redp_id isCowCow:NO];
        } else {
            [self getRedPacketDetailsData:model];
        }
    }
}






#pragma mark - 点击头像事件
// 点击头像事件
//- (void)didTapCellPortrait:(NSString *)userId {
-(void)didTapCellChatHeaderImg:(UserInfo *)userInfo {
    
    if (self.chatSessionType == ChatSessionType_Private || self.chatSessionType == ChatSessionType_CustomerService) {
        // 聊天信息页
        //        [self goto_FriendChatInfo:userInfo];
        return;
    }
    
    [self.view endEditing:YES];
    if (userInfo.userId == [AppModel sharedInstance].user_info.userId) {
        return;
    }
    [self.sessionInputView addMentionedUser:userInfo];
}


// 长按头像
-(void)didLongPressCellChatHeaderImg:(UserInfo *)userInfo {
    [self.view endEditing:YES];
    
    // 自己
    if (userInfo.userId == [AppModel sharedInstance].user_info.userId) {
        return;
    }
    
    //    if ([self.messageItem.userId isEqualToString:[AppModel sharedInstance].userInfo.userId] ) {
    //       [self.sessionInputView addMentionedUser:userInfo];
    //    }
    
    // 群主
    //    if ([self.messageItem.userId isEqualToString:[AppModel sharedInstance].user_info.userId] || [AppModel sharedInstance].user_info.innerNumFlag) {
    //        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    //        [view showWithText:[NSString stringWithFormat:@"昵称：%@\nID：%@",userInfo.name,userInfo.userId] button:@"好的" callBack:nil];
    //    }
}










-(void)uploadTimer:(NSTimer*)timer {
    self.isAnimationEnd = YES;
    
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
    
    if (_timerView != nil) {
        [_timerView invalidate];
    }
}


#pragma mark -  抢包视图动画结束
/**
 红包动画判断
 */
- (void)redpackedAnimationJudgment {
    if (self.response != nil) {
        [self redPackedStatusJudgmentResponse:self.response];
    }
}


#pragma mark -  抢包后红包状态判断
- (void)redPackedStatusJudgmentResponse:(id)response {
    
    if (self.isAnimationEnd == NO) {
        return;
    }
    
    NSInteger code = [[response objectForKey:@"status"] integerValue];
    if ([response objectForKey:@"status"] && code == 1) {
        // 正常
        [self.redpView disMissRedView];
        
        [self goto_RedPackedDetail:[NSString stringWithFormat:@"%ld", self.redEnDetModel.packetId] isCowCow:YES];
        [self updateRedPackedStatus:self.redp_Id cellStatus:RedPacketCellStatus_MyselfReceived];
        
#pragma mark - 声音判断
        NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", [AppModel sharedInstance].user_info.userId,self.chatsModel.sessionId];
        // 读取
        BOOL  isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
        if (!isSwitch && ![AppModel sharedInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
            [self.player play];
#endif
        }
        
    } else {
        
        //        [self.redpView updateView:_enveModel.redPackedInfoDetail response:response rpOverdueTime:self.chatsModel.rpOverdueTime];
        [self.redpView updateView:nil redEnDetModel:nil mesg:response[@"message"]];
        if (code == 2) {
            // 红包已抢完
            [self updateRedPackedStatus:self.redp_Id cellStatus:RedPacketCellStatus_NoPackage];
        } else if (code == 12) {
            // 已抢过红包
            //            [self updateRedPackedStatus:self.messageId cellStatus:RedPacketCellStatus_MyselfReceived];
        } else if (code == 13) {
            // 余额不足
        } else if (code == 14) {
            // 通讯异常，请重试
        } else if (code == 15) {
            // 单个红包金额不足0.01
        } else if (code == 3) {
            // 红包已过期
            [self updateRedPackedStatus:self.redp_Id cellStatus:RedPacketCellStatus_Expire];
        } else {
            NSLog(@"红包状态未定义");
        }
        
    }
    
}



/**
 抢红包视图
 
 @param messageModel 红包信息
 */
- (void)actionShowRedPackedView:(YPMessage *)messageModel {
    self.isAnimationEnd = NO;
    RedPacketAnimationView *view = [[RedPacketAnimationView alloc]initWithFrame:self.view.bounds];
    [view updateView:messageModel redEnDetModel:self.redEnDetModel mesg:nil];
    self.redpView = view;
    
    __weak __typeof(self)weakSelf = self;
    
    // 开红包
    view.openBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf action_tapCustom:messageModel];
    };
    // 查看详情
    view.detailBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goto_RedPackedDetail:[NSString stringWithFormat:@"%ld", strongSelf.redEnDetModel.packetId] isCowCow:YES];
    };
    // 视图消失
    view.animationBlock = ^{
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateRedPackedStatus:messageModel.redPacketInfo.redp_id cellStatus:RedPacketCellStatus_MyselfReceived];
        return ;
    };
    // 动画结束Block
    view.animationEndBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isAnimationEnd = YES;
        [strongSelf redpackedAnimationJudgment];
        return ;
    };
    // View消失Block
    view.disMissRedBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.isCreateRpView = NO;
        return ;
    };
    
//    if ([self getNowTimeWithCreate:model.message.redPacketInfo.create expire:model.message.redPacketInfo.expire] <= 0) {
//         [self updateRedPackedStatus:messageModel.messageId cellStatus:RedPacketCellStatus_Expire];
//     }
    
    NSInteger left = self.redEnDetModel.remain_piece;
    if (left == 0) {
        [self updateRedPackedStatus:messageModel.redPacketInfo.redp_id cellStatus:RedPacketCellStatus_NoPackage];
    }
    
    [view showInView:self.view];
}



#pragma mark - 即将发送消息
- (YPMessage *)willSendMessage:(YPMessage *)message {
    
    return message;
}


-(void)chatTimerStop {
    if (_chatTimer!=nil) {
        [_chatTimer invalidate];
        self.isChatTimer = NO;
    }
}


-(void)chatTimer:(NSTimer*)timer {
    //    NSLog(@"test......name=%@",timer.userInfo);
    [self chatTimerStop];
}


#pragma mark - 客服弹框
- (void)actionShowCustomerServiceAlertView:(NSString *)messageModel {
    
    NSString *imageUrl = [AppModel sharedInstance].commonInfo[@"customer.service.window"];
    if (imageUrl.length == 0) {
        [self goto_WebCustomerService];
        return;
    }
    CustomerServiceAlertView *view = [[CustomerServiceAlertView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    
    
    [view updateView:@"常见问题" imageUrl:imageUrl];
    
    __weak __typeof(self)weakSelf = self;
    
    // 查看详情
    view.customerServiceBlock = ^{
        [weakSelf goto_WebCustomerService];
    };
    [view showInView:self.view];
}

#pragma mark - 聊天功能扩展拦
//多功能视图点击回调  图片10  视频11  位置12
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)tag {
    
    //    NSLog(@"%ld",tag);
    [self.view endEditing:YES];
    if (tag == ChatExtensionBar_Fu) { // 福利红包
        
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
        return;
        //        SendRedPacketController *vc = [[SendRedPacketController alloc] init];
        //        vc.delegate = self;
        //        //        vc.isFu = YES;
        //        vc.CDParam = self.chatsModel;
        //        UINavigationController *navvc = [[UINavigationController alloc]initWithRootViewController:vc];
        //        [self presentViewController:navvc animated:YES completion:nil];
        
    } else if (tag == ChatExtensionBar_Join){ // 加盟
        AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == ChatExtensionBar_RedEnevpole){  // 红包
        
        SendRedPacketController *vsendVC = [[SendRedPacketController alloc] init];
        UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:vsendVC];
        vsendVC.chatsModel = self.chatsModel;
        vsendVC.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
        
    } else if (tag == ChatExtensionBar_Recharge){   // 充值
        [self onCzBtn];
        
    } else if (tag == ChatExtensionBar_WanFa){   // 玩法
        [self onWanfaBtn];
    } else if (tag == ChatExtensionBar_Rule){   // 群规
        [self groupRuleView];
    } else if (tag == ChatExtensionBar_Help){  // 帮助
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
        return;
        // 输入扩展功能板View
        //        [super chatFunctionBoardClickedItemWithTag:tag];
        HelpCenterWebController *vc = [[HelpCenterWebController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == ChatExtensionBar_CustomerService){  // 客服
//        [self actionShowCustomerServiceAlertView:nil];
        [self goto_CustomerService];
    } else if (tag == ChatExtensionBar_Album){ // 照片
        
        [super chatFunctionBoardClickedItemWithTag:10];
        //         [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        
        //        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    } else if (tag == ChatExtensionBar_Camera){ // 拍摄
        [super chatFunctionBoardClickedItemWithTag:11];
        //        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
    } else if(tag == ChatExtensionBar_MakeMoney){  // 赚钱
        [self goto_onShareBtn];
    } else {
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
        return;
        
    }
    
}
#pragma mark -  悬浮菜单入口  充值|玩法|加盟 、红包详情|分享|群信息|群规
- (void)onCzBtn {
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    ZMTabBarController *tab = (ZMTabBarController *)delegate.window.rootViewController;
//    tab.selectedIndex = 1;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    PayTopUpTypeController *vc = [[PayTopUpTypeController alloc] init];
    vc.isHidTabBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)onWanfaBtn {
    
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:self.gamesTypeModel.url];
    vc.title = @"玩法介绍";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 群规
 */
- (void)groupRuleView {
//    ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
//    vc.imageUrl = self.chatsModel.ruleImg;
//    vc.hiddenNavBar = YES;
//    vc.title = @"群规";
//    [self.navigationController pushViewController:vc animated:YES];
    
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    
//    NSString *url = nil;
//    if (self.chatsModel.play_type == RedPacketType_SingleMine) {
//        url = @"https://wr869.com/#/h5/playmethod/slqg";  //扫雷
//    } else if (self.chatsModel.play_type == RedPacketType_BanRob) {
//        url = @"https://wr869.com/#/h5/playmethod/jqqg";  //禁抢
//    } else if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
//        url = @"https://wr869.com/#/h5/playmethod/nnqg";  //牛牛
//    } else if (self.chatsModel.play_type == RedPacketType_Relay) {
//        url = @"https://wr869.com/#/h5/playmethod/jlqg";  //接力
//    } else if (self.chatsModel.play_type == RedPacketType_Luckys) {
//        url = @"https://wr869.com/#/h5/playmethod/lkqg";  //lucky
//    } else if (self.chatsModel.play_type == RedPacketType_Fu) {
//        url = @"https://wr869.com/#/h5/activity/mrdshb";  //福利
//    }
    
    [vc loadWebURLSring:self.gamesTypeModel.role];   /// 后台还没有好
//    [vc loadWebURLSring:url];
    vc.title = @"群规";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onJionBtn {
    AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 分享赚钱
 */
- (void)goto_onShareBtn {
    ShareDetailViewController *vc = [[ShareDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/// goto-红包详情
- (void)goto_RedPackedDetail:(NSString *)ID isCowCow:(BOOL)isCowCow {
    [self.view endEditing:YES];
    self.isVSViewClick = NO;
    RedPacketDetListController *vc = [[RedPacketDetListController alloc] init];
    vc.chatsModel = self.chatsModel;
    vc.isCowCow = isCowCow;
    vc.isRightBarButton = YES;
    vc.redPackedId = ID;
    vc.bankerId = self.bankerId;
    //    vc.returnPackageTime = [self.chatsModel.rpOverdueTime floatValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)goto_CustomerService {
//    return;
    ChatsModel *model = [[ChatsModel alloc] init];
    model.sessionType = ChatSessionType_CustomerService;
    model.sessionId = kCustomerServiceID;
    model.name = @"在线客服";
    model.avatar = @"105";
    model.isChatsList = YES;
    
    CSAskFormController *vc = [[CSAskFormController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}



/**
 goto Group info 群信息
 */
- (void)goto_GroupInfo {
    [self.view endEditing:YES];
    GroupInfoViewController *vc = [GroupInfoViewController groupVc:self.chatsModel];
    vc.sessionModel = self.sessionModel;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 goto 用户聊天信息
 */
- (void)goto_userInfo {
    [self.view endEditing:YES];
    [self goto_FriendChatInfo:nil];
}

/**
 好友聊天信息页
 
 @param contacts 联系人模型
 */
- (void)goto_FriendChatInfo:(YPContacts *)contacts {
    [self.view endEditing:YES];
    FriendChatInfoController *vc = [[FriendChatInfoController alloc] init];
    vc.contacts = contacts;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 网页在线客服
 */
- (void)goto_WebCustomerService {
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:[AppModel sharedInstance].commonInfo[@"pop"]];
    vc.title = @"在线客服";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - VS 视图查看详情 goto

// 点击VS牛牛Cell消息背景视图
- (void)didTapVSCowcowCell:(YPMessage *)model {
    if (self.isVSViewClick) {
        return;
    }
    self.isVSViewClick = YES;
    
    self.bankerId = model.cowCowVSModel.ID;
    NSString *redId = [NSString stringWithFormat:@"%ld", model.cowCowVSModel.ID];
    [self goto_RedPackedDetail:redId isCowCow:NO];
}

- (AVAudioPlayer *)player {
    if (!_player) {
        // 1. 创建播放器对象
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"success.mp3" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        //        _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回前一个页面的方法
- (void)leftBarButtonItemPressed:(id)sender{
    //    [super leftBarButtonItemPressed:sender];
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    //    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        _chatVC = nil;
        
    }
}

- (void)setNavUI {
    
    if (self.chatsModel.sessionType == ChatSessionType_SystemRoom  || self.chatsModel.sessionType == ChatSessionType_ManyPeople_Game) {
        
        UIButton *redpiconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [redpiconBtn setImage:[UIImage imageNamed:@"nav_redpacket_Icon"] forState:UIControlStateNormal];
        redpiconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [redpiconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [redpiconBtn addTarget:self action:@selector(goto_sendRedPacketEnt) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *exItem = [[UIBarButtonItem alloc]initWithCustomView:redpiconBtn];
        
        UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [info setImage:[UIImage imageNamed:@"nav_group_info"] forState:UIControlStateNormal];
        
        [info addTarget:self action:@selector(goto_GroupInfo) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
        
        self.navigationItem.rightBarButtonItems = @[infoItem,exItem];
        
    } else if (self.chatsModel.sessionType == ChatSessionType_Private) {
//        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_group_info"] style:UIBarButtonItemStyleDone target:self action:@selector(goto_userInfo)];
//        [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    } else if (self.chatsModel.sessionType == ChatSessionType_ManyPeople_NormalChat) {
        
        UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [info setImage:[UIImage imageNamed:@"nav_group_info"] forState:UIControlStateNormal];
        
        [info addTarget:self action:@selector(goto_GroupInfo) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
        
        self.navigationItem.rightBarButtonItem = infoItem;
    } else if (self.chatsModel.sessionType == ChatSessionType_Clubs_Hall) {
//        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonDown:)];
//        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }

    
}
#pragma mark -  俱乐部聊天出口
- (void)leftBarButtonDown:(UIBarButtonItem *)sender {
//    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setEntrancePlazaView {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar+15);
        make.right.equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(40, 146));
    }];
    
    UIButton *czBtn = [[UIButton alloc] init];
    [czBtn setTitle:@"充值" forState:UIControlStateNormal];
    [czBtn addTarget:self action:@selector(onCzBtn) forControlEvents:UIControlEventTouchUpInside];
    [czBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    czBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [czBtn setImage:[UIImage imageNamed:@"mess_chongzhi"] forState:UIControlStateNormal];
    [czBtn setImagePosition:WPGraphicBtnTypeTop spacing:2];
    [backView addSubview:czBtn];
    
    [czBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(48);
    }];
    
    
    UIButton *wanfaBtn = [[UIButton alloc] init];
    [wanfaBtn setTitle:@"玩法" forState:UIControlStateNormal];
    [wanfaBtn addTarget:self action:@selector(onWanfaBtn) forControlEvents:UIControlEventTouchUpInside];
    [wanfaBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    wanfaBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [wanfaBtn setImage:[UIImage imageNamed:@"mess_wanfa"] forState:UIControlStateNormal];
    [wanfaBtn setImagePosition:WPGraphicBtnTypeTop spacing:2];
    [backView addSubview:wanfaBtn];
    
    [wanfaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(czBtn.mas_bottom);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *jionBtn = [[UIButton alloc] init];
    [jionBtn setTitle:@"加盟" forState:UIControlStateNormal];
    [jionBtn addTarget:self action:@selector(onJionBtn) forControlEvents:UIControlEventTouchUpInside];
    [jionBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    jionBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [jionBtn setImage:[UIImage imageNamed:@"mess_jion"] forState:UIControlStateNormal];
    [jionBtn setImagePosition:WPGraphicBtnTypeTop spacing:2];
    [backView addSubview:jionBtn];
    
    [jionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wanfaBtn.mas_bottom);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(48);
    }];
    
    [self.view bringSubviewToFront:backView];
    
}

@end


