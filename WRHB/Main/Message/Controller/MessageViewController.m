//
//  MessageViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/31.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "MessageViewController.h"
#import "SessionSingle.h"
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

#import "JJScrollTextLable.h"
#import "SystemNotificationModel.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "BaseContactsController.h"
#import "CSAskFormController.h"
#import "SPAlertController.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SessionSingle *sessionSingle;
@property (nonatomic, strong) NSMutableArray *menuItems;
/// 是否还在当前控制器
@property (nonatomic, assign) BOOL isCurrentController;

@end

@implementation MessageViewController


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD hideHUD];
    
    self.isCurrentController = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getChatHistory:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [EasyOperater remove];
    self.isCurrentController = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"消息";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    _sessionSingle = [SessionSingle sharedInstance];
    [self setupSubViews];
    
    [self getMySessionData];
    //    dispatch_queue_t queue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    //    __weak __typeof(self)weakSelf = self;
    //    //创建异步函数
    //    dispatch_async(queue, ^{
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        NSLog(@"           =========任务1:%@",[NSThread currentThread]);
    //        [strongSelf getMySessionData];
    //    });
    //
    //    dispatch_barrier_async(queue, ^{
    //        NSLog(@"1");
    //    });
    
    
    //    //创建异步函数
    //    dispatch_async(queue, ^{
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        NSLog(@" =========任务2:%@",[NSThread currentThread]);
    //        [strongSelf getChatHistory:YES];
    //    });
    
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"通讯录" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    //    [self announcementBar];
    
    /// 网络变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noNetwork) name:kNoNetworkNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yesNetwork) name:kYesNetworkNotification object:nil];
    /// 消息列表变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatspListMessageChange:)name:kChatspListMessageChangeNotification object:nil];
    /// 群信息变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action_reload) name:kReloadMyMessageGroupList object:nil];
    /// 刷新会话信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMySessionData) name:kSessionListUpdateNotification object:nil];
    /// 控制器已显示
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageViewControllerDisplayNotification object: nil];
    
}


#pragma mark 收到消息重新刷新
- (void)chatspListMessageChange:(NSNotification *)notification {
    NSString *info = [notification object];
    if ([info isEqualToString:@"kChatspListMessageChangeNotification"]) {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf getChatHistory:NO];
        });
    }
}

- (void)getChatHistory:(BOOL)isFirst {
    NSString *query = [NSString stringWithFormat:@"select * from PushMessageNumModel where userId = %zd and chatSessionType == 1 or chatSessionType == 2 or chatSessionType == 3  group by sessionId  order by isTopTime desc,create_time desc", [AppModel sharedInstance].user_info.userId];
    
    NSArray *chatsArray = [WHC_ModelSqlite query:[PushMessageNumModel class] sql:query];
    if (chatsArray.count == 0 && isFirst) {
        [self.sessionSingle getMyChatsListSuccessBlock:^(NSDictionary *success) {
            NSLog(@"1");
        } failureBlock:^(NSError *error) {
            NSLog(@"1");
        }];
        return;
    }
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSInteger index =0; index < chatsArray.count; index++) {
        PushMessageNumModel *pushModel = chatsArray[index];
        ChatsModel *model = [[ChatsModel alloc] init];
        model.sessionId = pushModel.sessionId;
        
        model.name = pushModel.name;
        model.avatar = pushModel.avatar;
        //        model.play_type = pushModel.play_type;
        model.sessionType = pushModel.chatSessionType;
        model.userId = pushModel.sendUserId;
        
        BOOL isYes = YES;
        NSString *queryId = [NSString stringWithFormat:@"%zd_%ld",pushModel.sessionId,[AppModel sharedInstance].user_info.userId];
        ChatsModel *myModel = [[SessionSingle sharedInstance].mySessionListDictData valueForKey:queryId];
        isYes = NO;
        if (myModel) {
            isYes = YES;
            [tmpArray addObject:myModel];
        } else {
            [tmpArray addObject:model];
        }
        
        if (!isYes) {
            NSLog(@"1111");
            //            [SqliteManage removePushMessageNumModelSql:pushModel.sessionId];
        }
    }
    
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.dataArray removeAllObjects];
        strongSelf.dataArray = nil;
        [strongSelf.dataArray addObjectsFromArray:tmpArray];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
        
        [strongSelf calculateUnreadMessages];
    });
    
}


#pragma mark 收到消息重新刷新
- (void)updateValue:(NSNotification *)notification {
    if (self.isCurrentController) {
        NSString *info = [notification object];
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

- (void)setupSubViews {
    __weak __typeof(self)weakSelf = self;
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    //    view.backgroundColor = [UIColor redColor];
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    [_tableView YBGeneral_configuration];
    /// 添加手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pressAction:)];
    [self.tableView addGestureRecognizer:longpress];
    
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getMySessionData];
    }];
}



- (void)pressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {//手势开始
        CGPoint point = [longPressGesture locationInView:self.tableView];
        NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
        if (currentIndexPath.row == 0) {
            return;
        }
        NSLog(@"%ld",currentIndexPath.section);
        [self popSelectedCellAlert:currentIndexPath];
    }
}


// alert 默认动画(收缩动画)
- (void)popSelectedCellAlert:(NSIndexPath *)indexPath {
    
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"删除会话？" message:nil preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    //    alertController.needDialogBlur = _lookBlur;
    
    __weak __typeof(self)weakSelf = self;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"确定" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"点击了确定");
        [strongSelf deleteCell:indexPath];
    }];
    // SPAlertActionStyleDestructive默认文字为红色(可修改)
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    // 设置第2个action的颜色
    action2.titleColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -  删除会话
- (void)deleteCell:(NSIndexPath *)indexPath {
    ChatsModel *model = self.dataArray[indexPath.row];
    NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",model.sessionId,[AppModel sharedInstance].user_info.userId];
    [[MessageSingle sharedInstance].unreadAllMessagesDict removeObjectForKey:queryId];
    [SqliteManage removePushMessageNumModelSql:model.sessionId];
    
    [self.dataArray removeObject:model];
    [self.tableView reloadData];
    /// 移除消息数量
    PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
    [UnreadMessagesNumSingle sharedInstance].myMessageUnReadCount = pmModel.number;
}


#pragma mark - 计算验证未读消息
- (void)calculateUnreadMessages {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSInteger unRmessageNumm = 0;
        
        for (NSInteger index = 1; index < self.dataArray.count; index++) {
            ChatsModel *chatsModel = self.dataArray[index];
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
            PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
            
            unRmessageNumm += pmModel.number;
        }
        
        [UnreadMessagesNumSingle sharedInstance].myMessageUnReadCount = unRmessageNumm;
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"kUpdateSetBadgeValue"];
        
    });
}



- (void)action_reload {
    [self getMySessionData];
}


#pragma mark - 获取我加入的会话数据
- (void)getMySessionData {
    
    
    //    [self.sessionSingle saveMyChatsListSuccessBlock:^(NSDictionary *success) {
    //        NSLog(@"1")
    //    } failureBlock:^(NSError *error) {
    //        NSLog(@"1")
    //    }];
    
    __weak __typeof(self)weakSelf = self;
    [self.sessionSingle getMyJoinedSessionListSuccessBlock:^(NSDictionary *success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf getChatHistory:NO];
        /*! 回到主线程刷新UI */
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [MBProgressHUD hideHUD];
        //            [strongSelf.tableView reloadData];
        //            [strongSelf.tableView.mj_header endRefreshing];
        //        });
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
        [strongSelf reloadTableState];
    }];
}


- (void)delayReload {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadTableState) withObject:nil afterDelay:1];
}

- (void)reloadTableState {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_sessionSingle.isNetError){
        [_tableView.StateView showNetError];
    } else if(_sessionSingle.isEmptyMyJoin){
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if(cell == nil) {
        cell = [MessageTableViewCell cellWithTableView:tableView reusableId:@"MessageTableViewCell"];
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatsModel *model = self.dataArray[indexPath.row];
    if (model.sessionType == ChatSessionType_CustomerService) {
        
        CSAskFormController *vc = [[CSAskFormController alloc] init];
        vc.chatsModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        [self goto_Chat:model];
    }
    
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [EasyOperater remove];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        ChatsModel *service_model = [[ChatsModel alloc] init];
        service_model.sessionType = ChatSessionType_CustomerService;
        service_model.sessionId = kCustomerServiceID;
        service_model.name = @"在线客服";
        service_model.avatar = @"105";
        service_model.isJoinChatsList = YES;
        [_dataArray addObject:service_model];
    }
    return _dataArray;
}

@end
