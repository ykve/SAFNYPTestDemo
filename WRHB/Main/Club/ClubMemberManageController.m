//
//  ClubMemberManageController.m
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberManageController.h"
#import "ClubManager.h"
#import "ClubMemberModel.h"
#import "ClubMemberCell.h"
#import "TFPopup.h"
#import "ClubListView.h"
#import "ClubInitiator.h"
#import "ClubApplicationListCell.h"
#import "ClubMemberDetailsController.h"

static CGFloat const BottomViewHeight = 40 + 45;

@interface ClubMemberManageController ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;
///
@property (nonatomic, strong) ClubMemberModel *selectedMemberModel;

@property(nonatomic,strong) TFPopupParam *param;
@property (assign, nonatomic) CGPoint redPoint;
@property(nonatomic,assign) PopupDirection popupDirection;



/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
///
@property (nonatomic, assign) BOOL isExpand;
/// 表单
@property (nonatomic, strong) UITableView *bottomTableView;
/// 数据源
@property (nonatomic, strong) NSArray *bottomDataArray;

@end

@implementation ClubMemberManageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationJoinClubNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"成员管理";
    
    self.isExpand = NO;
    
    [self setupUI];
    [self setBottomView];
    [self.view addSubview:self.tableView];
    [self getClubMember];
    [self getApplicationList];
    
    [self.tableView registerClass:[ClubMemberCell class] forCellReuseIdentifier:@"ClubMemberCell"];
    [self.tableView registerClass:[ClubApplicationListCell class] forCellReuseIdentifier:@"ClubApplicationListCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClubMember];
        [weakSelf getApplicationList];
    }];
    
    self.param = [TFPopupParam new];
    //    self.redPoint.layer.cornerRadius = 5;
    self.popupDirection = PopupDirectionBottomLeft;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSetBadgeValue:)name:kApplicationJoinClubNotification object:nil];
}

/**
 设置角标
 */
- (void)updateSetBadgeValue:(NSNotification *)notification {
    
    __weak __typeof(self)weakSelf = self;
    /*! 回到主线程刷新UI */
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getClubMember];
        [strongSelf getApplicationList];
    });
}


- (void)onBottomTableViewAnimation {
    
    //告知需要更改约束
    [self.view setNeedsUpdateConstraints];
    
    if (!self.isExpand) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(200);
            }];
            
            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.bottomView.superview layoutIfNeeded];
        }];
        // 视图显示到最前面 最上层
        [self.view bringSubviewToFront:self.bottomView];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(BottomViewHeight);
            }];
            //告知父类控件绘制，不添加注释的这两行的代码无法生效
            [self.bottomView.superview layoutIfNeeded];
        }];
    }
    
    self.isExpand = !self.isExpand;
    
    
}


#pragma mark -  俱乐部成员
- (void)getClubMember {
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/members"];
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
            NSArray *modelArray = [ClubMemberModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [modelArray copy];
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
#pragma mark -  等待加入俱乐部的申请
- (void)getApplicationList {
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/join/request"];
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
            NSArray *modelArray = [ClubInitiator mj_objectArrayWithKeyValuesArray:response[@"data"][@"lists"]];
            if (modelArray.count == 0) {
                [AppModel sharedInstance].appltJoinClubNum = 0;
            }
            strongSelf.bottomDataArray = [modelArray copy];
            [strongSelf.bottomTableView reloadData];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar+60, kSCREEN_WIDTH, kSCREEN_HEIGHT- Height_NavBar-60-BottomViewHeight) style:UITableViewStylePlain];
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

#pragma mark - vvUITableView
- (UITableView *)bottomTableView {
    if (!_bottomTableView) {
        _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40,kSCREEN_WIDTH, 200 - 40) style:UITableViewStylePlain];
        _bottomTableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _bottomTableView.dataSource = self;
        _bottomTableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _bottomTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        //        _tableView.rowHeight = 44;   // 行高
        _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _bottomTableView.estimatedRowHeight = 0;
        _bottomTableView.estimatedSectionHeaderHeight = 0;
        _bottomTableView.estimatedSectionFooterHeight = 0;
    }
    return _bottomTableView;
}

#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return self.dataArray.count;
    } else {
        return self.bottomDataArray.count;
    }
    
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        ClubMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubMemberCell"];
        if(cell == nil) {
            cell = [ClubMemberCell cellWithTableView:tableView reusableId:@"ClubMemberCell"];
        }
        ClubMemberModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        
        __weak __typeof(self)weakSelf = self;
        cell.memberOperationTypeBlock = ^(ClubMemberModel *model, id cell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.selectedMemberModel = model;
            ClubMemberCell *viewCell = (ClubMemberCell *)cell;
            UIWindow * window= [[[UIApplication sharedApplication] delegate] window];
            CGRect rect= [viewCell.operationTypeBtn convertRect: viewCell.operationTypeBtn.bounds toView:window];
            CGPoint point = rect.origin;
            strongSelf.redPoint = CGPointMake(point.x + 20, point.y + 25);
            [strongSelf memberOperationType];
        };
        

        cell.memberIDTypeBlock = ^(ClubMemberModel *model, id cell) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.selectedMemberModel = model;
            ClubMemberCell *viewCell = (ClubMemberCell *)cell;
            UIWindow * window= [[[UIApplication sharedApplication] delegate] window];
            CGRect rect= [viewCell.IDTypeBtn convertRect: viewCell.IDTypeBtn.bounds toView:window];
            CGPoint point = rect.origin;
            strongSelf.redPoint = CGPointMake(point.x + 65, point.y + 25);
            [strongSelf memberIDType];
        };

        return cell;
        
    } else {
        ClubApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubApplicationListCell"];
        if(cell == nil) {
            cell = [ClubApplicationListCell cellWithTableView:tableView reusableId:@"ClubApplicationListCell"];
        }
        ClubInitiator *model = self.bottomDataArray[indexPath.row];
        cell.model = model;
        
        __weak __typeof(self)weakSelf = self;
        cell.memberPassBlock = ^(ClubInitiator *model) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf memberApplication:model isPass:YES];
        };
        cell.memberRejectBlock = ^(ClubInitiator *model) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf memberApplication:model isPass:NO];
        };
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return 55;
    } else {
        return 45;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        ClubMemberModel *model = self.dataArray[indexPath.row];
        ClubMemberDetailsController *vc = [[ClubMemberDetailsController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ClubInitiator *model = self.bottomDataArray[indexPath.row];
    }
}


#pragma mark -  设置 禁言 不禁言、 成员、管理员
- (void)memberOperationType {
//    self.palyType = 2;
    
    self.param.popupSize = CGSizeMake(100, 100);
    //        self.param.duration = 2;
    UIView *popup = [self getListView];
    popup.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
    popup.layer.borderWidth = 1;
    [popup tf_showBubble:self.view
               basePoint:self.redPoint
         bubbleDirection:self.popupDirection
              popupParam:self.param];
}

-(UIView *)getListView {
    ClubListView *list = [[ClubListView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    NSString *tit = self.selectedMemberModel.can_speak == 1 ? @"禁言" : @"不禁言";

    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:tit,@"踢出", nil];
    list.dataSource = dataArray;
    list.textColor = [UIColor redColor];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(list) weakView = list;
    [list observerSelected:^(NSString *data) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        weakSelf.palyTypeLabel.text = data;
        
        if ([data isEqualToString:@"禁言"]) {
            strongSelf.selectedMemberModel.can_speak = 2;
        } else if ([data isEqualToString:@"不禁言"]) {
            strongSelf.selectedMemberModel.can_speak = 1;
        } else if ([data isEqualToString:@"踢出"]) {
            strongSelf.selectedMemberModel.kicking = 1;
        }
        
        [strongSelf updateMember];
        [weakView tf_hide];
    }];
    return list;
}
- (void)memberIDType {
    //    self.palyType = 2;
    self.param.popupSize = CGSizeMake(100, 100);
    //        self.param.duration = 2;
    UIView *popup = [self getListIDTypeView];
    popup.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
    popup.layer.borderWidth = 1;
    [popup tf_showBubble:self.view
               basePoint:self.redPoint
         bubbleDirection:self.popupDirection
              popupParam:self.param];
}

-(UIView *)getListIDTypeView {
    ClubListView *list = [[ClubListView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"成员",@"管理员", nil];
    list.dataSource = dataArray;
    list.textColor = [UIColor redColor];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(list) weakView = list;
    [list observerSelected:^(NSString *data) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([data isEqualToString:@"成员"]) {
            strongSelf.selectedMemberModel.role = 1;
        } else if ([data isEqualToString:@"管理员"]) {
            strongSelf.selectedMemberModel.role = 2;
        }
        
                [strongSelf updateMember];
        [weakView tf_hide];
    }];
    return list;
}

#pragma mark -  拒绝 | 通过
- (void)memberApplication:(ClubInitiator *)model isPass:(BOOL)isPass {
    
    NSDictionary *parameters = @{
                                 @"user":@(model.user_id),
                                  @"club":@([ClubManager sharedInstance].clubModel.club_id),
                                 };
    BADataEntity *entity = [BADataEntity new];
    if (isPass) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/join/approval"]; // 通过
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/join/refuse"];  // 拒绝
    }
    
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [AppModel sharedInstance].appltJoinClubNum = [AppModel sharedInstance].appltJoinClubNum -1;
            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            // 可以延时调用方法
            [strongSelf performSelector:@selector(listRloadView) withObject:nil afterDelay:1.5];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)listRloadView {
    [self getClubMember];
    [self getApplicationList];
}

#pragma mark -  修改成员信息
- (void)updateMember {
    
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID),  // 俱乐部ID
                                 @"user":@(self.selectedMemberModel.ID),  // 用户ID
                                 @"role":@(self.selectedMemberModel.role),  // 创建房间方式 1 全员 2 管理者
                                 @"can_speak":@(self.selectedMemberModel.can_speak), // 是否禁言 1 不禁言 2 禁言
                                 @"kicking":@(self.selectedMemberModel.kicking)  // 踢人 1 踢
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/members/modify"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInView:response[@"message"]];
            // 可以延时调用方法
            [strongSelf performSelector:@selector(getClubMember) withObject:nil afterDelay:1.5];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}



- (void)setBottomView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:backView];
    _bottomView = backView;
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneX_Bottom_Height);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(BottomViewHeight);
    }];
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBottomTableViewAnimation)];
    //将手势添加到需要相应的view中去
    [backView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHex:@"#FB7568"];
    [backView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top);
        make.left.right.equalTo(backView);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"申请列表";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor  whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"club_expand"];
    [topView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).offset(-20);;
        make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
    }];
    
    
    
    [backView addSubview:self.bottomTableView];
}

- (void)setupUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar+5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *czLabel = [[UILabel alloc] init];
    //    czLabel.backgroundColor = [UIColor cyanColor];
    czLabel.text = @"操作";
    czLabel.font = [UIFont systemFontOfSize:15];
    czLabel.textColor = [UIColor redColor];
    czLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:czLabel];
    
    [czLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(35);
    }];
    
    UILabel *sfLabel = [[UILabel alloc] init];
    //    sfLabel.backgroundColor = [UIColor yellowColor];
    sfLabel.text = @"身份";
    sfLabel.font = [UIFont systemFontOfSize:15];
    sfLabel.textColor = [UIColor redColor];
    sfLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:sfLabel];
    
    [sfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(czLabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    UILabel *lsLabel = [[UILabel alloc] init];
    //    lsLabel.backgroundColor = [UIColor redColor];
    lsLabel.text = @"流水";
    lsLabel.font = [UIFont systemFontOfSize:15];
    lsLabel.textColor = [UIColor redColor];
    lsLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:lsLabel];
    
    [lsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sfLabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *yuELabel = [[UILabel alloc] init];
    //    yuELabel.backgroundColor = [UIColor greenColor];
    yuELabel.text = @"余额";
    yuELabel.font = [UIFont systemFontOfSize:15];
    yuELabel.textColor = [UIColor redColor];
    yuELabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:yuELabel];
    
    [yuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lsLabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    UILabel *idELabel = [[UILabel alloc] init];
    //    idELabel.backgroundColor = [UIColor redColor];
    idELabel.text = @"ID";
    idELabel.font = [UIFont systemFontOfSize:15];
    idELabel.textColor = [UIColor redColor];
    idELabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:idELabel];
    
    [idELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yuELabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    //    nameLabel.backgroundColor = [UIColor grayColor];
    nameLabel.text = @"昵称";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor redColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(idELabel.mas_left).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left);
    }];
}

- (NSArray *)bottomDataArray {
    if (!_bottomDataArray) {
        _bottomDataArray = [NSArray array];
    }
    return _bottomDataArray;
}
@end







