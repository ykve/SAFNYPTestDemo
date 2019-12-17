//
//  ClubMemberDetailsController.m
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberDetailsController.h"
#import "ClubMemberDetailsView.h"
#import "ClubMemberDetailsListModel.h"
#import "ClubMDetailsTableViewCell.h"
#import "ClubMemberDetailsModel.h"
#import "PayAssetsModel.h"

#import "ClubManager.h"
#import "ClubMemberModel.h"

#import "TFPopup.h"
#import "ClubListView.h"
#import "ClubInitiator.h"
#import "ClubApplicationListCell.h"
#import "ClubMemberDetailsModels.h"
#import "ClubMemberSummaryModel.h"
#import "UIButton+GraphicBtn.h"
#import "RedPacketDetListController.h"

#define kMarginWidth  15

static CGFloat const TableViewHeadHeight = 370;
static CGFloat const TableViewHeadTopHeight = 45;

@interface ClubMemberDetailsController ()<UITableViewDataSource, UITableViewDelegate>

///
@property (nonatomic, strong) UIView *headerContentView;
/// 头像
@property (nonatomic, strong) UIImageView *headImageView;
/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// 账号
@property (nonatomic, strong) UILabel *idLabel;
/// 性别
@property (nonatomic, strong) UIImageView *genderImageView;
/// 余额
@property (nonatomic, strong) UILabel *moneyLabel;
/// 在线离线
@property (nonatomic, strong) UIButton *onlineBtn;

@property (nonatomic, strong) ClubMemberDetailsView *vvMemberView;


/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;
///
@property (nonatomic, strong) ClubMemberModel *selectedMemberModel;

///
@property (nonatomic, strong) ClubMemberDetailsModels *memberDetailsModels;


@end

@implementation ClubMemberDetailsController

/// 导航栏透明功能
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"成员管理";
    
    
    [self setupUI];
    [self setAaView];
    [self setupTableViewHeadUI];
    
    [self.view addSubview:self.tableView];
    [self getClubMemberInfo];
    
    [self.tableView registerClass:[ClubMDetailsTableViewCell class] forCellReuseIdentifier:@"ClubMDetailsTableViewCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClubMemberInfo];
    }];
    
}


- (void)setAaView {
    
    NSArray *aaArray = @[
                         @{@"title":@"累计充值", @"Text":@"-"},
                         @{@"title":@"累计提现", @"Text":@"-"},
                         @{@"title":@"俱乐部盈利", @"Text":@"-"},
                         @{@"title":@"俱乐部流水", @"Text":@"-"},
                         @{@"title":@"累计发包", @"Text":@"-"},
                         @{@"title":@"发包金额", @"Text":@"-"},
                         @{@"title":@"累计抢包", @"Text":@"-"},
                         @{@"title":@"抢包金额", @"Text":@"-"}];
    
    ClubMemberDetailsView *vvMemberView = [[ClubMemberDetailsView alloc] initWithFrame:CGRectMake(15, 160, kSCREEN_WIDTH-15*2, 146)];
    vvMemberView.layer.cornerRadius = 8;
    vvMemberView.layer.masksToBounds = YES;
    vvMemberView.backgroundColor = [UIColor whiteColor];
    [self.headerContentView addSubview:vvMemberView];
    _vvMemberView = vvMemberView;
    
    vvMemberView.model = aaArray;
}



/**
 更新用户数据
 */
- (void)updateMeInfoView {
    
    if (self.memberDetailsModels.detail.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", self.memberDetailsModels.detail.avatar]];
        if (image) {
            self.headImageView.image = image;
        } else {
            self.headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImageView cd_setImageWithURL:[NSURL URLWithString:self.memberDetailsModels.detail.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
//    NSInteger sex = [AppModel sharedInstance].user_info.sex;
//    if(sex == 2) {
//        self.genderImageView.image = [UIImage imageNamed:@"me_male"];
//    } else {
//        self.genderImageView.image = [UIImage imageNamed:@"me_female"];
//    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"昵称:%@", [AppModel sharedInstance].user_info.name];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",[AppModel sharedInstance].user_info.userId];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"余额:%@元", self.memberDetailsModels.detail.asset.over_num ? self.memberDetailsModels.detail.asset.over_num: @"0.00"];
    
    
    [self setHeadText];
}

- (void)setHeadText {
    
    NSArray *aaArray = @[
                         @{@"title":@"累计充值", @"Text":self.memberDetailsModels.summary.charge},
                         @{@"title":@"累计提现", @"Text":self.memberDetailsModels.summary.withdraw},
                         @{@"title":@"俱乐部盈利", @"Text":self.memberDetailsModels.summary.win},
                         @{@"title":@"俱乐部流水", @"Text":self.memberDetailsModels.summary.capital},
                         @{@"title":@"累计发包", @"Text":[NSString stringWithFormat:@"%zd", self.memberDetailsModels.summary.send_count]},
                         @{@"title":@"发包金额", @"Text":self.memberDetailsModels.summary.send_number},
                         @{@"title":@"累计抢包", @"Text":[NSString stringWithFormat:@"%zd", self.memberDetailsModels.summary.grab_count]},
                         @{@"title":@"抢包金额", @"Text":self.memberDetailsModels.summary.grab_number}];
    self.vvMemberView.model = aaArray;
}


#pragma mark - 用户详情
- (void)getClubMemberInfo {
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID),   // 俱乐部ID
                                 @"user":@(self.model.ID),  // 用户
                                 @"pageSize":@(30),   // 页大小
                                 @"current":@(1)     // 当前页
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/reportUser"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            ClubMemberDetailsModels *memberDetailsModel = [ClubMemberDetailsModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.memberDetailsModels = memberDetailsModel;
            strongSelf.dataArray = [memberDetailsModel.data copy];
            [strongSelf updateMeInfoView];
            [strongSelf.tableView reloadData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT -kiPhoneX_Bottom_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        //        _tableView.rowHeight = 44;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     return self.dataArray.count;
    
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClubMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubMDetailsTableViewCell"];
    if(cell == nil) {
        cell = [ClubMDetailsTableViewCell cellWithTableView:tableView reusableId:@"ClubMDetailsTableViewCell"];
    }
    ClubMemberDetailsListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    __weak __typeof(self)weakSelf = self;
//    cell.memberOperationTypeBlock = ^(ClubMemberModel *model, id cell) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.selectedMemberModel = model;
//        ClubMemberCell *viewCell = (ClubMemberCell *)cell;
//        UIWindow * window= [[[UIApplication sharedApplication] delegate] window];
//        CGRect rect= [viewCell.operationTypeBtn convertRect: viewCell.operationTypeBtn.bounds toView:window];
//        CGPoint point = rect.origin;
//        strongSelf.redPoint = CGPointMake(point.x + 20, point.y + 25);
//        [strongSelf memberOperationType];
//    };
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClubMemberDetailsListModel *model = self.dataArray[indexPath.row];
    [self goto_RedPackedDetail:model];
}

#pragma mark -  goto红包详情
- (void)goto_RedPackedDetail:(ClubMemberDetailsListModel *)model {
    [self.view endEditing:YES];
    
    NSInteger taID = model.packet_id;
    
    RedPacketDetListController *vc = [[RedPacketDetListController alloc] init];
    vc.redPackedId = [NSString stringWithFormat:@"%zd", taID];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    
    UIView *headerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, TableViewHeadHeight)];
    headerContentView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    _headerContentView = headerContentView;
    self.tableView.tableHeaderView = headerContentView;
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"club_member_topbg"];
    backImageView.userInteractionEnabled = YES;
    [self.headerContentView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.mas_top);
        make.left.right.equalTo(self.headerContentView);
        make.height.mas_equalTo(245);
    }];
    
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
    headImageView.layer.cornerRadius = 65/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth = 1.5;
    headImageView.layer.borderColor = [UIColor colorWithRed:0.914 green:0.804 blue:0.631 alpha:1.000].CGColor;
    headImageView.userInteractionEnabled = YES;
    [backImageView addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(Height_NavBar +15);
        make.left.equalTo(backImageView.mas_left).offset(kMarginWidth);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [backImageView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top).offset(5);
        make.left.equalTo(headImageView.mas_right).offset(10);
    }];
    
    UIImageView *genderImageView = [[UIImageView alloc] init];
    genderImageView.image = [UIImage imageNamed:@"me_gender_woman"];
    [backImageView addSubview:genderImageView];
    _genderImageView = genderImageView;
    
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.text = @"-";
    idLabel.font = [UIFont systemFontOfSize:14];
    idLabel.textColor = [UIColor whiteColor];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [backImageView addSubview:idLabel];
    _idLabel = idLabel;
    
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-5);
        make.left.equalTo(headImageView.mas_right).offset(10);
    }];
    
    
    UIButton *cclickBackViewBtn = [[UIButton alloc] init];
    [cclickBackViewBtn addTarget:self action:@selector(gotoMeInfo) forControlEvents:UIControlEventTouchUpInside];
    cclickBackViewBtn.backgroundColor = [UIColor clearColor];
    [backImageView addSubview:cclickBackViewBtn];
    [cclickBackViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.centerX.equalTo(headImageView.mas_centerX);
        make.bottom.equalTo(idLabel.mas_bottom);
        make.width.mas_equalTo(130);
    }];
    
    
    // ****** 余额 ******
    UIButton *moneyBackBtn = [UIButton new];
//    [moneyBackBtn addTarget:self action:@selector(onMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:moneyBackBtn];
    //    moneyBackBtn.backgroundColor = [UIColor redColor];
    
    [moneyBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImageView.mas_centerY);
        make.right.equalTo(backImageView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    
    
    UIButton *onlineBtn = [[UIButton alloc] init];
    [onlineBtn setTitle:@"离线" forState:UIControlStateNormal];
//    [onlineBtn addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [onlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    onlineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [onlineBtn setImage:[UIImage imageNamed:@"club_online_no"] forState:UIControlStateNormal];
    [onlineBtn setImagePosition:WPGraphicBtnTypeLeft spacing:5];
    onlineBtn.tag = 1000;
    onlineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    onlineBtn.layer.cornerRadius = 20/2;
    onlineBtn.layer.masksToBounds = YES;
    onlineBtn.layer.borderWidth = 1.5;
    onlineBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [backImageView addSubview:onlineBtn];
    _onlineBtn = onlineBtn;
    
    [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.top.equalTo(moneyBackBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont systemFontOfSize:13];
    moneyLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [moneyBackBtn addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.bottom.equalTo(moneyBackBtn.mas_bottom).offset(-2);
    }];
    
}


- (void)setupTableViewHeadUI {
    
    CGFloat fontSize = 15;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.headerContentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerContentView.mas_bottom).offset(-5);
        make.left.equalTo(self.headerContentView.mas_left);
        make.right.equalTo(self.headerContentView.mas_right);
        make.height.mas_equalTo(TableViewHeadTopHeight);
    }];
    
    UILabel *wfLabel = [[UILabel alloc] init];
//        wfLabel.backgroundColor = [UIColor cyanColor];
    wfLabel.text = @"玩法";
    wfLabel.font = [UIFont systemFontOfSize:fontSize];
    wfLabel.textColor = [UIColor redColor];
    wfLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:wfLabel];
    
    [wfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *czLabel = [[UILabel alloc] init];
//        czLabel.backgroundColor = [UIColor yellowColor];
    czLabel.text = @"操作";
    czLabel.font = [UIFont systemFontOfSize:fontSize];
    czLabel.textColor = [UIColor redColor];
    czLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:czLabel];
    
    [czLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wfLabel.mas_right).offset(5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *czjeLabel = [[UILabel alloc] init];
//        czjeLabel.backgroundColor = [UIColor redColor];
    czjeLabel.text = @"操作金额";
    czjeLabel.font = [UIFont systemFontOfSize:fontSize];
    czjeLabel.textColor = [UIColor redColor];
    czjeLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:czjeLabel];
    
    [czjeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(czLabel.mas_right).offset(5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(65);
    }];
    
    UILabel *ylLabel = [[UILabel alloc] init];
//        ylLabel.backgroundColor = [UIColor greenColor];
    ylLabel.text = @"盈利";
    ylLabel.font = [UIFont systemFontOfSize:fontSize];
    ylLabel.textColor = [UIColor redColor];
    ylLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:ylLabel];
    
    [ylLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(czjeLabel.mas_right).offset(5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
//        dateLabel.backgroundColor = [UIColor redColor];
    dateLabel.text = @"时间";
    dateLabel.font = [UIFont systemFontOfSize:fontSize];
    dateLabel.textColor = [UIColor redColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ylLabel.mas_right).offset(5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
}

@end








