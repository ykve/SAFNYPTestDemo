//
//  WithdrawMainViewController.m
//  Project
//
//  Created by fangyuan on 2019/2/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayWithdrawalCenterController.h"
#import "WithdrawView.h"
#import "AddBankCardViewController.h"
#import "UIImageView+WebCache.h"
//#import "WDDetailViewController.h"
#import "PayAssetsModel.h"

#import "TFPopup.h"
#import "BankModel.h"
#import "ListView.h"
#import "BanklistCell.h"
#import "NSString+RegexCategory.h"
#import "SystemNotificationModel.h"
#import "VVAlertModel.h"
#import "WithdrawalAlertViewController.h"

@interface PayWithdrawalCenterController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WithdrawView *wdView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<BankModel *> *bankArray;

@property (nonatomic, strong) BankModel *selectBankModel;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isAddNewCard;
/// 余额
@property (nonatomic, strong) PayAssetsModel *assetsModel;
@property(nonatomic,strong) TFPopupParam *param;
@property(nonatomic,assign)PopupDirection popupDirection;

/// 提现说明
@property (nonatomic, strong) NSMutableArray *withdrawalDesArray;


@end

@implementation PayWithdrawalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现中心";
    self.view.backgroundColor = BaseColor;
    
    self.isAddNewCard = NO;
    
    [self getBankCarListData];
    [self getPayWithdrawalInfo];
    
    self.tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 200;
    
    _tableView.tableHeaderView = [self headrView];
    
    _tableView.tableFooterView = [self footView];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    
    WEAK_OBJ(weakSelf, self);
    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        //        [weakSelf requestHistoryListWithPage:weakSelf.currentPage++];
    }];
    
    self.currentPage = 1;
    //    [self requestHistoryListWithPage:self.currentPage ];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewCard:) name:@"addNewCard" object:nil];
    
    [self.tableView registerClass:[BanklistCell class] forCellReuseIdentifier:@"BanklistCell"];
    
    
    // 提现说明
    SystemNotificationModel *model1 = [[SystemNotificationModel alloc] init];
    model1.ID = 1;
    model1.desTitle = @"本平台需要达1倍流水即可提现";
    
    // 提现说明
    SystemNotificationModel *model2 = [[SystemNotificationModel alloc] init];
    model2.ID = 2;
    model2.desTitle = @"比如您金额有200元，但您在游戏中只发了100元红包，那么您的可提现额就是100元";
    // 提现说明
    SystemNotificationModel *model3 = [[SystemNotificationModel alloc] init];
    model3.ID = 3;
    model3.desTitle = @"如果你的余额有200元，可提现额有500元，那么您也只能提现200元，剩余的300元可提现额等下次金币余额足够时可提现";
    // 提现说明
    SystemNotificationModel *model4 = [[SystemNotificationModel alloc] init];
    model4.ID = 4;
    model4.desTitle = @"玩家每次提现后都会扣除与提现金额对等可提现额";
    
    [self.withdrawalDesArray addObject:model1];
    [self.withdrawalDesArray addObject:model2];
    [self.withdrawalDesArray addObject:model3];
    [self.withdrawalDesArray addObject:model4];
}


- (NSMutableArray *)bankArray {
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
        
        BankModel *model = [[BankModel alloc] init];
        model.bank_name = @"使用新卡提现";
        model.icon = @"1";
        model.desTime = @"添加新卡";
        [_bankArray addObject:model];
    }
    return _bankArray;
}

#pragma mark -  添加银行卡
- (void)action_addBankCardBtn {
    AddBankCardViewController *vc = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addNewCard:(NSNotification *)notification{
    self.isAddNewCard = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArray.count > 1 ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BanklistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BanklistCell"];
    if (cell == nil) {
        cell = [[BanklistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BanklistCell"];
    }
    cell.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    cell.exitBtn.hidden = YES;
    cell.model = self.selectBankModel;
    //    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    
    BankModel *model = [self.bankArray objectAtIndex:indexPath.row];
    
    
    //    WDDetailViewController *vc = [[WDDetailViewController alloc] init];
    //    vc.infoDic = dic;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    
    self.param.popupSize = CGSizeMake(self.view.frame.size.width, 260);
    UIView *popup = [self getListView];
    //self.param.offset = CGPointMake(-50, -100);
    //[popup tf_showSlide:self.view direction:self.popupDirection];
    self.param.dragEnable = YES;
    [popup tf_showSlide:self.view direction:PopupDirectionBottom popupParam:self.param];
    
}



-(void)selectBankAction {
    [self.view endEditing:YES];
    
    if(self.bankArray == nil||self.bankArray.count==0){
        BankModel *model = [[BankModel alloc] init];
        model.bank_name = @"使用新卡提现";
        model.icon = @"1";
        model.desTime = @"添加新卡";
        [self.bankArray addObject:model];
    }
    
    if(self.bankArray.count == 1){
        PUSH_C(self, AddBankCardViewController, YES);
        return;
    }
    if(self.selectBankModel){
        for (BankModel *model in self.bankArray) {
            if([self.selectBankModel.card isEqualToString:model.card]){
                model.isSelected = YES;
            }else {
                model.isSelected = NO;
            }
        }
    }else{
        for (BankModel *model in self.bankArray) {
            model.isSelected = NO;
        }
    }
    
}


// 最后一张银行卡 显示在视图上面
-(void)getLastWithdrawInfo {
    BankModel *bankModel = self.bankArray.firstObject;
    // 截取字符串
    NSString *upayNo = bankModel.card;;
    if(upayNo.length > 4) {
        upayNo = [upayNo substringFromIndex:upayNo.length - 4];
    }
    bankModel.isSelected = YES;
    self.selectBankModel = bankModel;
}



#pragma mark -  提现提交
-(void)submit {
    [self.view endEditing:YES];
    NSString *money = self.wdView.textField.text;
    if(money.length == 0){
        [MBProgressHUD showTipMessageInWindow:@"请输入提现金额"];
        return;
    }
    money = [NSString stringWithFormat:@"%.02f",[money doubleValue]];
    if([money isEqualToString:@"0.00"]){
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的提现金额"];
        return;
    }
    
    if(![NSString checkIsNum:money]){
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的金额"];
        return;
    }
    if(self.selectBankModel == nil){
        [MBProgressHUD showTipMessageInWindow:@"请选择银行"];
        return;
    }
    
    NSString *bankId = self.selectBankModel.card;
    
    NSDictionary *parameters = @{
                                 @"withdraw_number":self.wdView.textField.text,   // 提现数量
                                 @"bank_card":bankId   // 提现卡号
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/withdraw"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    //    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInWindow:@"提现申请成功提交"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getBankCarListData];
}


#pragma mark -  请求银行卡列表
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
            
            NSArray *banArray = [BankModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (banArray.count > 0) {
                strongSelf.tableView.tableHeaderView = nil;
            }
            for (BankModel *model in banArray) {
                [strongSelf.bankArray insertObject:model atIndex:0];
            }
            
            [strongSelf getLastWithdrawInfo];
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


#pragma mark -  提现信息
- (void)getPayWithdrawalInfo {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/withdrawInfo"];
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            PayAssetsModel *payArray = [PayAssetsModel mj_objectWithKeyValues:response[@"data"]];
            strongSelf.assetsModel = payArray;
            [strongSelf setFootView];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)setFootView {
    NSString *moneyee = [NSString stringWithFormat:@"金额余额：%@元", self.assetsModel.over_num];
    self.wdView.moneyYuELabel.text = moneyee;
    self.wdView.moneyLabel.text = [NSString stringWithFormat:@"%@",self.assetsModel.can_withdraw];
    self.wdView.ttiLabel.text = [NSString stringWithFormat:@"每天最多可提现%zd次",self.assetsModel.withdraw_num];
}



#pragma mark -  列表
-(TFPopupParam *)param{
    if (_param == nil) {
        _param = [TFPopupParam new];
    }
    return _param;
}

-(UIView *)getListView {
    
    ListView *list = [[ListView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 260)];
    list.dataSource = self.bankArray;
    
    __weak __typeof(list) weakView = list;
    __weak __typeof(self)weakSelf = self;
    [list observerSelected:^(BankModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([model.bank_name containsString:@"新卡"]) {
            model.isSelected = NO;
            [strongSelf action_addBankCardBtn];
        } else {
            model.isSelected = YES;
            [strongSelf.tableView reloadData];
        }
        strongSelf.selectBankModel = model;
        [weakView tf_hide];
    }];
    list.cancelBlock = ^{
        [weakView tf_hide];
    };
    
    
    return list;
}


#pragma mark - 公告栏点击事件
- (void)onScorllTextLableEvent:(UITapGestureRecognizer *)gesture {
    [self goto_SystemAlertViewController:self.withdrawalDesArray];
}

#pragma mark - goto 系统公告栏
- (void)goto_SystemAlertViewController:(NSArray<SystemNotificationModel *> *)sysTextArray {
    NSMutableArray *announcementArray = [NSMutableArray array];
    if(sysTextArray.count > 0) {
        for (SystemNotificationModel *model in sysTextArray) {
            NSString *title = model.desTitle;
            NSString *content = model.detail;
            VVAlertModel *model = [[VVAlertModel alloc] init];
            model.name = title;
            if (content.length > 0) {
                model.friends = @[content];
            }
            [announcementArray addObject:model];
        }
    } else {
        return;
    }
    WithdrawalAlertViewController *alertVC = [WithdrawalAlertViewController alertControllerWithTitle:@"提现说明" dataArray:announcementArray];
    [self presentViewController:alertVC animated:NO completion:nil];
}



-(UIView *)headrView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 190)];
    headView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadViewClickEvent)];
    //将手势添加到需要相应的view中去
    [headView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"me_pay_bankcard_addbg"];
    [headView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"添加银行卡";
    addLabel.font = [UIFont systemFontOfSize:16];
    addLabel.textColor = [UIColor colorWithHex:@"#343434"];
    addLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:addLabel];
    
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-50);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"添加银行卡方便提现及时到账";
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor colorWithHex:@"#999999"];
    desLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-30);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    
    
    return headView;
}


/**
 添加银行卡
 */
- (void)onHeadViewClickEvent {
    [self action_addBankCardBtn];
}



-(UIView *)footView {
    //    WithdrawView *wdView = [[[NSBundle mainBundle] loadNibNamed:@"WithdrawView" owner:nil options:nil] lastObject];
    WithdrawView *wdView = [[WithdrawView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    
    [wdView initView];
    [wdView.selectBankBtn addTarget:self action:@selector(selectBankAction) forControlEvents:UIControlEventTouchUpInside];
    [wdView.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.wdView = wdView;
    self.wdView.bankIconImageView.image = nil;
    self.wdView.bankLabel.text = @"添加银行卡";
    self.wdView.textField.placeholder = [NSString stringWithFormat:@"最低提现额度%zd元",[[AppModel sharedInstance].commonInfo[@"cashdraw.money.min"] integerValue]];
    
    
    __weak __typeof(self)weakSelf = self;
    [wdView setDesIconBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf onScorllTextLableEvent:nil];
    }];
    
    return self.wdView;
}

- (NSMutableArray *)withdrawalDesArray {
    if (!_withdrawalDesArray) {
        _withdrawalDesArray = [NSMutableArray array];
    }
   return _withdrawalDesArray;
}
@end
