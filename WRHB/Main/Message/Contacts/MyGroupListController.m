//
//  MyGroupListController.m
//  WRHB
//
//  Created by AFan on 2019/11/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MyGroupListController.h"
#import "SessionSingle.h"
#import "ChatViewController.h"
#import "MessageItem.h"
#import "EasyOperater.h"

#import "CustomerServiceAlertView.h"
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
#import "CTMyGroupListCell.h"
#import "ChatsModel.h"
#import "BannerModels.h"
#import "BannerModel.h"
#import "JJScrollTextLable.h"
#import "SystemNotificationModel.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "BaseContactsController.h"

@interface MyGroupListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SessionSingle *model;
@property (nonatomic, strong) NSMutableArray *menuItems;
//
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isCurrentController;
@property (nonatomic, strong) NSMutableArray *groupArray;

@end

@implementation MyGroupListController


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self getGroupData];
    [self setupSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGroupData) name:kReloadMyMessageGroupList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGroupData) name:kSessionListUpdateNotification object:nil];
    
}


- (void)getGroupData {
    self.groupArray = nil;
    for (NSDictionary *dict in [SessionSingle sharedInstance].mySessionListData) {
        ChatsModel *model = [ChatsModel mj_objectWithKeyValues:dict];
        if (model.sessionType == ChatSessionType_ManyPeople_NormalChat) {
            [self.groupArray addObject:model];
            continue;
        }
    }
  
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        if (self.groupArray.count == 0) {
            self.tableView.tableFooterView = [self setFootView];
        } else {
            self.tableView.tableFooterView = nil;
        }
    });
    
}



- (void)getMySessionData {
    
    __weak __typeof(self)weakSelf = self;
    [[SessionSingle sharedInstance] getMyJoinedSessionListSuccessBlock:^(NSDictionary *success) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getGroupData];
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
        [strongSelf reloadTableState];
    }];
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
    _tableView.rowHeight = 56;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    [_tableView YBGeneral_configuration];
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getMySessionData];
        
    }];
    
    _tableView.StateView = [StateView StateViewWithHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getGroupData];
    }];
    
    [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(3);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)delayReload {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(reloadTableState) withObject:nil afterDelay:0.2];
}

- (void)reloadTableState {
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
    });
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CTMyGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTMyGroupListCell"];
    if(cell == nil) {
        cell = [CTMyGroupListCell cellWithTableView:tableView reusableId:@"CTMyGroupListCell"];
    }
    
    cell.model = self.groupArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatsModel *model = self.groupArray[indexPath.row];
    [self goto_Chat:model];
}

#pragma mark - goto聊天界面
- (void)goto_Chat:(ChatsModel *)chatsModel {
    ChatViewController *vc = [ChatViewController chatsFromModel:chatsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)groupArray {
    if (!_groupArray) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

- (UIView *)setFootView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    //    backView.backgroundColor = [UIColor greenColor];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"bill_nodata_bg"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(188.5, 172.5));
    }];
    
    return backView;
}


@end
