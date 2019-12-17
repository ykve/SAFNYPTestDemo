//
//  YPContactsController.m
//  Project
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BaseContactsController.h"
#import <QuartzCore/QuartzCore.h>

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "YPContacts.h"
#import "AFContactCell.h"
#import "PinYinForObjc.h"

#import "ChatViewController.h"

#import "YPMenu.h"
#import "HelpCenterWebController.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "UIButton+GraphicBtn.h"
#import "CreateGroupController.h"
#import "AddMemberController.h"
#import "ChatsModel.h"
#import "CSAskFormController.h"




@interface BaseContactsController ()<ContactsTableViewDelegate,ContactCellDelegate>

@property (nonatomic, strong) UIStackView *topStackView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) TopIndexType topIndex;
@property (nonatomic, strong) NSMutableArray *topBtnArray;

@property (nonatomic, strong) NSMutableArray *kefuArray;
@property (nonatomic, strong) NSMutableArray *haoyouArray;

@property (nonatomic, strong) NSMutableArray *sysArray;






@property (nonatomic, strong) NSMutableArray *indexTitles;

@property (nonatomic, strong) NSMutableArray *menuItems;
///
@property (nonatomic, strong) UILabel *messageMumLabel;

@end

@implementation BaseContactsController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    self.topIndex = self.selectedItemIndex;
    [self initData];
    
    [self queryContactsData];
    [self setupSubViews];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryContactsData) name:kAddressBookUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadState) name:kAddressBookUserStatusUpdateNotification object:nil];
}

- (void)setupSubViews {
    [self createTableView];
}

- (void)reloadState {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.contactTableView reloadData];
    });
    
}

-(void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    [self onClick_topBtn:nil selectedItemIndex:selectedItemIndex];
}


#pragma mark -  title  Index
- (void)onClick_topBtn:(UIButton *)sender selectedItemIndex:(NSInteger)selectedItemIndex {
    
    NSInteger index = 0;
    if (sender) {
        index = sender.tag -1000;
    } else {
        index = selectedItemIndex;
    }
    
    
    self.topIndex = index;
    if (index == 4) {
        [AppModel sharedInstance].sysMessageNum = 0;
    }
    
    // 空数据处理
    if (index == 0) {
        
    } else if (index == 1) {
        if (self.kefuArray.count <= 0) {
           self.contactTableView.tableView.tableFooterView = [self setFootView];
        } else {
            self.contactTableView.tableView.tableFooterView = nil;
        }
    } else  if (index == 2) {
        if (self.haoyouArray.count <= 0) {
            self.contactTableView.tableView.tableFooterView = [self setFootView];
        } else {
            self.contactTableView.tableView.tableFooterView = nil;
        }
    } else  if (index == 3) {
        if (self.groupArray.count <= 0) {
            self.contactTableView.tableView.tableFooterView = [self setFootView];
        } else {
            self.contactTableView.tableView.tableFooterView = nil;
        }
    } else {
        if (self.sysArray.count <= 0) {
            self.contactTableView.tableView.tableFooterView = [self setFootView];
        } else {
            self.contactTableView.tableView.tableFooterView = nil;
        }
    }
    
    [self.contactTableView reloadData];
}



- (void)createTableView {
    _contactTableView = [[YPContactsTableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-Height_NavBar-kTopItemHeight-Height_TabBar)];
    _contactTableView.delegate = self;
     _contactTableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    [self.view addSubview:self.contactTableView];
    
    __weak __typeof(self)weakSelf = self;
    self.contactTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf queryContactsData];
    }];
 
}



- (void)reloadTableView {
    self.contactTableView = [[YPContactsTableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT-Height_NavBar-kTopItemHeight-Height_TabBar)];
    self.contactTableView.delegate = self;
    [self.view addSubview:self.contactTableView];
}

- (void)initData {
    self.kefuArray = [[NSMutableArray alloc] init];
    self.haoyouArray = [[NSMutableArray alloc] init];
    self.groupArray = [[NSMutableArray alloc] init];
    self.sysArray = [[NSMutableArray alloc] init];
    self.indexTitles = [NSMutableArray array];
}


#pragma mark -  查询通讯录数据
/**
 查询通讯录数据
 */
- (void)queryContactsData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends"];
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.contactTableView.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf loadLocalData:[response objectForKey:@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.contactTableView.tableView.mj_header endRefreshing];
                [strongSelf.contactTableView reloadData];
            });
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.contactTableView.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
    
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

- (void)loadLocalData:(NSDictionary *)dataDict
{
    [self initData];
    
    
    // 客服
    NSMutableArray *serviceMembersArrayTemp = [[NSMutableArray alloc] init];
    YPContacts *contact = [[YPContacts alloc] init];
    contact.contactsType = FriendType_KeFu;
    contact.user_id = kCustomerServiceID;
    contact.name = @"在线客服";
    contact.des = @"有问题找客服";
    contact.avatar = @"chats_kefu";
    
    [serviceMembersArrayTemp addObject:contact];
    [self.kefuArray addObject:serviceMembersArrayTemp];
    
    
    NSArray *subordinateArray = (NSArray *)[dataDict objectForKey:@"subUsers"];   // 我邀请的人
    NSArray *friendsArray = (NSArray *)[dataDict objectForKey:@"friends"];   // 我的好友
    NSArray *requestArray = (NSArray *)[dataDict objectForKey:@"request"];   // 请求添加好友的人
    
    
    // ******** 邀请我的好友 + 好友申请 + 我推荐的好友 ********
    NSMutableArray *superiorArrayTemp = [[NSMutableArray alloc] init];
    YPContacts *superiorModel = [YPContacts mj_objectWithKeyValues:[dataDict objectForKey:@"recommend"]];  // 邀请我的人
    superiorModel.contactsType = FriendType_Super;
    if (superiorModel) {
        [superiorArrayTemp addObject:superiorModel];
    }
    
    if (superiorArrayTemp.count > 0) {
        [self.haoyouArray addObject:superiorArrayTemp];
        [self.indexTitles addObject:@"邀请我的好友"];  // 邀请我的好友
    }
    
    // ******** 请求添加好友的人 好友申请 ********
    NSMutableArray *requestArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < requestArray.count; i++) {
        YPContacts *contact = [[YPContacts alloc] initWithPropertiesDictionary:requestArray[i]];
        contact.contactsType = FriendType_Request;
        [requestArraytemp addObject:contact];
    }
    if (requestArraytemp.count > 0) {
        [self.haoyouArray addObject:requestArraytemp];
        [self.indexTitles addObject:@"好友申请"]; // 好友申请
//        [self.haoyouArray addObject:[NSArray array]];  // 因为本身它也有索引 title  现在多了一个推荐， 所以添加一个空的
    }
    
    // ****** 我邀请的好友 ******
    NSMutableArray *subordinateArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < subordinateArray.count; i++) {
        YPContacts *contact = [[YPContacts alloc] initWithPropertiesDictionary:subordinateArray[i]];
        contact.contactsType = FriendType_Sub;
        [subordinateArraytemp addObject:contact];
    }
    if (subordinateArray.count > 0) {
        [self.haoyouArray addObject:subordinateArraytemp];
        [self.indexTitles addObject:@"我邀请的好友"]; // 我邀请的好友
//        [self.haoyouArray addObject:[NSArray array]];  // 因为本身它也有索引 title  现在多了一个推荐， 所以添加一个空的
    }
    
    // ******** 正常好友 游戏好友 ********
    NSMutableArray *friendsArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < friendsArray.count; i++) {
        YPContacts *contact = [[YPContacts alloc] initWithPropertiesDictionary:friendsArray[i]];
        contact.contactsType = FriendType_Normal;
        [friendsArraytemp addObject:contact];
    }
    
    if (friendsArraytemp.count > 0) {
        [self.haoyouArray addObject:friendsArraytemp];
        [self.indexTitles addObject:@"游戏好友"];
//        [self.haoyouArray addObject:[NSArray array]];  // 因为本身它也有索引 title  现在多了一个推荐， 所以添加一个空的
    }
    
//    [self subordinateDataArray:friendsArraytemp];
    
    
    if ([AppModel sharedInstance].sysMessageNum > 0) {
        self.messageMumLabel.hidden = NO;
        self.messageMumLabel.text = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].sysMessageNum];
    } else {
        self.messageMumLabel.hidden = YES;
    }
    
    
    NSMutableDictionary *tempFriendDict = [[NSMutableDictionary alloc] init];
    // 添加到我的好友列表里面，包括普通群
//    [[AppModel sharedInstance].myFriendListDict removeAllObjects];
    for (NSArray *tempArray in self.haoyouArray) {
        for (YPContacts *model in tempArray) {
            NSString *userId = [NSString stringWithFormat:@"%ld_%ld",model.user_id,[AppModel sharedInstance].user_info.userId];
            [tempFriendDict setObject:model forKey:userId];
        }
    }
    [AppModel sharedInstance].myFriendListDict = [tempFriendDict copy];
    
    [self sendGetAllFriendStatusCmd];
    
    
}

#pragma mark -  获取全部好友状态
- (void)sendGetAllFriendStatusCmd {
    [[IMMessageManager sharedInstance] sendGetAllFriendStatusCmd:self.haoyouArray];
    
}
#pragma mark -  本地保存数据 
- (void)parsingLocalData {
    if ([AppModel sharedInstance].myFriendListDict.count > 0) {
        
        NSMutableArray *superiorArray = [[NSMutableArray alloc] init];
        NSMutableArray *subordinateArray = [[NSMutableArray alloc] init];
        NSMutableArray *haoyouArray = [[NSMutableArray alloc] init];
        
        NSArray *myFriendListArray = [[AppModel sharedInstance].myFriendListDict allValues];
        for (NSInteger index = 0; index < myFriendListArray.count; index++) {
            YPContacts *model = (YPContacts *)myFriendListArray[index];
            
            if (model.contactsType == FriendType_Super) {
                [superiorArray addObject:model];
            } else if (model.contactsType == FriendType_Sub) {
                [subordinateArray addObject:model];
            } else if (model.contactsType == FriendType_Normal) {
                [haoyouArray addObject:model];
            } else {
                NSLog(@"未知类型");
            }
        }
        
        [self.haoyouArray addObject:superiorArray];
        [self.haoyouArray addObject:[NSArray array]];
        [self.haoyouArray addObject:subordinateArray];
        [self.haoyouArray addObject:haoyouArray];
        
        
        [self.indexTitles addObject:@"邀"];
        if (subordinateArray.count > 0) {
            [self.indexTitles addObject:@"推"];
        }
        if (subordinateArray.count > 0) {
            [self.indexTitles addObject:@"好友"];
        }
        
//        [self subordinateDataArray:subordinateArray];
    }
}

#pragma mark -  拒绝 | 接受好友添加申请
- (void)cellAddFriendBtnIndex:(NSInteger)index model:(YPContacts *)model {

    
    BADataEntity *entity = [BADataEntity new];
    if (index == 0) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/approval"]; // 接受
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/refuse"];  // 拒绝
    }
    
    NSDictionary *parameters = @{
                                 @"user_id":@(model.user_id)};
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            [strongSelf queryContactsData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}



- (void)subordinateDataArray:(NSMutableArray *)subArray {
    
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (YPContacts *contact in subArray) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (YPContacts *contact in subArray) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    for (int index = 0; index < sectionArrays.count; index++) {
        NSMutableArray *sectionArray = (NSMutableArray *)sectionArrays[index];
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
        
        if (sortedSection.count) {
            [self.haoyouArray addObject:sortedSection];
            [self.indexTitles addObject:[[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:index]];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - UITableViewDelegate  UITableViewDataSource
// 设置头部title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
        
    } else {
        if (self.selectedItemIndex == TopIndexType_MyFriend) {
            if (section >= self.indexTitles.count) {
                return nil;
            }
            return [self.indexTitles objectAtIndex:section];
        }
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    header.contentView.backgroundColor= [UIColor whiteColor];
    [header.textLabel setTextColor:[UIColor colorWithHex:@"#333333"]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
}

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return 1;
    } else {
        
        if (self.topIndex == TopIndexType_KeFu) {
            return self.kefuArray.count;
        } else if (self.topIndex == TopIndexType_MyFriend) {
            return self.haoyouArray.count;
        } else if (self.topIndex == TopIndexType_MyGroup) {
            return self.groupArray.count;
        } else if (self.topIndex == TopIndexType_SysMessage) {
            return self.sysArray.count;
        }
        return 0;
    }
    
}

//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.topIndex == TopIndexType_KeFu) {
        return [[self.kefuArray objectAtIndex:section] count];
    } else if (self.topIndex == TopIndexType_MyFriend) {
        return [[self.haoyouArray objectAtIndex:section] count];
    } else if (self.topIndex == TopIndexType_MyGroup) {
        return [[self.groupArray objectAtIndex:section] count];
    } else if (self.topIndex == TopIndexType_SysMessage) {
        return [[self.sysArray objectAtIndex:section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    AFContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [AFContactCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    cell.delegate = self;
    // 搜索结果显示
    YPContacts *contact = nil;
    
    if (self.topIndex == TopIndexType_KeFu) {
        contact = (YPContacts *)[[self.kefuArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if (self.topIndex == TopIndexType_MyFriend) {
        contact = (YPContacts *)[[self.haoyouArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if (self.topIndex == TopIndexType_MyGroup) {
        contact = (YPContacts *)[[self.groupArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    } else if (self.topIndex == TopIndexType_SysMessage) {
        contact = (YPContacts *)[[self.sysArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.topIndex = self.topIndex;
    cell.model = contact;
    
    return cell;
    
}

// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

// 编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YPContacts *model;
    NSArray *models = nil;
    if (self.topIndex == TopIndexType_KeFu) {
        models = [self.kefuArray objectAtIndex:indexPath.section];
        model = (YPContacts *)[models objectAtIndex:indexPath.row];
        
        ChatsModel *chatModel = [[ChatsModel alloc] init];
        chatModel.name = model.name;
        chatModel.avatar = model.avatar;
        chatModel.sessionType = ChatSessionType_CustomerService;
        
        CSAskFormController *vc = [[CSAskFormController alloc] init];
        vc.model = chatModel;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if (self.topIndex == TopIndexType_MyFriend) {
        models = [self.haoyouArray objectAtIndex:indexPath.section];
    } else if (self.topIndex == TopIndexType_MyGroup) {
//        models = [self.groupArray objectAtIndex:indexPath.section];
    } else if (self.topIndex == TopIndexType_SysMessage) {
//        models = [self.sysArray objectAtIndex:indexPath.section];
    }
    
    if (indexPath.row >= models.count) {
        return;
    }
    model = (YPContacts *)[models objectAtIndex:indexPath.row];
    [self goto_groupChat:model];
}




#pragma mark - goto好友聊天界面
- (void)goto_groupChat:(YPContacts *)model {
    
    ChatsModel *chatModel = [[ChatsModel alloc] init];
    chatModel.name = model.name;
    chatModel.avatar = model.avatar;
    chatModel.sessionType = ChatSessionType_Private;
    chatModel.userId = model.user_id;
    
    ChatViewController *vc = [ChatViewController chatsFromModel:chatModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSMutableArray *)topBtnArray {
    if (!_topBtnArray) {
        _topBtnArray = [NSMutableArray array];
    }
    return _topBtnArray;
}


- (void)setupTopView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar +10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(70);
    }];
    
    
    _topStackView = [[UIStackView alloc] init];
    //    _topStackView.backgroundColor = [UIColor orangeColor];
    //子控件的布局方向
    _topStackView.axis = UILayoutConstraintAxisHorizontal;
    _topStackView.distribution = UIStackViewDistributionFillEqually;
    _topStackView.spacing = 5;
    _topStackView.alignment = UIStackViewAlignmentFill;
    //    _topStackView.frame = CGRectMake(0, 100, ScreenWidth, 200);
    [backView addSubview:_topStackView];
    [_topStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(backView);
        make.bottom.equalTo(backView.mas_bottom).offset(-3);
    }];
    
    CGFloat spacHeight = 3;
    
    UIButton *kfBtn = [UIButton new];
    [kfBtn setTitle:@"在线客服" forState:UIControlStateNormal];
    kfBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    //    [kfBtn setTitleColor:[UIColor colorWithHex:@"#363636"] forState:UIControlStateNormal];
    [kfBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [kfBtn setImage:[UIImage imageNamed:@"cc_laba"] forState:UIControlStateNormal];
    [kfBtn addTarget:self action:@selector(onClick_topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [kfBtn setImagePosition:WPGraphicBtnTypeTop spacing:spacHeight];
    //    [contentView addSubview:kfBtn];
    kfBtn.tag = 1000;
    [self.topStackView addArrangedSubview:kfBtn];
    [self.topBtnArray addObject:kfBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
    [backView addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom);
        make.left.equalTo(backView.mas_left);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/4, 2));
    }];
    
    UIButton *hyBtn = [UIButton new];
    [hyBtn setTitle:@"我的好友" forState:UIControlStateNormal];
    hyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [hyBtn setTitleColor:[UIColor colorWithHex:@"#363636"] forState:UIControlStateNormal];
    [hyBtn setImage:[UIImage imageNamed:@"cc_haoyou"] forState:UIControlStateNormal];
    [hyBtn addTarget:self action:@selector(onClick_topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [hyBtn setImagePosition:WPGraphicBtnTypeTop spacing:spacHeight];
    //    [contentView addSubview:kfBtn];
    hyBtn.tag = 1001;
    [self.topStackView addArrangedSubview:hyBtn];
    [self.topBtnArray addObject:hyBtn];
    
    UIButton *qzBtn = [UIButton new];
    [qzBtn setTitle:@"我的群组" forState:UIControlStateNormal];
    qzBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [qzBtn setTitleColor:[UIColor colorWithHex:@"#363636"] forState:UIControlStateNormal];
    [qzBtn setImage:[UIImage imageNamed:@"cc_qunzu"] forState:UIControlStateNormal];
    [qzBtn addTarget:self action:@selector(onClick_topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [qzBtn setImagePosition:WPGraphicBtnTypeTop spacing:spacHeight];
    //    [contentView addSubview:kfBtn];
    qzBtn.tag = 1002;
    [self.topStackView addArrangedSubview:qzBtn];
    [self.topBtnArray addObject:qzBtn];
    
    UIButton *sysBtn = [UIButton new];
    [sysBtn setTitle:@"系统消息" forState:UIControlStateNormal];
    sysBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [sysBtn setTitleColor:[UIColor colorWithHex:@"#363636"] forState:UIControlStateNormal];
    [sysBtn setImage:[UIImage imageNamed:@"cc_xiaoxi"] forState:UIControlStateNormal];
    [sysBtn addTarget:self action:@selector(onClick_topBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sysBtn setImagePosition:WPGraphicBtnTypeTop spacing:spacHeight];
    //    [contentView addSubview:kfBtn];
    sysBtn.tag = 1003;
    [self.topStackView addArrangedSubview:sysBtn];
    [self.topBtnArray addObject:sysBtn];
    
    UILabel *messageMumLabel = [[UILabel alloc] init];
    messageMumLabel.text = @"-";
    messageMumLabel.font = [UIFont systemFontOfSize:12];
    messageMumLabel.textColor = [UIColor whiteColor];
    messageMumLabel.textAlignment = NSTextAlignmentCenter;
    messageMumLabel.backgroundColor = [UIColor redColor];
    messageMumLabel.layer.cornerRadius = 10;
    messageMumLabel.layer.masksToBounds = YES;
    [sysBtn addSubview:messageMumLabel];
    _messageMumLabel = messageMumLabel;
    
    [messageMumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sysBtn.mas_top).offset(0);
        make.right.equalTo(sysBtn.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}


@end

