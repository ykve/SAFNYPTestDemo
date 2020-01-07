//
//  CServiceChatController.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "CServiceChatController.h"
#import <AVFoundation/AVFoundation.h>
#import "EnvelopeMessage.h"
#import "SessionSingle.h"
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
#import "CServiceChatController.h"
#import "CSAskFormController.h"
#import "GameFeedbackController.h"



@interface CServiceChatController ()<AFSystemBaseCellDelegate, SendRedPacketDelegate>

@property (nonatomic, strong) YPContacts *ypContacts;
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
@implementation CServiceChatController

static CServiceChatController *_chatVC;

// 信息列表过来的
+ (CServiceChatController *)chatsFromModel:(ChatsModel *)model {
    
    _chatVC = [[CServiceChatController alloc] initWithConversationType:model.sessionType
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


+ (CServiceChatController *)currentChat {
    return _chatVC;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"1");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        _chatVC = nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUnreadMessage];
    
    self.leftBtn = self.navigationItem.leftBarButtonItem;
    self.rightBtnArray = self.navigationItem.rightBarButtonItems;
    self.isCreateRpView = NO;
    self.isVSViewClick = NO;
    
    if (self.chatsModel.sessionType == ChatSessionType_SystemRoom || self.chatsModel.sessionType == ChatSessionType_ManyPeople_Game) {
        // 创建悬浮视图
        [self setEntrancePlazaView];
    }
    
}



- (void)notifyUpdateUnreadMessageCount {
    // 解决点击 更多... 取消返回不了的bug
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.navigationItem.rightBarButtonItems = self.rightBtnArray;
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
        
    }
}



#pragma mark - 点击头像事件
// 点击头像事件
//- (void)didTapCellPortrait:(NSString *)userId {
-(void)didTapCellChatHeaderImg:(BaseUserModel *)userInfo {
    
    if (self.chatSessionType == ChatSessionType_Private || self.chatSessionType == ChatSessionType_CustomerService) {
        // 聊天信息页
        //        [self goto_FriendChatInfo:userInfo];
        return;
    }
    
    [self.view endEditing:YES];
    if (userInfo.userId == [AppModel sharedInstance].user_info.userId) {
        return;
    }
//    [self.sessionInputView addMentionedUser:userInfo];
}


// 长按头像
-(void)didLongPressCellChatHeaderImg:(UserInfo *)userInfo {
    [self.view endEditing:YES];
    
    // 自己
    if (userInfo.userId == [AppModel sharedInstance].user_info.userId) {
        return;
    }
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
        
    } else if (tag == ChatExtensionBar_Album){ // 照片
        
        [super chatFunctionBoardClickedItemWithTag:10];
    } else if (tag == ChatExtensionBar_Camera){ // 拍摄
        
        [super chatFunctionBoardClickedItemWithTag:11];
    } else if(tag == ChatExtensionBar_MakeMoney){  // 赚钱
        [self goto_onShareBtn];
    } else {
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
        return;
        
    }
    
}
#pragma mark -  悬浮菜单入口  充值|玩法|加盟 、红包详情|分享|群信息|群规
- (void)onCzBtn {
    PayTopUpController *vc = [[PayTopUpController alloc] init];
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
    
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    
    NSString *url = nil;
    if (self.chatsModel.play_type == RedPacketType_SingleMine || self.chatsModel.play_type == RedPacketType_BanRob) {
        url = @"https://wr869.com/#/h5/playmethod/slqg";  //扫雷
    } else if (self.chatsModel.play_type == RedPacketType_BanRob) {
        url = @"https://wr869.com/#/h5/playmethod/jqqg";  //禁抢
    } else if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
        url = @"https://wr869.com/#/h5/playmethod/nnqg";  //牛牛
    } else if (self.chatsModel.play_type == RedPacketType_Relay) {
        url = @"https://wr869.com/#/h5/playmethod/jlqg";  //接力
    } else if (self.chatsModel.play_type == RedPacketType_Luckys) {
        url = @"https://wr869.com/#/h5/playmethod/lkqg";  //lucky
    } else if (self.chatsModel.play_type == RedPacketType_Fu) {
        url = @"https://wr869.com/#/h5/activity/mrdshb";  //福利
    }
    
    //    [vc loadWebURLSring:self.gamesTypeModel.goupRuleUrl];   /// 后台还没有好
    [vc loadWebURLSring:url];
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




-(void)didChatGoto_kefu {
    [self goto_CustomerService];
}
-(void)didChatGoto_feedbackBtn {
    GameFeedbackController *vc = [[GameFeedbackController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goto_CustomerService {
    //    return;
    ChatsModel *model = [[ChatsModel alloc] init];
    model.sessionType = ChatSessionType_CustomerService;
    model.sessionId = kCustomerServiceID;
    model.name = @"在线客服";
    model.avatar = @"105";
    model.isJoinChatsList = YES;
    
    CSAskFormController *vc = [[CSAskFormController alloc] init];
    
    vc.chatsModel = model;
    [self.navigationController pushViewController:vc animated:YES];
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


