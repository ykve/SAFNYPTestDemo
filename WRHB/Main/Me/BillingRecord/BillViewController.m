//
//  BillViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "BillViewController.h"
#import "BillHeadView.h"
#import "CDAlertViewController.h"
#import "BillTableViewCell.h"
#import "EnvelopeNet.h"
#import "RedPacketDetListController.h"

#import "BillModel.h"
#import "BillItemModel.h"
#import "BillTypeModel.h"
#import "BillRecotdDetailsController.h"

@interface BillViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *billTypeList;
@property (nonatomic, strong) BillModel *model;
@property (nonatomic, strong) BillHeadView *headView;
// 选中 账单Id
@property (nonatomic, assign) NSInteger selectedId;

@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.billTypeList = [[NSMutableArray alloc] init];
    
    NSDictionary *dic = @{@"id":@"999",@"title":@"全部"};
    [self.billTypeList addObject:dic];
    
    
    [self initData];
    [self setupSubViews];
    [self initLayout];
    
    [self getData];
    
}

#pragma mark ----- Data
- (void)initData{
    _model = [[BillModel alloc]init];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)setupSubViews {
    __weak __typeof(self)weakSelf = self;
    
    __weak BillModel *weakModel = _model;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;

    
    _headView = [BillHeadView headView:NO];
    _headView.billTypeList = self.billTypeList;
    _headView.beginTime = _model.beginTime;
    _headView.endTime = _model.endTime;
    
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


- (void)getData {
    [self getDataByPage:0];
}

- (void)extracted:(NSInteger)page weakSelf:(BillViewController *const __weak)weakSelf {
    [_model getBillListType:self.billTypeModel.category page:page success:^(NSDictionary * _Nonnull info) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if (strongSelf.model.dataList.count > 0) {
            CGFloat allMoney = 0;
            for (BillItemModel *model in strongSelf.model.dataList) {
                allMoney = allMoney + [model.number floatValue];
            }
            strongSelf.headView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f", allMoney];
        } else {
            strongSelf.tableView.mj_footer = nil;
        }
        
        [weakSelf reload];
    } failure:^(NSError *error) {
        [weakSelf reload];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    }];
}

-(void)getDataByPage:(NSInteger)page {
    
    __weak __typeof(self)weakSelf = self;
    [self extracted:page weakSelf:weakSelf];
}

- (void)reload {
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    if (_model.isNoMore) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    if (_model.isEmpty) {
        _tableView.tableFooterView = [self setFootView];
        self.headView.allMoneyLabel.text = @"0元";
    } else {
        _tableView.tableFooterView = nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    BillItemModel *model = [self.model.items objectAtIndex:indexPath.section];
    //
    //    if(tStr.length > 0){
    //        CGSize size = CGSizeMake(kSCREEN_WIDTH - 15, 999);
    //        CGSize titleSize;
    //        titleSize = [model. sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:0];
    //        return titleSize.height + 108;
    //    }
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillTableViewCell"];
    
    if(cell == nil) {
        cell = [BillTableViewCell cellWithTableView:tableView reusableId:@"BillTableViewCell"];
    }
    cell.model = self.model.dataList[indexPath.row];
//    cell.seeDetBtn.userInteractionEnabled = YES;
    cell.seeDetBtn.hidden = NO;
    
    __weak __typeof(self)weakSelf = self;
    [cell setOnSeeDetailsBlock:^(BillItemModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf goto_RedPackedDetail:model  isCowCow:NO];
    }];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillItemModel *model = self.model.dataList[indexPath.row];
    if (model.packet_id > 0) {
        self.selectedId = model.ID;
        [self goto_RedPackedDetail:model  isCowCow:NO];
    } else {
        BillRecotdDetailsController *vc = [[BillRecotdDetailsController alloc] init];
        vc.category = self.self.billTypeModel.category;
        vc.billModel = model;
        [self.navigationController pushViewController:vc animated:YES];
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
