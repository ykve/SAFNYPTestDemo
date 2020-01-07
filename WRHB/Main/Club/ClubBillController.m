//
//  ClubBillController.m
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubBillController.h"
#import "ClubManager.h"
#import "ClubBillModel.h"
#import "ClubBillCell.h"
#import "UIButton+Layout.h"
#import "CDAlertViewController.h"
#import "NSDate+DaboExtension.h"

static CGFloat const BottomViewHeight = 50;

@interface ClubBillController ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;
/// 选择日期
@property (nonatomic, strong) UIButton *dateBtn;

///
@property (nonatomic, strong) ClubBillModel *selectedMemberModel;
/// 底部视图
@property (nonatomic, strong) UIView *bottomView;
/// 返佣总数
@property (nonatomic, strong) UILabel *lsTotalLabel;
/// 流水总数
@property (nonatomic, strong) UILabel *fyTotalLabel;
@property (nonatomic, strong) NSString *beginTime;

@end

@implementation ClubBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"俱乐部账单";
    
    _beginTime = dateString_date([NSDate date], CDDateDay);
    
    [self setupUI];
    [self setBottomView];
    [self.view addSubview:self.tableView];
    [self getClubBill];
    
    [self.tableView registerClass:[ClubBillCell class] forCellReuseIdentifier:@"ClubBillCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClubBill];
    }];
    
}

#pragma mark -  俱乐部 账单
- (void)getClubBill {
    
    
    NSTimeInterval bengin = [NSDate getTimeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00", self.beginTime] DataFormatterString:@"yyyy-MM-dd HH:mm"]/1000;
    
    NSDictionary *parameters = @{
                                @"club":@([ClubManager sharedInstance].clubInfo.ID),
                                 @"date":@(bengin)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/report"];
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
            NSArray *modelArray = [ClubBillModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [modelArray copy];
            [strongSelf setBottomTotal];
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

- (void)setBottomTotal {
    
    CGFloat fytotal = 0;
    CGFloat lstotal = 0;
    
    for (ClubBillModel *model in self.dataArray) {
        fytotal = fytotal + [model.commission floatValue];
        lstotal = lstotal + [model.capital floatValue];
    }
    
    self.fyTotalLabel.text = [NSString stringWithFormat:@"%.2f", fytotal];
    self.lsTotalLabel.text = [NSString stringWithFormat:@"%.2f", lstotal];
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



#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClubBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubBillCell"];
    if(cell == nil) {
        cell = [ClubBillCell cellWithTableView:tableView reusableId:@"ClubBillCell"];
    }
    ClubBillModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    __weak __typeof(self)weakSelf = self;
//    cell.memberOperationTypeBlock = ^(ClubBillModel *model, id cell) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        strongSelf.selectedMemberModel = model;
//        ClubBillCell *viewCell = (ClubBillCell *)cell;
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
    ClubBillModel *model = self.dataArray[indexPath.row];
    
}


- (void)onDateBtn:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateTypeDate:date];
    }];
}

- (void)updateTypeDate:(NSString *)date{
    if([self.beginTime isEqualToString:date]) {
        return;
    }
    self.beginTime = date;
    [self getClubBill];
}


- (void)setupUI {
    
    CGFloat fontSize = 14;
    CGFloat swidht = 8;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar+5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *dateBtn = [[UIButton alloc] init];
    //    IDTypeBtn.backgroundColor = [UIColor greenColor];
        [dateBtn setTitle:@"日期" forState:UIControlStateNormal];
    //     [IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
    [dateBtn addTarget:self action:@selector(onDateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [dateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    dateBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [dateBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
    dateBtn.titleRect = CGRectMake(0, 0, 50, 20);
    dateBtn.imageRect = CGRectMake(55, 8, 13, 6);
    
    //    [IDTypeBtn setImagePosition:WPGraphicBtnTypeRight spacing:10];
    dateBtn.tag = 1001;
    dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview:dateBtn];
    _dateBtn = dateBtn;
    
    UILabel *wjNumLabel = [[UILabel alloc] init];
//    wjNumLabel.backgroundColor = [UIColor cyanColor];
    wjNumLabel.text = @"上线玩家";
    wjNumLabel.font = [UIFont systemFontOfSize:15];
    wjNumLabel.textColor = [UIColor redColor];
    wjNumLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:wjNumLabel];
    
    UILabel *lsLabel = [[UILabel alloc] init];
//    lsLabel.backgroundColor = [UIColor yellowColor];
    lsLabel.text = @"游戏流水";
    lsLabel.font = [UIFont systemFontOfSize:15];
    lsLabel.textColor = [UIColor redColor];
    lsLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:lsLabel];
    
    UILabel *fyLabel = [[UILabel alloc] init];
//    fyLabel.backgroundColor = [UIColor redColor];
    fyLabel.text = @"返佣";
    fyLabel.font = [UIFont systemFontOfSize:15];
    fyLabel.textColor = [UIColor redColor];
    fyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:fyLabel];
    
    [dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(15);
        make.width.equalTo(wjNumLabel);
    }];
    
    [wjNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateBtn.mas_right).offset(swidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(lsLabel);
    }];
    
    [lsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wjNumLabel.mas_right).offset(swidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(fyLabel);
    }];
    
    [fyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lsLabel.mas_right).offset(swidht);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(dateBtn);
    }];
    
}

- (void)setBottomView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    _bottomView = backView;
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(BottomViewHeight);
    }];
    
//    //添加手势事件
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBottomTableViewAnimation)];
//    //将手势添加到需要相应的view中去
//    [backView addGestureRecognizer:tapGesture];
//    //选择触发事件的方式（默认单机触发）
//    [tapGesture setNumberOfTapsRequired:1];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"累计";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(15);
    }];
    
    UILabel *lsTotalLabel = [[UILabel alloc] init];
    lsTotalLabel.text = @"9999.99";
    lsTotalLabel.font = [UIFont systemFontOfSize:15];
    lsTotalLabel.textColor = [UIColor colorWithHex:@"#333333"];
    lsTotalLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:lsTotalLabel];
    _lsTotalLabel = lsTotalLabel;
    
    [lsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_centerX).offset(20);
    }];
    
    UILabel *fyTotalLabel = [[UILabel alloc] init];
    fyTotalLabel.text = @"9999.99";
    fyTotalLabel.font = [UIFont systemFontOfSize:15];
    fyTotalLabel.textColor = [UIColor colorWithHex:@"#333333"];
    fyTotalLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:fyTotalLabel];
    _fyTotalLabel = fyTotalLabel;
    
    [fyTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-15);
    }];
}

@end








