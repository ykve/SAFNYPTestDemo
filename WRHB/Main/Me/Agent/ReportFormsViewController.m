//
//  ReportFormsViewController.m
//  Project
//
//  Created AFan on 2019/9/9.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ReportFormsViewController.h"
#import "ReportHeaderView.h"
#import "MyDesReportTableView.h"
#import "CDAlertViewController.h"
#import "SelectTimeView.h"
#import "NSDate+DaboExtension.h"
#import "TeamReportModel.h"
#import "UIView+AZGradient.h"   // 渐变色

#import "Group_Capital.h"
#import "Group_Activity.h"
#import "Group_Assets.h"
#import "Group_Level.h"
#import "Group_LevelModel.h"


@interface ReportFormsViewController ()

@property (nonatomic, strong) ReportHeaderView *headerView;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;

/// 全部
@property (nonatomic, strong) UIButton *timeAll;
/// 今天
@property (nonatomic, strong) UIButton *todayBtn;
/// 本周
@property (nonatomic, strong) UIButton *weekBtn;
/// 本月
@property (nonatomic, strong) UIButton *monthBtn;

@property (nonatomic, strong) MyDesReportTableView *mdrTView1;
@property (nonatomic, strong) MyDesReportTableView *mdrTView2;
@property (nonatomic, strong) MyDesReportTableView *mdrTView3;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel1;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel2;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel3;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel4;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel5;
@property (nonatomic, strong) MyDesReportTableView *mdrTViewLevel6;

@property (nonatomic, strong) TeamReportModel *reportModel;

@end

@implementation ReportFormsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团队报表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.beginTime = dateString_date([NSDate date], CDDateDay);
    self.endTime = dateString_date([NSDate date], CDDateDay);
    
    [self getData];
    
    [self setNavUI];
    
    [self setDateView];
    [self setSelectTimeView];
    
    [self setScrollView];
    [self setContentView];
    
    
    [self requestDataBack];
}

/// 选择时间
- (void)onSelectTimeBtn:(UIButton *)sender {
    
    self.timeAll.layer.borderWidth = 1;
    self.timeAll.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [self.timeAll setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [self.timeAll az_setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor whiteColor]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    self.todayBtn.layer.borderWidth = 1;
    self.todayBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [self.todayBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [self.todayBtn az_setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor whiteColor]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    self.weekBtn.layer.borderWidth = 1;
    self.weekBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [self.weekBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [self.weekBtn az_setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor whiteColor]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    self.monthBtn.layer.borderWidth = 1;
    self.monthBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [self.monthBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    [self.monthBtn az_setGradientBackgroundWithColors:@[[UIColor whiteColor],[UIColor whiteColor]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    
    [sender az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF6B7C"],[UIColor colorWithHex:@"#FFA2A8"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        if(sender.tag == 5000) {
            self.beginTime = nil;
            self.endTime = dateString_date([NSDate date], CDDateDay);
            
        } else if (sender.tag == 5001) {
            self.beginTime = dateString_date([NSDate date], CDDateDay);
            self.endTime = dateString_date([NSDate date], CDDateDay);
        } else if(sender.tag == 5002){
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
            // 获取今天是周几
            NSInteger weekDay = [comp weekday];
            weekDay -= 1;
            if(weekDay < 1)
                weekDay = 7;
            self.beginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1) * 24 * 3600)], CDDateDay);
            self.endTime = dateString_date([NSDate date], CDDateDay);
        } else if(sender.tag == 5003){
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
            NSInteger year = [comp year];
            NSInteger month = [comp month];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [formatter setTimeZone:timeZone];
            [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
            
            NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
            self.beginTime = dateString_date([formatter dateFromString:timeStrb], CDDateDay);
            
            //        month += 1;
            //        if(month > 12){
            //            month = 1;
            //            year += 1;
            //        }
            //        NSString *timeStre = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
            //        NSDate *dd = [[formatter dateFromString:timeStre] dateByAddingTimeInterval:-24 * 3600];
            self.endTime = dateString_date([NSDate date], CDDateDay);
        }

    self.headerView.beginTime = self.beginTime;
    self.headerView.endTime = self.endTime;
    
    [self getData];
}

- (void)setSelectTimeView {
    
    UIView *timeSelectBgView = [[UIView alloc] init];
    timeSelectBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timeSelectBgView];
    
    [timeSelectBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(336, 48));
    }];
    
    _timeAll = [[UIButton alloc] init];
    [timeSelectBgView addSubview:_timeAll];
    _timeAll.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_timeAll setTitle:@"全部" forState:UIControlStateNormal];
    [_timeAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _timeAll.layer.masksToBounds = YES;
    _timeAll.layer.cornerRadius = 30/2;
    [_timeAll addTarget:self action:@selector(onSelectTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_timeAll az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF6B7C"],[UIColor colorWithHex:@"#FFA2A8"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    _timeAll.tag = 5000;
    [_timeAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeSelectBgView.mas_left);
        make.centerY.equalTo(timeSelectBgView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];
    
    _todayBtn = [[UIButton alloc] init];
    [timeSelectBgView addSubview:_todayBtn];
    _todayBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_todayBtn setTitle:@"今天" forState:UIControlStateNormal];
    [_todayBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    _todayBtn.layer.masksToBounds = YES;
    _todayBtn.layer.cornerRadius = 30/2;
    _todayBtn.layer.borderWidth = 1;
    _todayBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [_todayBtn setBackgroundColor:[UIColor whiteColor]];
    [_todayBtn addTarget:self action:@selector(onSelectTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _todayBtn.tag = 5001;
    [_todayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_timeAll.mas_right).offset(12);
        make.centerY.equalTo(timeSelectBgView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];
    
    _weekBtn = [[UIButton alloc] init];
    [timeSelectBgView addSubview:_weekBtn];
    _weekBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_weekBtn setTitle:@"本周" forState:UIControlStateNormal];
    [_weekBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    _weekBtn.layer.masksToBounds = YES;
    _weekBtn.layer.cornerRadius = 30/2;
    _weekBtn.layer.borderWidth = 1;
    _weekBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [_weekBtn setBackgroundColor:[UIColor whiteColor]];
    [_weekBtn addTarget:self action:@selector(onSelectTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _weekBtn.tag = 5002;
    [_weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_todayBtn.mas_right).offset(12);
        make.centerY.equalTo(timeSelectBgView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];
    
    _monthBtn = [[UIButton alloc] init];
    [timeSelectBgView addSubview:_monthBtn];
    _monthBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_monthBtn setTitle:@"本月" forState:UIControlStateNormal];
    [_monthBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
    _monthBtn.layer.masksToBounds = YES;
    _monthBtn.layer.cornerRadius = 30/2;
    _monthBtn.layer.borderWidth = 1;
    _monthBtn.layer.borderColor = [UIColor colorWithHex:@"#999999"].CGColor;
    [_monthBtn setBackgroundColor:[UIColor whiteColor]];
    [_monthBtn addTarget:self action:@selector(onSelectTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _monthBtn.tag = 5003;
    [_monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_weekBtn.mas_right).offset(12);
        make.centerY.equalTo(timeSelectBgView.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@75);
    }];
}

-(void)getData {
    
    
    NSTimeInterval bengin = [NSDate getTimeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00", self.beginTime] DataFormatterString:@"yyyy-MM-dd HH:mm"]/1000;
    NSTimeInterval endtime = [NSDate getTimeIntervalWithDateString:[NSString stringWithFormat:@"%@ 23:59", self.endTime] DataFormatterString:@"yyyy-MM-dd HH:mm"]/1000;
    
    NSDictionary *parameters = @{
                                 //                                 @"type":@(1),
                                 @"begin":@(bengin),
                                 @"end":@(endtime)
                                 };
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"agent/report"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            TeamReportModel *model = [TeamReportModel mj_objectWithKeyValues:response[@"data"][@"report"]];
            strongSelf.reportModel = model;
            [strongSelf requestDataBack];
        } else {
            [strongSelf requestDataBack];
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)requestDataBack {
    [self tdbbData1];
    [self tdbbData2];
    [self tdbbData3];
    [self tdbbDataLevel1];
    [self tdbbDataLevel2];
    [self tdbbDataLevel3];
    [self tdbbDataLevel4];
    [self tdbbDataLevel5];
    [self tdbbDataLevel6];
}

- (void)setContentView {
    CGFloat ssHeight = 20;
    CGFloat tdbbViewHeight = 320;
    CGFloat tdbbViewLevelHeight = 445;
    
    //    MyDesReportTableView *zijinBaobiaoView = [[MyDesReportTableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, self.view.frame.size.width, 202.5)];
    MyDesReportTableView *mdrTView1 = [[MyDesReportTableView alloc] init];
//    mdrTView1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:mdrTView1];
    _mdrTView1 = mdrTView1;
    
    [mdrTView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewHeight);
    }];
    
    MyDesReportTableView *mdrTView2 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTView2];
    _mdrTView2 = mdrTView2;

    [mdrTView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTView1.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewHeight);
    }];

    MyDesReportTableView *mdrTView3 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTView3];
    _mdrTView3 = mdrTView3;

    [mdrTView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTView2.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewHeight);
    }];




    /// ********* Level1 *********
    MyDesReportTableView *mdrTViewLevel1 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel1];
    _mdrTViewLevel1 = mdrTViewLevel1;

    [mdrTViewLevel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTView3.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];

    MyDesReportTableView *mdrTViewLevel2 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel2];
    _mdrTViewLevel2 = mdrTViewLevel2;

    [mdrTViewLevel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTViewLevel1.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];

    MyDesReportTableView *mdrTViewLevel3 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel3];
    _mdrTViewLevel3 = mdrTViewLevel3;

    [mdrTViewLevel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTViewLevel2.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];

    MyDesReportTableView *mdrTViewLevel4 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel4];
    _mdrTViewLevel4 = mdrTViewLevel4;

    [mdrTViewLevel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTViewLevel3.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];

    MyDesReportTableView *mdrTViewLevel5 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel5];
    _mdrTViewLevel5 = mdrTViewLevel5;

    [mdrTViewLevel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTViewLevel4.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];

    MyDesReportTableView *mdrTViewLevel6 = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:mdrTViewLevel6];
    _mdrTViewLevel6 = mdrTViewLevel6;

    [mdrTViewLevel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mdrTViewLevel5.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(tdbbViewLevelHeight);
    }];
}

- (void)setNavUI {
    //   UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    //    btn.frame = CGRectMake(0, 0, 60, 44);
    //    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    //    [btn setTitle:@"今天" forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"nav_clender"] forState:UIControlStateNormal];
    //    [btn setTintColor:[UIColor colorWithHex:@"#343434"]];
    ////    [navBar setTintColor:[UIColor redColor]];
    //
    //    [btn setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    //    [btn addTarget:self action:@selector(showTimeSelectView) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //    self.navigationItem.rightBarButtonItem = right;
    //    self.rightBtn = btn;
}

- (void)setDateView {
    ReportHeaderView *pView = [[ReportHeaderView alloc] init];
    [self.view addSubview:pView];
    [pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(55));
    }];
//    pView = [ReportHeaderView headView];
    self.headerView = pView;
    
    __weak __typeof(self)weakSelf = self;
    pView.beginChange = ^(id object) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf datePickerByType:0];
    };
    pView.endChange = ^(id object) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf datePickerByType:1];
    };
    pView.tag = 1097;
    
    NSInteger width = kSCREEN_WIDTH/2;
    
    
//    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(reusableview).offset(25);
//        make.bottom.equalTo(reusableview);
//        make.height.equalTo(@30);
//    }];
    
    pView.beginTime = self.beginTime;
    pView.endTime = self.endTime;
    
//    [pView removeFromSuperview];
}


- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}
- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        if([self.beginTime isEqualToString:date])
            return;
        self.beginTime = date;
        self.beginTime = self.beginTime;
        self.headerView.beginTime = self.beginTime;
    }else{
        if([self.endTime isEqualToString:date])
            return;
        self.endTime = date;
        self.endTime = self.endTime;
        self.headerView.endTime = self.endTime;
    }
    
    if([self.beginTime compare:self.endTime] == NSOrderedDescending){
        [MBProgressHUD showTipMessageInWindow:@"结束时间不能早于开始时间"];
        return;
    }
    [self getData];
    
}







- (void)setScrollView {
    
    _scrollView = [[UIScrollView alloc] init];
//        _scrollView.backgroundColor = [UIColor cyanColor];
    //设置contentSize,默认是0,不支持滚动
    _scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 3820);
    //设置contentOffset
    //_scrollView.contentOffset = CGPointMake(-50, -50);
    //contentInset(在原有的基础上更改滚动区域)
    //_scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    //锁定方向
    //    _scrollView.directionalLockEnabled = YES;
    
    //滚动的时候,超出内容视图边界,是否有反弹效果
    _scrollView.bounces = YES;
    //假如是yes并且bounces是yes,甚至如果内容大小小于bounds的时候，允许垂直拖动
    _scrollView.alwaysBounceVertical = YES;
    
    //分页
    //    _scrollView.pagingEnabled = YES;
    
    //设置滚动条的显示
    _scrollView.showsVerticalScrollIndicator = YES;
    
    //设置滚动条的滚动范围
    //    _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(50, 50, 0, 0);
    //滚动条样式
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 100);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    
    UIView *contentView = [[UIView alloc]init];
    [_scrollView addSubview:contentView];
        contentView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.equalTo(@3820);
    }];
}


-(void)showTimeSelectView{
    [self.reportFormsView showTimeSelectView];
}







/// 团队活跃度
- (void)tdbbData1 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"团队活跃度" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"注册人数";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_activity.registerCount];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"活跃人数";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_activity.registerCount];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"首充金额/笔数";
    item.desc = self.reportModel.group_activity.first_charge_number;
    item.desc2 = [NSString stringWithFormat:@"%zd", self.reportModel.group_activity.first_charge_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"次充金额/笔数";
    item.desc = self.reportModel.group_activity.second_charge_number;
    item.desc2 = [NSString stringWithFormat:@"%zd", self.reportModel.group_activity.second_charge_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTView1.dataArray = [dataArray copy];
}
/// 团队资金报表
- (void)tdbbData2 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"游戏报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"团队余额";
    item.desc = self.reportModel.group_assets.assets;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"活动奖励";
    item.desc = self.reportModel.group_assets.activity_reward;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"首充总额/笔数";
    item.desc = self.reportModel.group_assets.charge_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_assets.charge_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额/笔数";
    item.desc = self.reportModel.group_assets.withdraw_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_assets.withdraw_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTView2.dataArray = [dataArray copy];
    
}
/// 团队流水报表
- (void)tdbbData3 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"团队流水报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"发包人数";
    item.desc = [NSString stringWithFormat:@"%zd次", self.reportModel.group_capital.send_users];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包人数";
    item.desc = [NSString stringWithFormat:@"%zd次", self.reportModel.group_capital.grab_users];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_capital.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_capital.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_capital.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_capital.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTView3.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel1 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"直属成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level1.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level1.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level1.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level1.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level1.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level1.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level1.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level1.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel1.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel2 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"二级成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level2.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level2.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level2.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level2.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level2.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level2.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level2.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level2.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel2.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel3 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"三级成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level3.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level3.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level3.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level3.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level3.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level3.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level3.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level3.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel3.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel4 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"四级成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level4.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level4.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level4.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level4.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level4.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level4.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level4.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level4.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel4.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel5 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"五级成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level5.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level5.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level5.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level5.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level5.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level5.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level5.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level5.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel5.dataArray = [dataArray copy];
}

/// 直属成员报表
- (void)tdbbDataLevel6 {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"六级成员报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"代理用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level6.agent_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"普通用户";
    item.desc = [NSString stringWithFormat:@"%zd", self.reportModel.group_level.level6.normal_user];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"充值总额";
    item.desc = self.reportModel.group_level.level6.charge_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现总额";
    item.desc = self.reportModel.group_level.level6.withdraw_number;
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"发包金额/个数";
    item.desc = self.reportModel.group_level.level6.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level6.send_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/个数";
    item.desc = self.reportModel.group_level.level6.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd次", self.reportModel.group_level.level6.grab_count];
    item.isShowDesBtn = YES;
    [arr addObject:item];
    
    self.mdrTViewLevel6.dataArray = [dataArray copy];
}



@end
