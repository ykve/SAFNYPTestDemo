//
//  PayTopupRecordController.m
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopupRecordController.h"
#import "TopupRecordHeadView.h"
#import "CDAlertViewController.h"
#import "PayTopupRecordCell.h"
#import "EnvelopeNet.h"
#import "RedPacketDetListController.h"

#import "BillModel.h"
#import "BillItemModel.h"
#import "BillTypeModel.h"

@interface PayTopupRecordController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *billTypeList;
@property (nonatomic, strong) BillModel *model;
@property (nonatomic, strong) TopupRecordHeadView *headView;
// 选中 账单Id
@property (nonatomic, assign) NSInteger selectedId;

@end

@implementation PayTopupRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    
    self.billTypeList = [[NSMutableArray alloc] init];
    _model = [[BillModel alloc]init];
    
    [self getData];
    
    [self setupSubViews];
}


#pragma mark - initUI
- (void)setupSubViews {
    __weak __typeof(self)weakSelf = self;
    
    __weak BillModel *weakModel = _model;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _headView = [[TopupRecordHeadView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 110)];
    _headView.backgroundColor = [UIColor whiteColor];
//    _headView.billTypeList = self.billTypeList;
//    _headView.beginTime = _model.beginTime;
//    _headView.endTime = _model.endTime;
    
    _headView.endChange = ^(id time) {
        [weakSelf datePickerByType:1];
    };
    _headView.beginChange = ^(id time) {
        [weakSelf datePickerByType:0];
    };
    _headView.TypeChange = ^(NSInteger type) {
        NSDictionary *dic = weakSelf.billTypeList[type];
        //        weakModel.billName = dic[@"name"];
        [weakSelf performSelector:@selector(getData) withObject:nil afterDelay:0.5];
    };
    
    _tableView.tableHeaderView = _headView;
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (!weakModel.isNoMore) {
            [strongSelf getDataByPage:weakModel.page];
        }
    }];
    
    
    [self.tableView registerClass:[PayTopupRecordCell class] forCellReuseIdentifier:@"PayTopupRecordCell"];
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


- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}

- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        _headView.beginTime = date;
        _model.beginTime = date;
    }else{
        _headView.endTime = date;
        _model.endTime = date;
    }
    if([_model.endTime compare:_model.beginTime] == NSOrderedAscending){
        [MBProgressHUD showTipMessageInWindow:@"结束时间不能早于开始时间"];
        return;
    }
    [self getData];
}


- (void)getData{
    //    [MBProgressHUD showActivityMessageInView:nil];
    [self getDataByPage:0];
}

-(void)getDataByPage:(NSInteger)page {
    
    __weak __typeof(self)weakSelf = self;
    [_model getBillListType:self.billTypeModel.category page:page success:^(NSDictionary * _Nonnull info) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [MBProgressHUD hideHUD];
        if (strongSelf.model.dataList.count > 0) {
            CGFloat allMoney = 0;
            for (BillItemModel *model in strongSelf.model.dataList) {
                allMoney = allMoney + [model.number floatValue];
            }
            strongSelf.headView.allMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", allMoney];
            
        } else {
            strongSelf.tableView.mj_footer = nil;
        }
        [weakSelf reload];
        
    } failure:^(NSError *error) {
        [weakSelf reload];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    }];
}

- (void)reload {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    if (self.model.isNoMore) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.model.isEmpty) {
        _tableView.tableFooterView = [self setFootView];
        self.headView.allMoneyLabel.text = @"￥0";
    } else {
        _tableView.tableFooterView = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PayTopupRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTopupRecordCell"];
    
    if(cell == nil) {
        cell = [PayTopupRecordCell cellWithTableView:tableView reusableId:@"PayTopupRecordCell"];
    }
    cell.model = self.model.dataList[indexPath.row];
    
    __weak __typeof(self)weakSelf = self;
    [cell setOnSeeDetailsBlock:^(BillItemModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goto_RedPackedDetail:model  isCowCow:NO];
    }];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sourceType == 1) {
        BillItemModel *model = self.model.dataList[indexPath.row];
        self.selectedId = model.ID;
        [self goto_RedPackedDetail:model  isCowCow:NO];
    } else {
        
    }
    
}


#pragma mark -  goto红包详情
- (void)goto_RedPackedDetail:(BillItemModel*)model isCowCow:(BOOL)isCowCow {
    [self.view endEditing:YES];
    
    NSInteger taID = 0;
    if (self.sourceType == 1) {
        taID = model.packet_id;
    } else {
        taID = model.target_id;
    }
    RedPacketDetListController *vc = [[RedPacketDetListController alloc] init];
    vc.redPackedId = [NSString stringWithFormat:@"%zd", taID];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)detailAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
