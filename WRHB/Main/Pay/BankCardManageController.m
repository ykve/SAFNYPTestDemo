//
//  BankCardManageController.m
//  WRHB
//
//  Created by AFan on 2019/10/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BankCardManageController.h"
#import "AddBankCardViewController.h"
#import "WithdrawBankModel.h"
#import "BanklistCell.h"
#import "UIView+TapAction.h"

@interface BankCardManageController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *bankArray;
/// 最大银行卡张数
@property (nonatomic, assign) NSInteger maxBankAmount;


@end

@implementation BankCardManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡管理";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];

    self.maxBankAmount = 8;
    
    [self initTableView];
    [self getCardNum];
    
//    [self getpriceData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self getBankCarListData];
}

#pragma mark - initTableView
- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-Height_NavBar-kiPhoneX_Bottom_Height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 170;
    // 去除横线
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[BanklistCell class] forCellReuseIdentifier:@"BanklistCell"];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.bankArray.count;
    return 2;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return kSCREEN_WIDTH * 0.197;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return self.bankArray.count >= self.maxBankAmount ? 0 : 170;
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BanklistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BanklistCell"];
    if (cell == nil) {
        cell = [[BanklistCell alloc] initWithStyle:0 reuseIdentifier:@"BanklistCell"];
    }
    cell.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    WithdrawBankModel *model = [self.bankArray objectAtIndex:indexPath.row];
    cell.model = model;
    __weak __typeof(self)weakSelf = self;
    cell.deleteBankCardBlock = ^(WithdrawBankModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf deleteBankCardBlock:model];
    };
    return cell;
    
}


#pragma mark -  删除银行卡
- (void)deleteBankCardBlock:(WithdrawBankModel *)model {
    
     NSDictionary *parameters = @{
                                  @"bank_card":model.card
                                  };
                         
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/removeBankCard"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
             [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            [strongSelf getBankCarListData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)];
    footerView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    __weak __typeof(self)weakSelf = self;
    [footerView tapHandle:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf addCardAction];
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"me_pay_bankcard_addbg"];
    [footerView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"添加银行卡";
    addLabel.font = [UIFont systemFontOfSize:16];
    addLabel.textColor = [UIColor colorWithHex:@"#343434"];
    addLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:addLabel];
    
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-50);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"添加银行卡方便提现及时到账";
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor colorWithHex:@"#999999"];
    desLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-30);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark -  添加银行卡
-(void)addCardAction {
    
    AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -  查询用户绑定的银行号列表
-(void)getBankCarListData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/myBankCards"];
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.bankArray = [WithdrawBankModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            
            [strongSelf.tableView reloadData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  获取银行卡数量
- (void)getCardNum{
    
    NSDictionary *dic = @{@"names" : @"BIND_BANK_CARD_AMOUNT"};
    
//    [WebTools postWithURL:@"/app/sys/querySystemInfoByNames.json" params:dic success:^(BaseData *data) {
//        MBLog(@"%@", data);
//
//        if (![data.status isEqualToString:@"1"] || [data.data isEqual:@""]) {
//            return;
//        }
//        self.maxBankAmount = [data.data[@"BIND_BANK_CARD_AMOUNT"] intValue];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//
//    }];
}

-(void)dealloc {
    
    NSLog(@"%s dealloc",object_getClassName(self));
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUpdateAddBankNotification object:nil];
}

@end
