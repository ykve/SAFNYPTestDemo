//
//  BillRecotdDetailsController.m
//  WRHB
//
//  Created by AFan on 2019/12/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BillRecotdDetailsController.h"
#import "BillItemModel.h"
#import "BillRecotdDetailsCell.h"
#import "RedPacketDetListController.h"

@interface BillRecotdDetailsController ()<UITableViewDataSource, UITableViewDelegate>
///
@property (nonatomic, strong) UITableView *tableView;
///
@property (nonatomic, strong) NSMutableDictionary *dataDict;
///
@property (nonatomic, strong) UILabel *titleLabel;
///
@property (nonatomic, strong) UILabel *valueLabel;
///
@property (nonatomic, strong) NSArray *keyArray;

///
@property (nonatomic, strong) NSDictionary *redDict;
@property (nonatomic, strong) NSMutableArray *arrayKey;

@end

@implementation BillRecotdDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"记录详情";
    
    if (self.category == 10) { /// 奖励
        _keyArray = @[@"说明",@"详情",@"时间"];
    } else if (self.category == 11) {  /// 充值
        _keyArray = @[@"说明",@"上分金额",@"赠送",@"累积",@"到帐状态",@"时间"];  /// ? 账
    } else if (self.category == 12) {  /// 提现   ？
        _keyArray = @[@"说明",@"详情",@"时间"];
    } else if (self.category == 14) {  /// 佣金
        _keyArray = @[@"说明",@"到帐状态",@"时间"];    /// ? 账
    } else if (self.category == 15) {  /// 资金往来    ？
        _keyArray = @[@"说明",@"详情",@"时间"];
    } else if (self.category == 16) {  /// 俱乐部返佣
        _keyArray = @[@"说明",@"详情",@"时间"];
    } else if (self.category == 13) {  /// 盈亏记录
        _keyArray = @[@"转账玩家",@"转账状态",@"转账时间",@"领取时间"];;
    }
    
    
    
    [self getDetailsData];
    
    [self.view addSubview:self.tableView];
    [self setTableHeaderView];
}



#pragma mark - 获取数据
- (void)getDetailsData {
    
    NSDictionary *parameters = @{
                                 @"id":@(self.billModel.ID)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/billDetail"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.dataDict = [response[@"data"] mutableCopy];
            [self setHeadViewValue];
            [strongSelf.tableView reloadData];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)setHeadViewValue {
    self.titleLabel.text = self.dataDict[@"标题"];
     self.valueLabel.text = self.dataDict[@"金额"];
    
    [self.dataDict removeObjectForKey:@"标题"];
    [self.dataDict removeObjectForKey:@"金额"];
    
    NSString *xqKey = nil;
    NSMutableArray *arrayKey = [NSMutableArray array];
   
    for (NSString *key in [self.dataDict allKeys]) {
        if ([key isEqualToString:@"红包详情"]) {
            xqKey = key;
            continue;
        }
        [arrayKey addObject:key];
    }
    self.arrayKey = arrayKey;
    if (xqKey.length > 0) {
        [self.arrayKey addObject:xqKey];
    }
}

#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        if (@available(iOS 11.0, *)) {
            // 这句代码会影响 UICollectionView 嵌套使用
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tableView.rowHeight = 44;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (void)setTableHeaderView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    _tableView.tableHeaderView = backView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(30);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"-";
    valueLabel.font = [UIFont boldSystemFontOfSize:20];
    valueLabel.textColor = [UIColor colorWithHex:@"#DA1D1D"];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:valueLabel];
    _valueLabel = valueLabel;
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(backView.mas_centerX);
    }];
}

#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataDict.count;
    
//    return self.dataDict.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BillRecotdDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillRecotdDetailsCell"];
    if(cell == nil) {
        cell = [BillRecotdDetailsCell cellWithTableView:tableView reusableId:@"BillRecotdDetailsCell"];
    }
    
//    NSString *title = (NSString *)[self.dataDict allKeys][indexPath.row];
//    NSString *text = (NSString *)[self.dataDict allValues][indexPath.row];
//
//    cell.titleLabel.text = title;
//    if ([title isEqualToString:@"红包详情"]) {
//         cell.desLabel.text = @"查看详情";
//        self.redDict = [text mj_JSONObject];
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetails)];
//        [cell addGestureRecognizer:tapGesture];
//        [tapGesture setNumberOfTapsRequired:1];
//    } else {
//        cell.desLabel.text = text;
//    }
    
    
    cell.titleLabel.text = self.arrayKey[indexPath.row];
    if ([self.arrayKey[indexPath.row] isEqualToString:@"红包详情"]) {
        cell.desLabel.text = @"查看详情";
        self.redDict = [self.dataDict[self.arrayKey[indexPath.row]] mj_JSONObject];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetails)];
        [cell addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
    } else {
        cell.desLabel.text = self.dataDict[self.arrayKey[indexPath.row]];
    }
    
    return cell;
}


#pragma mark -  goto红包详情
- (void)onDetails {
    
    NSInteger redpId = [self.redDict[@"packet_id"] integerValue];
    RedPacketDetListController *vc = [[RedPacketDetListController alloc] init];
    vc.redPackedId = [NSString stringWithFormat:@"%zd", redpId];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}
- (NSArray *)keyArray {
    if (!_keyArray) {
        _keyArray = [NSArray array];
    }
    return _keyArray;
}

@end
