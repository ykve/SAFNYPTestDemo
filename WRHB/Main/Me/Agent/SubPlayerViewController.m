//
//  RecommendedViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "SubPlayerViewController.h"
#import "RecommendNet.h"
#import "SubUserCell.h"
#import "ReportForms2ViewController.h"
#import "LCActionSheet.h"
#import "SPAlertController.h"

#import "Sub_Users.h"
#import "UIView+AZGradient.h"  // 渐变色
#import "TFPopup.h"
#import "ClubListView.h"

#define KEY_WINDOW  [UIApplication sharedApplication].keyWindow
#define kHeadViewHeight 168

@interface SubPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RecommendNet *model;
/// 团队人数
@property (nonatomic, strong) UILabel *groupNumLabel;
/// 直属人数
@property (nonatomic, strong) UILabel *zsNumLabel;
@property (nonatomic, strong) UIView *dddView;

@property (nonatomic, strong) UITextField *idTextField;
@property (nonatomic, strong) UIButton *userTypeBtn;
@property (nonatomic, strong) UIButton *levelBtn;


@property(nonatomic,strong) TFPopupParam *param;
@property (assign, nonatomic) CGPoint redPoint;
@property(nonatomic,assign) PopupDirection popupDirection;
/// 高度
@property (nonatomic, assign) CGFloat popListHeight;
/// 数据源
@property (nonatomic, strong) NSArray *popListArray;

/// 用户层级
@property (nonatomic, assign) NSInteger userLevelMark;
/// 全部、代理、普通
@property (nonatomic, assign) NSInteger userTypeMark;

///
@property (nonatomic, strong) NSArray<Sub_Users *> *sub_UsersArray;
///
@property (nonatomic, strong) NSMutableArray<Sub_Users *> *dataSource;


/// 用户账号
@property (nonatomic, assign) NSInteger userId;
/// 1普通用户 2 代理用户
@property (nonatomic, assign) NSInteger type;

@end

@implementation SubPlayerViewController

/// 导航栏透明功能
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#333333"],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下级玩家";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    _userLevelMark = 0;
    _userTypeMark = 0;
    [self setupSubViews];
    [self getData:0];
    
    [self.tableView registerClass:[SubUserCell class] forCellReuseIdentifier:@"SubUserCell.h"];
    
    self.param = [TFPopupParam new];
    self.popupDirection = PopupDirectionBottomLeft;
}


#pragma mark ----- subView
- (void)setupSubViews{
    
    //    self.navigationItem.title = @"我的玩家";
    
    __weak RecommendNet *weakModel = _model;
    
    UIView *headView = [self headView];
    [self.view addSubview:headView];
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    __weak __typeof(self)weakSelf = self;
    
    _tableView.rowHeight = 140;
    //    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    //    _tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData:0];
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(headView.mas_bottom);
    }];
    [MBProgressHUD showActivityMessageInView:nil];
    
}

#pragma mark net
- (void)getData:(NSInteger)page {
    
    //    NSDictionary *userType = @{
    //                               @"type":@(self.type),
    //                               @"user":@(self.userId)
    //                               };
    //    NSDictionary *parameters = @{
    //                                 @"current":@(1),
    //                                 @"pageSize":@(20),
    //                                 @"filters":userType
    //                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"agent/subUsers"];
    entity.needCache = NO;
    //    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            NSArray *array = [Sub_Users mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.sub_UsersArray = [array copy];
            strongSelf.dataSource = [array mutableCopy];
            [strongSelf updateHeadInfo];
            [strongSelf reloadView];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
    
}



- (void)onSearchBtn {
    
    if (self.idTextField.text.length > 0) {
        [self searchIdUser];
        return;
    } else if (self.userLevelMark > 0) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        /// 直属代理人数
        NSInteger zsAgentNum = 0;
        /// 直属人数(玩家)
        NSInteger zswgNum = 0;
        
        for (NSInteger index = 0; index < self.sub_UsersArray.count; index++) {
            Sub_Users *model = self.sub_UsersArray[index];
            
            if (model.level == self.userLevelMark) {
                if (model.is_agent) {
                    zsAgentNum++;
                } else {
                    zswgNum++;
                }
                
                if (self.userTypeMark == 0) {
                    [tempArray addObject:model];
                } else if (self.userTypeMark == 1) {
                    if (model.is_agent) {
                        [tempArray addObject:model];
                    }
                } else if (self.userTypeMark == 2) {
                    if (!model.is_agent) {
                        [tempArray addObject:model];
                    }
                }
            }
            
        }
        
        NSString *textStr = nil;
        if (self.userLevelMark == 1 || self.userLevelMark == 0) {
            textStr = @"直属人数";
        } else if (self.userLevelMark == 2) {
            textStr = @"2级人数";
        } else if (self.userLevelMark == 3) {
            textStr = @"3级人数";
        } else if (self.userLevelMark == 4) {
            textStr = @"4级人数";
        } else if (self.userLevelMark == 5) {
            textStr = @"5级人数";
        } else if (self.userLevelMark == 6) {
            textStr = @"6级人数";
        }
        
        self.zsNumLabel.text = [NSString stringWithFormat:@"%@:%zd", textStr,zsAgentNum+zswgNum];
        
        UIView *view3 = [self.dddView viewWithTag:1702];
        UILabel *label3 = [view3 viewWithTag:2];
        
        UIView *view4 = [self.dddView viewWithTag:1703];
        UILabel *label4 = [view4 viewWithTag:2];
        
        label3.text = [NSString stringWithFormat:@"%zd", zsAgentNum];
        label4.text = [NSString stringWithFormat:@"%zd", zswgNum];
        
        self.dataSource = nil;
        if (tempArray.count > 0) {
             [self.dataSource addObjectsFromArray:tempArray];
        }
        [self reloadView];
    }
    
}

-(void)updateHeadInfo {
    
    /// 代理人数
    NSInteger agentNum = 0;
    /// 玩家人数
    NSInteger wgNum = 0;
    
    /// 直属代理人数
    NSInteger zsAgentNum = 0;
    /// 直属人数(玩家)
    NSInteger zswgNum = 0;
    
    for (NSInteger index = 0; index < self.sub_UsersArray.count; index++) {
        Sub_Users *model = self.sub_UsersArray[index];
        if (model.is_agent) {
            agentNum++;
        } else {
            wgNum++;
        }
        
        if (model.level == 1) {
            if (model.is_agent) {
                zsAgentNum++;
            } else {
                zswgNum++;
            }
        }
    }
    
    self.groupNumLabel.text = [NSString stringWithFormat:@"团队人数:%zd", agentNum+wgNum];
    self.zsNumLabel.text = [NSString stringWithFormat:@"直属人数:%zd", zsAgentNum+zswgNum];
    
    UIView *view1 = [self.dddView viewWithTag:1700];
    UILabel *label1 = [view1 viewWithTag:2];
    
    UIView *view2 = [self.dddView viewWithTag:1701];
    UILabel *label2 = [view2 viewWithTag:2];
    
    UIView *view3 = [self.dddView viewWithTag:1702];
    UILabel *label3 = [view3 viewWithTag:2];
    
    UIView *view4 = [self.dddView viewWithTag:1703];
    UILabel *label4 = [view4 viewWithTag:2];
    
    label1.text = [NSString stringWithFormat:@"%zd", agentNum];
    label2.text = [NSString stringWithFormat:@"%zd", wgNum];
    label3.text = [NSString stringWithFormat:@"%zd", zsAgentNum];
    label4.text = [NSString stringWithFormat:@"%zd", zswgNum];
    
}

/// 搜索ID
- (void)searchIdUser {
    
    Sub_Users *idModel = nil;
    for (NSInteger index = 0; index < self.sub_UsersArray.count; index++) {
        Sub_Users *model = self.sub_UsersArray[index];
        if (model.user_id == [self.idTextField.text integerValue]) {
            idModel = model;
            break;
        }
    }
    
    self.dataSource = nil;
    if (idModel) {
        [self.dataSource addObject:idModel];
    }
    [self reloadView];
}



- (void)reloadView {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    if(_model.IsNetError){
        [_tableView.StateView showNetError];
    }
    else if(_model.isEmpty){
        [_tableView.StateView showEmpty];
    }else{
        [_tableView.StateView hidState];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tableView reloadData];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubUserCell"];
    if(cell == nil) {
        cell = [SubUserCell cellWithTableView:tableView reusableId:@"SubUserCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell.detailButton addTarget:self action:@selector(onDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

-(void)onDetailAction:(UIButton *)btn {
    UITableViewCell *cell = [[FunctionManager sharedInstance] cellForChildView:btn];
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    
    Sub_Users *model = self.dataSource[path.row];
    ReportForms2ViewController *vc = [[ReportForms2ViewController alloc] init];
    vc.sub_User = model;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)searchAction {
    [self.view endEditing:YES];
    [MBProgressHUD showActivityMessageInView:nil];
    [self getData:0];
}

#pragma mark - 用户层级 | 用户类型 选择
-(void)onLevelBtn:(UIButton *)sender {
    
    self.redPoint = CGPointMake(sender.center.x + 47, sender.center.y+15);
    self.popListHeight = 210;
    self.popListArray = @[@"直属",@"2级",@"3级",@"4级",@"5级",@"6级"];
    [self memberIDType];
}
-(void)onUserTypeBtn:(UIButton *)sender {
    self.redPoint = CGPointMake(sender.center.x + 47, sender.center.y+15);
    self.popListHeight = 105;
    self.popListArray = @[@"全部",@"代理用户",@"普通玩家"];
    [self memberIDType];
}


- (void)memberIDType {
    //    self.palyType = 2;
    self.param.popupSize = CGSizeMake(100, self.popListHeight);
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
    ClubListView *list = [[ClubListView alloc] initWithFrame:CGRectMake(0, 0, 100, self.popListHeight)];
    list.cellHeight = 35;
    list.fontSize = 14;
    list.dataSource = [self.popListArray mutableCopy];
    list.textColor = [UIColor redColor];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(list) weakView = list;
    [list observerSelected:^(NSString *data) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([data isEqualToString:@"直属"]) {
            strongSelf.userLevelMark = 1;
            [strongSelf.levelBtn setTitle:@"直属" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"2级"]) {
            strongSelf.userLevelMark = 2;
            [strongSelf.levelBtn setTitle:@"2级" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"3级"]) {
            strongSelf.userLevelMark = 3;
            [strongSelf.levelBtn setTitle:@"3级" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"4级"]) {
            strongSelf.userLevelMark = 4;
            [strongSelf.levelBtn setTitle:@"4级" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"5级"]) {
            strongSelf.userLevelMark = 5;
            [strongSelf.levelBtn setTitle:@"5级" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"6级"]) {
            strongSelf.userLevelMark = 6;
            [strongSelf.levelBtn setTitle:@"6级" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"全部"]) {
            strongSelf.userTypeMark = 0;
            [strongSelf.userTypeBtn setTitle:@"全部" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"代理用户"]) {
            strongSelf.userTypeMark = 1;
            [strongSelf.userTypeBtn setTitle:@"代理用户" forState:UIControlStateNormal];
        } else if ([data isEqualToString:@"普通玩家"]) {
            strongSelf.userTypeMark = 2;
            [strongSelf.userTypeBtn setTitle:@"普通玩家" forState:UIControlStateNormal];
        } else {
            NSLog(@"未知类型");
        }
        
        [strongSelf onSearchBtn];
        [weakView tf_hide];
    }];
    return list;
}









-(UIView *)headView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 310)];
    backView.backgroundColor = [UIColor clearColor];
    
    UIImage *img = [UIImage imageNamed:@"sub_top_bg"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:img];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.frame = backView.bounds;
    [backView addSubview:bgImgView];
    
    /// ****** 团队人数 ******
    UILabel *groupNumLabel = [[UILabel alloc] init];
    groupNumLabel.textAlignment = NSTextAlignmentCenter;
    groupNumLabel.font = [UIFont boldSystemFontOfSize2:22];
    groupNumLabel.textColor = [UIColor whiteColor];
    [bgImgView addSubview:groupNumLabel];
    [groupNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_top).offset(Height_NavBar + 15);
        make.left.equalTo(bgImgView);
        make.right.equalTo(bgImgView.mas_centerX);
        make.height.equalTo(@35);
    }];
    groupNumLabel.text = @"团队人数:0";
    self.groupNumLabel = groupNumLabel;
    
    
    /// ****** 直属人数 ******
    UILabel *zsNumLabel = [[UILabel alloc] init];
    zsNumLabel.textAlignment = NSTextAlignmentCenter;
    zsNumLabel.font = [UIFont boldSystemFontOfSize2:22];
    zsNumLabel.textColor = [UIColor whiteColor];
    [bgImgView addSubview:zsNumLabel];
    [zsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_top).offset(Height_NavBar + 15);
        make.left.equalTo(bgImgView.mas_centerX).offset(20);
        make.right.equalTo(bgImgView);
        make.height.equalTo(@35);
    }];
    zsNumLabel.text = @"直属人数:0";
    self.zsNumLabel = zsNumLabel;
    
    
    /// ****** 用户ID ******
    
    UIButton *btn1 = [UIButton new];
    [bgImgView addSubview:btn1];
    btn1.titleLabel.font = [UIFont systemFontOfSize2:12];
    [btn1 setTitle:@"搜索" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 3;
    [btn1 addTarget:self action:@selector(onSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn1 az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF4444"],[UIColor colorWithHex:@"#FF8484"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImgView).offset(-15);
        make.bottom.equalTo(bgImgView.mas_bottom).offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@95);
    }];
    
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.font = [UIFont systemFontOfSize2:15];
    idLabel.textColor = [UIColor colorWithHex:@"#333333"];
    idLabel.text = @"用户ID:";
    [bgImgView addSubview:idLabel];
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImgView.mas_left).offset(15);
        make.centerY.equalTo(btn1.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
    UITextField *idTextField = [[UITextField alloc] init];
    idTextField.textColor = Color_0;
    idTextField.font = [UIFont systemFontOfSize2:15];
    //    idTextField.backgroundColor = [UIColor whiteColor];
    idTextField.layer.masksToBounds = YES;
    idTextField.layer.cornerRadius = 5;
    idTextField.borderStyle = UITextBorderStyleRoundedRect;  //边框类型
    idTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    idTextField.leftViewMode = UITextFieldViewModeAlways;
    [bgImgView addSubview:idTextField];;
    [idTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1.mas_centerY);
        make.left.equalTo(idLabel.mas_right).offset(5);
        make.right.equalTo(btn1.mas_left).offset(-10);
        make.height.equalTo(@30);
    }];
    self.idTextField = idTextField;
    
    
    
    
    /// ****** 用户层级 ******
    UIButton *userTypeBtn = [[UIButton alloc] init];
    [userTypeBtn addTarget:self action:@selector(onUserTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    userTypeBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [userTypeBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    userTypeBtn.backgroundColor = [UIColor whiteColor];
    userTypeBtn.layer.masksToBounds = YES;
    userTypeBtn.layer.cornerRadius = 5;
    userTypeBtn.layer.borderWidth = 1;
    userTypeBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [bgImgView addSubview:userTypeBtn];;
    [userTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(btn1.mas_top).offset(-10);
        make.left.equalTo(btn1.mas_left);
        make.right.equalTo(btn1.mas_right);
        make.height.equalTo(@30);
    }];
    self.userTypeBtn = userTypeBtn;
    
    UIImageView *iocn1View = [[UIImageView alloc] init];
    iocn1View.image = [UIImage imageNamed:@"sub_down_jt"];
    [userTypeBtn addSubview:iocn1View];
    
    [iocn1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userTypeBtn.mas_right).offset(-5);;
        make.centerY.equalTo(userTypeBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 9));
    }];
    
    UILabel *typeTitLabel = [[UILabel alloc] init];
    typeTitLabel.textAlignment = NSTextAlignmentRight;
    typeTitLabel.font = [UIFont systemFontOfSize2:15];
    typeTitLabel.textColor = [UIColor colorWithHex:@"#333333"];
    typeTitLabel.text = @"用户类型:";
    [bgImgView addSubview:typeTitLabel];
    [typeTitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(userTypeBtn.mas_left).offset(-5);
        make.centerY.equalTo(userTypeBtn.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *t1Label = [[UILabel alloc] init];
    t1Label.font = [UIFont systemFontOfSize2:15];
    t1Label.textColor = [UIColor colorWithHex:@"#333333"];
    t1Label.text = @"用户层级:";
    [bgImgView addSubview:t1Label];
    [t1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(idLabel.mas_left);
        make.centerY.equalTo(userTypeBtn.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
    
    UIButton *levelBtn = [[UIButton alloc] init];
    [levelBtn addTarget:self action:@selector(onLevelBtn:) forControlEvents:UIControlEventTouchUpInside];
    levelBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
//    levelBtn.backgroundColor = [UIColor colorWithHex:@"#333333"];
    [levelBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    levelBtn.layer.masksToBounds = YES;
    levelBtn.layer.cornerRadius = 5;
    levelBtn.layer.borderWidth = 1;
    levelBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [bgImgView addSubview:levelBtn];;
    [levelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(t1Label.mas_right).offset(5);
        make.centerY.equalTo(userTypeBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(95, 30));
    }];
    self.levelBtn = levelBtn;
    
    UIImageView *iocn2View = [[UIImageView alloc] init];
    iocn2View.image = [UIImage imageNamed:@"sub_down_jt"];
    [levelBtn addSubview:iocn2View];
    
    [iocn2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(levelBtn.mas_right).offset(-5);
        make.centerY.equalTo(levelBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 9));
    }];
    
    
    UIView *dddView = [[UIView alloc] init];
    //    dddView.backgroundColor = [UIColor greenColor];
    [bgImgView addSubview:dddView];
    _dddView = dddView;
    
    [dddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_top).offset(130);
        make.left.equalTo(bgImgView.mas_left).offset(10);
        make.right.equalTo(bgImgView.mas_right).offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    
    CGFloat viewHeight = 40;
    /// 代理人数
    UIView *view1 = [self viewForNum:@"0" title:@"代理人数"];
    [dddView addSubview:view1];
    view1.tag = 1700;
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dddView.mas_left);
        make.width.equalTo(dddView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(viewHeight);
        make.centerY.equalTo(dddView);
    }];
    
    /// 玩家人数
    UIView *view2 = [self viewForNum:@"0" title:@"玩家人数"];
    [dddView addSubview:view2];
    view2.tag = 1701;
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.width.equalTo(dddView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(viewHeight);
        make.centerY.equalTo(dddView);
    }];
    
    /// 直属代理
    UIView *view3 = [self viewForNum:@"0" title:@"直属代理"];
    [dddView addSubview:view3];
    view3.tag = 1702;
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_right);
        make.width.equalTo(dddView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(viewHeight);
        make.centerY.equalTo(dddView);
    }];
    
    /// 直属人数
    UIView *view4 = [self viewForNum:@"0" title:@"直属人数"];
    [dddView addSubview:view4];
    view4.tag = 1703;
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view3.mas_right);
        make.width.equalTo(dddView.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(viewHeight);
        make.centerY.equalTo(dddView);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor whiteColor];
    [bgImgView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_top).offset(Height_NavBar);
        make.left.right.equalTo(bgImgView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor whiteColor];
    [bgImgView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImgView.mas_centerX);
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(0.5, 95));
    }];
    
    return backView;
}


-(UIView *)viewForNum:(NSString *)num title:(NSString *)title{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(-10);
    }];
    titleLabel.text = num;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 3;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(10);
    }];
    titleLabel.text = title;
    
    return view;
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
