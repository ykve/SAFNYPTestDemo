//
//  MessageViewController.m
//  Project
//
//  Created by AFan on 2019/11/31.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageNet.h"
#import "ChatViewController.h"
#import "MessageItem.h"
#import "EasyOperater.h"

#import "CustomerServiceAlertView.h"

#import "YPMenu.h"

#import "HelpCenterWebController.h"
#import "AgentCenterViewController.h"
#import "CreateGroupController.h"

#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "SqliteManage.h"
#import "UIImageView+WebCache.h"
#import "NetworkIndicatorView.h"

#import "MyFriendMessageListController.h"
#import "SLMarqueeControl.h"


#import "MessageTableViewCell.h"
#import "ChatsModel.h"

#import "BannerModels.h"
#import "BannerModel.h"
#import "JJScrollTextLable.h"
#import "SystemNotificationModel.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "BaseContactsController.h"
#import "CSAskFormController.h"


#define kViewTag 666
#define kBannerHeight 120

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

/// Banner
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) JJScorllTextLable *scorllTextLable;
@property (nonatomic, strong) NSArray<SystemNotificationModel *> *sysTextArray;
@property (nonatomic, strong) BannerModels *bannerModels;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageNet *model;
@property (nonatomic, strong) NSMutableArray *menuItems;
//
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, assign) BOOL isCurrentController;

/// 客服|好友会话|我加入的群组
@property (nonatomic ,strong) NSMutableArray *myChatsDataList;
@end

@implementation MessageViewController


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [self getMySessionData];
//    [self getBannerData];
//    [self getSystemNotificationData];
    
//    [self setBannerUI];
//    [self setTextScrollBarUI];
    [self setupSubViews];
    [self initLayout];
    
    
    
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
//    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"通讯录" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    //    [self announcementBar];
    
    // 系统公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemAnnouncementNotification:) name:kSystemAnnouncementNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action_reload) name:kReloadMyMessageGroupList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValue:)name:kUnreadMessageNumberChange object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"updatecycleScrollView" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetwork) name:kNoNetworkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yesNetwork) name:kYesNetworkNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageViewControllerDisplayNotification object: nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMySessionData) name:kSessionUpdateNotification object:nil];
    
    _myChatsDataList = [[AppModel sharedInstance].myChatsDataList mutableCopy];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    
}



-(void)enterFore {
    [self performSelector:@selector(getMySessionData) withObject:nil afterDelay:1.0];
    NSLog(@"进入前台");
}

#pragma mark 收到消息重新刷新
- (void)updateValue:(NSNotification *)noti {
    if (self.isCurrentController) {
        NSString *info = [noti object];
        if ([info isEqualToString:@"ChatspListNotification"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //                [UIView performWithoutAnimation:^{
                //                    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                //                }];
            });
        }
    }
}


#pragma mark ----- Layout
- (void)finishedPostBannerLayout:(CGFloat)changeY{
    if (self.cycleScrollView) {
        //        [self.cycleScrollView setSd_y:changeY+3];
        [self initLayout];
    }else{
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(changeY+3);
        }];
    }
}
- (void)initLayout {
    if (self.cycleScrollView) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.scorllTextLable.mas_bottom).offset(3);
        }];
    }else{
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(3);
        }];
    }
}

- (void)setupSubViews {
    __weak __typeof(self)weakSelf = self;
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    [_tableView YBGeneral_configuration];
    
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getMySessionData];
        
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getMySessionData];
    }];
    
    _tableView.StateView = [StateView StateViewWithHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getMySessionData];
    }];
    
}

#pragma mark - 计算验证未读消息
- (void)calculateUnreadMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [AppModel sharedInstance].unReadAllCount = 0;
        
        for (NSInteger index = 1; index < self.myChatsDataList.count; index++) {
            ChatsModel *chatsModel = self.myChatsDataList[index];
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
            PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
            
            [AppModel sharedInstance].unReadAllCount += pmModel.number;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"kUpdateSetBadgeValue"];
        
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD hideHUD];
    
    self.isCurrentController = YES;
    
    [self.tableView reloadData];
    
    
    [self calculateUnreadMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [EasyOperater remove];
    self.isCurrentController = NO;
}

- (void)action_reload {
    [self getMySessionData];
    [self getBannerData];
}



- (void)setBannerUI {
    
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, kBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.view addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.bannerModels.banners[index];
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:model.jump_url];
    //                vc.navigationItem.title = item.name;
    vc.title = model.title;
    vc.hidesBottomBarWhenPushed = YES;
    //[vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)setTextScrollBarUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"chats_message"];
    [self.view addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.size.mas_equalTo(19);
    }];
    
    //创建一个滚动文字的label
    JJScorllTextLable *label = [[JJScorllTextLable alloc] init];
    //    label.text = @"设置滚动文字的内容";   //设置滚动文字的内容
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHex:@"#343434"];
    label.rate = 0.3;
    [self.view addSubview:label]; //把滚动文字的lable加到视图
    _scorllTextLable = label;
    label.backgroundColor= [UIColor clearColor];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScorllTextLableEvent:)];
    //将手势添加到需要相应的view中去
    [label addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.centerY.equalTo(iconImageView.mas_centerY);
        make.height.mas_equalTo(40);
    }];
    
    //本项目github地址https://github.com/luowenqi/JJScrollText
    //还有图片轮播，github地址https://github.com/luowenqi/JJCyclePicView
    
    
    /*
     其他的可以设置的内容
     @property (nonatomic, assign) JJTextCycleStyle style;   //设置滚动的样式
     @property (nonatomic, assign)IBInspectable CGFloat interval; //设置滚动的间隔  70
     @property (nonatomic, assign)IBInspectable CGFloat rate;//滚动的速度  0~1  默认 0.5
     @property (nonatomic, copy)IBInspectable NSString *text;  //滚动的文字内容
     @property (nonatomic, strong) UIFont *font;  //设置滚动字体
     @property (nonatomic, strong)IBInspectable UIColor *textColor;  //设置文字颜色
     @property (nonatomic, assign) NSTextAlignment textAlignment;   //设置文字对齐方式
     - (void)pause;  //暂停
     - (void)stop;    //停止
     */
    
}

#pragma mark -  获取Banner数据
- (void)getBannerData {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/banner/group"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            BannerModels* model = [BannerModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.bannerModels = model;
            [strongSelf analysisData:model];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
        for (UIView* view in [self.view subviews]) {
            if (view.tag == 200) {
                [view removeFromSuperview];
            }
        }
        [strongSelf finishedPostBannerLayout:0];
    } progressBlock:nil];
}

- (void)analysisData:(BannerModels *)models {
    NSMutableArray *bannerUrlArray = [NSMutableArray array];
    for (BannerModel *model in models.banners) {
        [bannerUrlArray addObject:model.img_url];
    }
    self.cycleScrollView.imageURLStringsGroup = bannerUrlArray;
}

#pragma mark -  获取系统公告
- (void)getSystemNotificationData {
    
    NSArray *arr = @[@(1),@(2)];
    NSDictionary *parameters = @{
                                 @"type":arr
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/notice"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *modelArray = [SystemNotificationModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.sysTextArray = modelArray;
            [strongSelf sysAnalysisData:modelArray];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
        for (UIView* view in [self.view subviews]) {
            if (view.tag == 200) {
                [view removeFromSuperview];
            }
        }
        [strongSelf finishedPostBannerLayout:0];
    } progressBlock:nil];
}

#pragma mark - 系统公告刷新通知
- (void)systemAnnouncementNotification:(NSNotification *)notification {
    NSArray *array = notification.object;
    [self setSysTextArray:array];
}

- (void)sysAnalysisData:(NSArray<SystemNotificationModel *> *)sysTextArray {
    NSMutableString *muString = [NSMutableString string];
    if(sysTextArray.count > 0) {
        for (SystemNotificationModel *model in sysTextArray) {
            if (model.desTitle) {
                [muString appendString:model.desTitle];
            }
            if (model.detail) {
                [muString appendString:[NSString stringWithFormat:@"   %@;  ", model.detail]];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scorllTextLable.text = muString;
    });
    
}

#pragma mark - 公告栏点击事件
- (void)onScorllTextLableEvent:(UITapGestureRecognizer *)gesture {
    [self goto_SystemAlertViewController:self.sysTextArray];
}
#pragma mark - goto 系统公告栏
- (void)goto_SystemAlertViewController:(NSArray<SystemNotificationModel *> *)sysTextArray {
    NSMutableArray *announcementArray = [NSMutableArray array];
    if(sysTextArray.count > 0) {
        for (SystemNotificationModel *model in sysTextArray) {
            NSString *title = model.desTitle;
            NSString *content = model.detail;
            VVAlertModel *model = [[VVAlertModel alloc] init];
            model.name = title;
            if (content.length > 0) {
                model.friends = @[content];
            }
            [announcementArray addObject:model];
        }
    } else {
        return;
    }
    SystemAlertViewController *alertVC = [SystemAlertViewController alertControllerWithTitle:@"平台公告" dataArray:announcementArray];
    [self presentViewController:alertVC animated:NO completion:nil];
}

#pragma mark - 获取我加入的会话数据
- (void)getMySessionData {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/mines"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf handleGroupListData:response[@"data"] andIsChatsList:YES];
        } else {
            [strongSelf delayReload];
            if (!strongSelf.isFirst) {
                strongSelf.isFirst = YES;
            }
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
        [strongSelf reloadTableState];
    } progressBlock:nil];
    
}





-(void)handleGroupListData:(NSArray *)dataArray andIsChatsList:(BOOL)isChatsList {
    if (dataArray != NULL && [dataArray isKindOfClass:[NSArray class]]) {
        
        [self.myChatsDataList removeAllObjects];
        self.myChatsDataList = nil;
        [AppModel sharedInstance].unReadAllCount = 0;
        //        NSMutableArray *marray = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            
            ChatsModel *model = [ChatsModel mj_objectWithKeyValues:dict];
            if (model.sessionType == ChatSessionType_SystemRoom  || model.sessionType == ChatSessionType_ManyPeople_Game) {
                // 退群
                [self action_exitGroup:model.sessionId];
                continue;
            }
            model.isChatsList = isChatsList;
            [self.myChatsDataList addObject:model];
            
            // 计算一遍总未读消息
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",model.sessionId,[AppModel sharedInstance].user_info.userId];
            PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
            [AppModel sharedInstance].unReadAllCount += pmModel.number;
        }
        [AppModel sharedInstance].myChatsDataList = [self.myChatsDataList mutableCopy];
        
    } else {
        if ([AppModel sharedInstance].unReadAllCount > 0) {
            [AppModel sharedInstance].unReadAllCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"ChatspListNotification"];
        }
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -  退出群组请求  退群
/**
 退出群组请求  退群
 */
- (void)action_exitGroup:(NSInteger)sessionId {
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/leaveSession"];
    NSDictionary *parameters = @{
                                 @"session":@(sessionId)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}




- (void)delayReload {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadTableState) withObject:nil afterDelay:1];
}

- (void)reloadTableState {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_model.isNetError){
        [_tableView.StateView showNetError];
    } else if(_model.isEmptyMyJoin){
        [_tableView.StateView showEmpty];
    } else{
        [_tableView.StateView hidState];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        //        [UIView performWithoutAnimation:^{
        //            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //        }];
    });
}



#pragma mark - SectonHeader
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myChatsDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if(cell == nil) {
        cell = [MessageTableViewCell cellWithTableView:tableView reusableId:@"MessageTableViewCell"];
    }
    
    cell.model = self.myChatsDataList[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatsModel *model = self.myChatsDataList[indexPath.row];
    if (model.sessionType == ChatSessionType_CustomerService) {
        
        CSAskFormController *vc = [[CSAskFormController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self goto_Chat:model];
    }
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [EasyOperater remove];
}


#pragma mark - goto我的好友或客服消息界面
/**
 goto我的好友或客服消息界面
 
 @param type 3 客服  2 我的好友
 */
- (void)goto_MyFriendMessage:(NSInteger)type {
    MyFriendMessageListController *vc = [[MyFriendMessageListController alloc] init];
    vc.friendType = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - goto聊天界面
- (void)goto_Chat:(ChatsModel *)chatsModel {
    ChatViewController *vc = [ChatViewController chatsFromModel:chatsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




-(void)showMenu{
    if([EasyOperater isExist]){
        [EasyOperater remove];
    }else
        [[EasyOperater sharedInstance] show];
}

#pragma mark - 客服弹框  常见问题
- (void)actionShowCustomerServiceAlertView:(NSString *)messageModel {
    
    NSString *imageUrl = [AppModel sharedInstance].commonInfo[@"customer.service.window"];
    if (imageUrl.length == 0) {
        [self webCustomerService];
        return;
    }
    CustomerServiceAlertView *view = [[CustomerServiceAlertView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    
    [view updateView:@"常见问题" imageUrl:imageUrl];
    
    __weak __typeof(self)weakSelf = self;
    
    // 查看详情
    view.customerServiceBlock = ^{
        [weakSelf webCustomerService];
    };
    [view showInView:self.view];
}
- (void)webCustomerService {
    //    WKWebViewController *vc = [[WKWebViewController alloc] initWithUrl:[AppModel sharedInstance].commonInfo[@"pop"]];
    //    vc.title = @"在线客服";
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self goto_MyFriendMessage:3];
}


#pragma mark - 下拉菜单
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        
        __weak __typeof(self)weakSelf = self;
        
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_up"]
                                          title:@"快速充值"
                                         action:^(YPMenuItem *item) {
                                             //                                             UIViewController *vc = [[Recharge2ViewController alloc]init];
                                             //                                             vc.hidesBottomBarWhenPushed = YES;
                                             //                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_agent"]
                                          title:@"代理中心"
                                         action:^(YPMenuItem *item) {
                                             AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_help"]
                                          title:@"帮助中心"
                                         action:^(YPMenuItem *item) {
                                             HelpCenterWebController *vc = [[HelpCenterWebController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_rule"]
                                          title:@"玩法规则"
                                         action:^(YPMenuItem *item) {
                                             
                                             NSString *url = [NSString stringWithFormat:@"%@/dist/#/mainRules", [AppModel sharedInstance].commonInfo[@"website.address"]];
                                             WKWebViewController *vc = [[WKWebViewController alloc] init];
                                             [vc loadWebURLSring:url];
                                             vc.navigationItem.title = @"玩法规则";
                                             vc.hidesBottomBarWhenPushed = YES;
                                             //[vc loadWithURL:url];
                                             [self.navigationController pushViewController:vc animated:YES];
                                             
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_group"]
                                          title:@"创建群组"
                                         action:^(YPMenuItem *item) {
                                             CreateGroupController *vc = [[CreateGroupController alloc] init];
                                             vc.hidesBottomBarWhenPushed = YES;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      
                      
                      
                      
                      nil];
    }
    
    return _menuItems;
}

#pragma mark - 无网络警告视图
- (void)noNetwork {
    NetworkIndicatorView *view = [[NetworkIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    self.tableView.tableHeaderView = view;
}

- (void)yesNetwork {
    self.tableView.tableHeaderView = nil;
}

//导航栏弹出
- (void)rightBarButtonDown:(UIBarButtonItem *)sender
{
    BaseContactsController *vc = [[BaseContactsController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    YPMenu *menu = [[YPMenu alloc] initWithItems:self.menuItems];
//    menu.menuCornerRadiu = 5;
//    menu.showShadow = NO;
//    menu.minMenuItemHeight = 48;
//    menu.titleColor = [UIColor darkGrayColor];
//    menu.menuBackGroundColor = [UIColor whiteColor];
//    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
}

- (NSMutableArray *)myChatsDataList {
    if (!_myChatsDataList) {
        _myChatsDataList = [NSMutableArray array];
        
        ChatsModel *model = [[ChatsModel alloc] init];
        model.sessionType = ChatSessionType_CustomerService;
        model.sessionId = kCustomerServiceID;
        model.name = @"在线客服";
        model.avatar = @"105";
        model.isChatsList = YES;
        [_myChatsDataList addObject:model];
        
    }
    return _myChatsDataList;
}

@end
