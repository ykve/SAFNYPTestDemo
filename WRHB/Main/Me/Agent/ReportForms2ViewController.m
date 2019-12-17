//
//  ReportForms2ViewController.m
//  Project
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ReportForms2ViewController.h"
#import "ActivityView.h"
#import "ReportFormsView.h"
#import "MyDesReportTableView.h"

#import "Sub_Users.h"
#import "Sub_Withdraw.h"
#import "Sub_Recharge.h"
#import "Sub_Game.h"
#import "Sub_Activity.h"



@interface ReportForms2ViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) MyDesReportTableView *zijinBaobiaoView;
@property (nonatomic, strong) MyDesReportTableView *gameBaobiaoView;
@property (nonatomic, strong) MyDesReportTableView *huodongBaobiaoView;

@end

@implementation ReportForms2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    self.title = @"个人报表";
    
    
    [self setScrollView];
    
    
    CGFloat ssHeight = 20;
//    MyDesReportTableView *zijinBaobiaoView = [[MyDesReportTableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, self.view.frame.size.width, 202.5)];
    MyDesReportTableView *zijinBaobiaoView = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:zijinBaobiaoView];
    _zijinBaobiaoView = zijinBaobiaoView;
    
    [zijinBaobiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(202.5);
    }];
    
    MyDesReportTableView *gameBaobiaoView = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:gameBaobiaoView];
    _gameBaobiaoView = gameBaobiaoView;
    
    [gameBaobiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zijinBaobiaoView.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(202.5);
    }];
    
     MyDesReportTableView *huodongBaobiaoView = [[MyDesReportTableView alloc] init];
    [self.contentView addSubview:huodongBaobiaoView];
    _huodongBaobiaoView = huodongBaobiaoView;
    
    [huodongBaobiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gameBaobiaoView.mas_bottom).offset(ssHeight);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(700);
    }];
    
    
    [self zijinBaobiao];
    [self gameBaobiao];
    [self huodongBaobiao];
}

/// 资金报表
- (void)zijinBaobiao {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"资金报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"充值金额";
    item.desc = self.sub_User.recharge.number;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"提现金额";
    item.desc = self.sub_User.withdraw.number;
    [arr addObject:item];
    
    self.zijinBaobiaoView.dataArray = [dataArray copy];
}
/// 游戏报表
- (void)gameBaobiao {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"游戏报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"发包金额/次数";
    item.desc = self.sub_User.game.send_number;
    item.desc2 = [NSString stringWithFormat:@"%zd", self.sub_User.game.send_count];
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"抢包金额/次数";
    item.desc = self.sub_User.game.grab_number;
    item.desc2 = [NSString stringWithFormat:@"%zd", self.sub_User.game.grab_count];
    [arr addObject:item];
    self.gameBaobiaoView.dataArray = [dataArray copy];
}

/// 活动报表
- (void)huodongBaobiao {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [dataArray addObject:categoryDic];
    [categoryDic setObject:@"活动报表" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"首冲奖励";
    item.desc = self.sub_User.activity.first_charge_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"次充奖励";
    item.desc =self.sub_User.activity.second_charge_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计充值奖励";
    item.desc = self.sub_User.activity.recharge_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"好友充值奖励";
    item.desc = self.sub_User.activity.friend_charge_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计发包奖励";
    item.desc = self.sub_User.activity.send_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计抢包奖励";
    item.desc = self.sub_User.activity.grab_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计签到奖励";
    item.desc = self.sub_User.activity.check_in_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计领取救济金";
    item.desc = @"-";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计领取代理工资";
    item.desc = self.sub_User.activity.agent_salary;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"累计领取基金返利";
    item.desc = self.sub_User.activity.fund_reward;
    [arr addObject:item];
    self.huodongBaobiaoView.dataArray = [dataArray copy];
}



- (void)setScrollView {
    
    _scrollView = [[UIScrollView alloc] init];
    //    _scrollView.backgroundColor = [UIColor cyanColor];
    //设置contentSize,默认是0,不支持滚动
    _scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 1200);
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
        make.edges.equalTo(self.view);
    }];
    
    
    UIView *contentView = [[UIView alloc]init];
    [_scrollView addSubview:contentView];
    //    contentView.backgroundColor = [UIColor greenColor];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.equalTo(@1200);
    }];
}

@end
