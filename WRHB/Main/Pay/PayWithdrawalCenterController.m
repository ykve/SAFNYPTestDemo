//
//  WithdrawMainViewController.m
//  WRHB
//
//  Created by AFan on 2019/2/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayWithdrawalCenterController.h"
#import "WithdrawView.h"
#import "AddBankCardViewController.h"
#import "UIImageView+WebCache.h"
//#import "WDDetailViewController.h"
#import "PayAssetsModel.h"

#import "TFPopup.h"
#import "WithdrawBankModel.h"
#import "ListView.h"
#import "BanklistCell.h"
#import "NSString+RegexCategory.h"
#import "SystemNotificationModel.h"
#import "VVAlertModel.h"
#import "WithdrawalAlertViewController.h"
#import "UIView+AZGradient.h"   // 渐变色
#import "WithdrawalTipsController.h"
#import "WithdrawalConfirmTipsController.h"
#import "SPAlertController.h"
#import "LoginForgetPsdController.h"

@interface PayWithdrawalCenterController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WithdrawView *wdView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WithdrawBankModel *> *bankArray;

@property (nonatomic, strong) WithdrawBankModel *selectBankModel;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isAddNewCard;
///
@property (nonatomic, strong) PayAssetsModel *assetsModel;
@property(nonatomic,strong) TFPopupParam *param;
@property(nonatomic,assign)PopupDirection popupDirection;

/// 提现说明
@property (nonatomic, strong) NSMutableArray *withdrawalDesArray;


@property (nonatomic, strong) UILabel *dmlMoneyLabel;
@property (nonatomic, strong) UILabel *dmlTSLabel;
@property (nonatomic, strong) UILabel *moneyYuELabel;

@property (nonatomic, strong) UITextField *txMoneyTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *pdIconBtn;

@property (nonatomic, strong) UILabel *ttiNumLabel;
@property (nonatomic, strong) UILabel *sxfMoneyLabel;
@property (nonatomic, strong) UIButton *submitBtn;
/// 1 满足打码 2 不满足打码
@property (nonatomic, assign) NSInteger txType;
@end

@implementation PayWithdrawalCenterController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现中心";
    self.view.backgroundColor = BaseColor;
    
    self.isAddNewCard = NO;
    
    [self getBankCarListData];
    [self getPayWithdrawalInfo];
    
    [self setBankListTableView];
    
    [self textDescriptionPopView];
    
    [self.txMoneyTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}



-(void)textFieldTextChange:(UITextField *)textField {
    [self setBtnStatsText:textField.text];
}

- (void)setBtnStatsText:(NSString *)text {
    if (self.txMoneyTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        // 渐变色
        [self.submitBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF8888"],[UIColor colorWithHex:@"#FF4444"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        self.submitBtn.userInteractionEnabled = YES;
    } else {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
        self.submitBtn.userInteractionEnabled = NO;
    }
}



- (void)textDescriptionPopView {
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

- (void)setBankListTableView {
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
}


- (NSMutableArray *)bankArray {
    if (!_bankArray) {
        _bankArray = [NSMutableArray array];
        
        WithdrawBankModel *model = [[WithdrawBankModel alloc] init];
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
    
    /// 银行卡列表
    WithdrawBankModel *model = [self.bankArray objectAtIndex:indexPath.row];
    self.param.popupSize = CGSizeMake(self.view.frame.size.width, 260);
    UIView *popup = [self getListView];
    self.param.dragEnable = YES;
    [popup tf_showSlide:self.view direction:PopupDirectionBottom popupParam:self.param];
    
}



-(void)selectBankAction {
    [self.view endEditing:YES];
    
    if(self.bankArray == nil||self.bankArray.count==0){
        WithdrawBankModel *model = [[WithdrawBankModel alloc] init];
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
        for (WithdrawBankModel *model in self.bankArray) {
            if([self.selectBankModel.card isEqualToString:model.card]){
                model.isSelected = YES;
            }else {
                model.isSelected = NO;
            }
        }
    }else{
        for (WithdrawBankModel *model in self.bankArray) {
            model.isSelected = NO;
        }
    }
    
}


// 最后一张银行卡 显示在视图上面
-(void)getLastWithdrawInfo {
    WithdrawBankModel *bankModel = self.bankArray.firstObject;
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
    
    NSDictionary *parameters = @{
                                 @"withdraw_number":self.txMoneyTextField.text,   // 提现数量
                                 @"bank_card":self.selectBankModel.card,   // 提现卡号
                                 @"password":self.passwordTextField.text,   // 提现密码
                                 @"type":@(self.txType),   // 1 满足打码 2 不满足打码
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
            
            NSArray *banArray = [WithdrawBankModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (banArray.count > 0) {
                strongSelf.tableView.tableHeaderView = nil;
            }
            for (WithdrawBankModel *model in banArray) {
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
    self.dmlMoneyLabel.text = [NSString stringWithFormat:@"%@/%@", self.assetsModel.can_withdraw, self.assetsModel.change_capital];
    if ([self.assetsModel.can_withdraw floatValue] >= [self.assetsModel.change_capital floatValue]) {
        self.dmlTSLabel.text = @"可提现";
        self.dmlTSLabel.textColor = [UIColor colorWithHex:@"#00BC12"];
    } else {
        self.dmlTSLabel.text = @"打码量不足";
        self.dmlTSLabel.textColor = [UIColor redColor];
    }
    
    self.moneyYuELabel.text = [NSString stringWithFormat:@"%@元", self.assetsModel.over_num];
    self.ttiNumLabel.text = [NSString stringWithFormat:@"每日提现次数: %zd次",self.assetsModel.withdraw_num];
    self.sxfMoneyLabel.text = self.assetsModel.fee_rate;
}

#pragma mark -  点击提现
- (void)action_TX {
    
    [self.view endEditing:YES];
    if(self.selectBankModel == nil){
        [MBProgressHUD showTipMessageInWindow:@"请选择银行"];
        return;
    }
    
    NSString *bankId = self.selectBankModel.card;
    if (bankId.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请添加银行卡"];
        return;
    }
    
    NSString *money = self.txMoneyTextField.text;
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
    
    NSString *password = self.passwordTextField.text;
    if(password.length == 0){
        [MBProgressHUD showTipMessageInWindow:@"请输入交易密码"];
        return;
    }
    
    /// 判断是否设置交易密码
    if (![AppModel sharedInstance].set_trade_password) {
        [self passwordAlert];
        return;
    }
    
    if(password.length < 6) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的交易密码"];
        return;
    }
    
//    if ([self.txMoneyTextField.text floatValue] > [self.assetsModel.can_withdraw floatValue]) {
//        [MBProgressHUD showTipMessageInWindow:@"提现金额不能大于可提现金额"];
//        return;
//    }
    
    
    
    if ([self.assetsModel.can_withdraw floatValue] >= [self.assetsModel.change_capital floatValue]) {
        self.txType = 1;
    } else {
        self.txType = 2;
    }
    [self withdrawalTipsPopView];
}


- (void)passwordAlert {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"密码未设置" message:@"交易密码未设置，请设置好以后继续操作" preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    alertController.needDialogBlur = YES;
    
    __weak __typeof(self)weakSelf = self;
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"前往设置" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了确定");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        LoginForgetPsdController *vc = [[LoginForgetPsdController alloc] init];
        vc.updateType = 2;
        vc.navigationItem.title = @"设置交易密码";
        [strongSelf.navigationController pushViewController:vc animated:YES];
    }];
    // SPAlertActionStyleDestructive默认文字为红色(可修改)
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    // 设置第2个action的颜色
    action2.titleColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -  温馨提示
- (void)withdrawalTipsPopView {
    WithdrawalTipsController *alertVC = [[WithdrawalTipsController alloc] init];
    
    __weak __typeof(self)weakSelf = self;
    alertVC.onSubmitBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performSelector:@selector(confirmTipsPopView) withObject:nil afterDelay:0.5];
    };
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

/// 提现确认
- (void)confirmTipsPopView {
    WithdrawalConfirmTipsController *vc = [[WithdrawalConfirmTipsController alloc] init];
    vc.txType = self.txType;
    __weak __typeof(self)weakSelf = self;
    vc.onSubmitBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performSelector:@selector(submit) withObject:nil afterDelay:0.1];
    };
    
    [self presentViewController:vc animated:NO completion:nil];
    vc.txMoney = self.txMoneyTextField.text;
    vc.selectBankModel = self.selectBankModel;
    vc.assetsModel = self.assetsModel;
}



- (void)onPdIconBtn:(UIButton *)sender {
    
    UIImage *currentImage = [sender imageForState:UIControlStateNormal];
    if(currentImage  == [UIImage imageNamed:@"pay_tx_pd_hid"]) {
        [self.pdIconBtn setImage:[UIImage imageNamed:@"pay_tx_pd_show"] forState:UIControlStateNormal];
        self.passwordTextField.secureTextEntry = NO;
    } else {
        [self.pdIconBtn setImage:[UIImage imageNamed:@"pay_tx_pd_hid"] forState:UIControlStateNormal];
        self.passwordTextField.secureTextEntry = YES;
    }
}
- (void)onMaxBtn {
    
    self.txMoneyTextField.text = self.assetsModel.can_withdraw;
}


-(UIView *)footView {
    
    UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 400)];
    footerBgView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    
    CGFloat cellHeight = 55;
    CGFloat marWidht = 15;
    CGFloat mmHeight = 5;
    /// ********* 1 *********
    UIView *backView1 = [[UIView alloc] init];
    backView1.layer.cornerRadius = 5;
    backView1.layer.masksToBounds = YES;
    backView1.backgroundColor = [UIColor whiteColor];
    [footerBgView addSubview:backView1];
    
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerBgView.mas_top).offset(5);
        make.left.equalTo(footerBgView.mas_left).offset(marWidht);
        make.right.equalTo(footerBgView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UIImageView *iconView1 = [[UIImageView alloc] init];
    iconView1.image = [UIImage imageNamed:@"pay_tx_dml"];
    [backView1 addSubview:iconView1];
    
    [iconView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(backView1.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    UILabel *titLabel1 = [[UILabel alloc] init];
    titLabel1.text = @"提现所需打码量";
    titLabel1.font = [UIFont systemFontOfSize:14];
    titLabel1.textColor = [UIColor colorWithHex:@"#333333"];
    [backView1 addSubview:titLabel1];
    
    [titLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(iconView1.mas_right).offset(7);
    }];
    
    UILabel *dmlMoneyLabel = [[UILabel alloc] init];
    dmlMoneyLabel.text = @"0/0";
    dmlMoneyLabel.font = [UIFont systemFontOfSize:12];
    dmlMoneyLabel.textColor = [UIColor redColor];
    [backView1 addSubview:dmlMoneyLabel];
    _dmlMoneyLabel = dmlMoneyLabel;
    
    [dmlMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(titLabel1.mas_right).offset(5);
    }];
    
    UILabel *dmlTSLabel = [[UILabel alloc] init];
    dmlTSLabel.text = @"打码量不足";
    dmlTSLabel.font = [UIFont systemFontOfSize:12];
    dmlTSLabel.textColor = [UIColor redColor];
    [backView1 addSubview:dmlTSLabel];
    _dmlTSLabel = dmlTSLabel;
    
    [dmlTSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.right.equalTo(backView1.mas_right).offset(-15);
    }];
    
    /// ********* 2 *********
    UIView *backView2 = [[UIView alloc] init];
    backView2.layer.cornerRadius = 5;
    backView2.layer.masksToBounds = YES;
    backView2.backgroundColor = [UIColor whiteColor];
    [footerBgView addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView1.mas_bottom).offset(mmHeight);
        make.left.equalTo(backView1.mas_left);
        make.right.equalTo(backView1.mas_right);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UIImageView *iconView2 = [[UIImageView alloc] init];
    iconView2.image = [UIImage imageNamed:@"pay_tx_money"];
    [backView2 addSubview:iconView2];
    
    [iconView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(backView2.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    UILabel *titLabel2 = [[UILabel alloc] init];
    titLabel2.text = @"金币金额";
    titLabel2.font = [UIFont systemFontOfSize:15];
    titLabel2.textColor = [UIColor colorWithHex:@"#333333"];
    [backView2 addSubview:titLabel2];
    
    [titLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(iconView2.mas_right).offset(7);
    }];
    
    UILabel *moneyYuELabel = [[UILabel alloc] init];
    moneyYuELabel.text = @"0元";
    moneyYuELabel.font = [UIFont systemFontOfSize:13];
    moneyYuELabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView2 addSubview:moneyYuELabel];
    _moneyYuELabel = moneyYuELabel;
    
    [moneyYuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.right.equalTo(backView2.mas_right).offset(-15);
    }];
    
    /// ********* 3 *********
    UIView *backView3 = [[UIView alloc] init];
    backView3.layer.cornerRadius = 5;
    backView3.layer.masksToBounds = YES;
    backView3.backgroundColor = [UIColor whiteColor];
    [footerBgView addSubview:backView3];
    
    [backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView2.mas_bottom).offset(mmHeight);
        make.left.equalTo(footerBgView.mas_left).offset(marWidht);
        make.right.equalTo(footerBgView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UIImageView *iconView3 = [[UIImageView alloc] init];
    iconView3.image = [UIImage imageNamed:@"pay_tx_txic"];
    [backView3 addSubview:iconView3];
    
    [iconView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    
    UILabel *titLabel33 = [[UILabel alloc] init];
    titLabel33.text = @"提现金额";
    titLabel33.font = [UIFont systemFontOfSize:15];
    titLabel33.textColor = [UIColor colorWithHex:@"#333333"];
    [backView3 addSubview:titLabel33];
    
    [titLabel33 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(iconView3.mas_right).offset(7);
        make.width.mas_equalTo(65);
    }];
    
    UIButton *maxBtn = [UIButton new];
    maxBtn.backgroundColor = [UIColor redColor];
    maxBtn.layer.cornerRadius = 5;
    maxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    maxBtn.layer.masksToBounds = YES;
    maxBtn.backgroundColor = [UIColor colorWithHex:@"#FF4444"];
    [maxBtn setTitle:@"最大" forState:UIControlStateNormal];
    
    [maxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [maxBtn addTarget:self action:@selector(onMaxBtn) forControlEvents:UIControlEventTouchUpInside];
    [backView3 addSubview:maxBtn];
    [maxBtn delayEnable];
    
    [maxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.centerY.equalTo(backView3.mas_centerY);
        make.right.equalTo(backView3.mas_right).offset(-15);
    }];
    
    UITextField *txMoneyTextField = [[UITextField alloc] init];
    //    textField.tag = 100;
    //     txMoneyTextField.backgroundColor = [UIColor redColor];  // 更改背景颜色
    txMoneyTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    txMoneyTextField.font = [UIFont boldSystemFontOfSize:15.0];  // 字体
    txMoneyTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    txMoneyTextField.placeholder = @"请输入提现金额"; // 占位文字
    txMoneyTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    txMoneyTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    txMoneyTextField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
    txMoneyTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [backView3 addSubview:txMoneyTextField];
    _txMoneyTextField = txMoneyTextField;
    [txMoneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titLabel33.mas_right).offset(20);
        make.right.equalTo(maxBtn.mas_left).offset(-15);
        make.centerY.equalTo(backView3.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    /// ********* 4 *********
    UIView *backView4 = [[UIView alloc] init];
    backView4.layer.cornerRadius = 5;
    backView4.layer.masksToBounds = YES;
    backView4.backgroundColor = [UIColor whiteColor];
    [footerBgView addSubview:backView4];
    
    [backView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView3.mas_bottom).offset(mmHeight);
        make.left.equalTo(footerBgView.mas_left).offset(marWidht);
        make.right.equalTo(footerBgView.mas_right).offset(-marWidht);
        make.height.mas_equalTo(cellHeight);
    }];
    
    UIImageView *iconView4 = [[UIImageView alloc] init];
    iconView4.image = [UIImage imageNamed:@"pay_tx_password"];
    [backView4 addSubview:iconView4];
    
    [iconView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(backView4.mas_left).offset(6);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    UILabel *titLabel4 = [[UILabel alloc] init];
    titLabel4.text = @"交易密码";
    titLabel4.font = [UIFont systemFontOfSize:15];
    titLabel4.textColor = [UIColor colorWithHex:@"#333333"];
    [backView4 addSubview:titLabel4];
    
    [titLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(iconView4.mas_right).offset(7);
        make.width.mas_equalTo(65);
    }];
    
    
    UIButton *pdIconBtn = [UIButton new];
    [pdIconBtn setImage:[UIImage imageNamed:@"pay_tx_pd_hid"] forState:UIControlStateNormal];
    [pdIconBtn addTarget:self action:@selector(onPdIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView4 addSubview:pdIconBtn];
    [pdIconBtn delayEnable];
    _pdIconBtn = pdIconBtn;
    
    [pdIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 14));
        make.centerY.equalTo(backView4.mas_centerY);
        make.right.equalTo(backView4.mas_right).offset(-15);
    }];
    
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    //    textField.tag = 100;
    //         passwordTextField.backgroundColor = [UIColor greenColor];  // 更改背景颜色
    passwordTextField.secureTextEntry = YES; // 密码
    passwordTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    passwordTextField.font = [UIFont boldSystemFontOfSize:15.0];  // 字体
    passwordTextField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    passwordTextField.placeholder = @"请输入交易密码"; // 占位文字
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    passwordTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    passwordTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    passwordTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [backView4 addSubview:passwordTextField];
    _passwordTextField = passwordTextField;
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(titLabel4.mas_right).offset(20);
        make.right.equalTo(pdIconBtn.mas_left).offset(-43);
        make.height.mas_equalTo(30);
    }];
    
    
    /// ********* 底下 *********
    
    UILabel *ttiNumLabel = [[UILabel alloc] init];
    ttiNumLabel.text = @"每日可提现次数: 5";
    ttiNumLabel.font = [UIFont systemFontOfSize:12];
    ttiNumLabel.textColor = [UIColor colorWithHex:@"#666666"];
    ttiNumLabel.textAlignment = NSTextAlignmentLeft;
    [footerBgView addSubview:ttiNumLabel];
    _ttiNumLabel = ttiNumLabel;
    
    [ttiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView4.mas_bottom).offset(5);
        make.left.equalTo(footerBgView.mas_left).offset(marWidht);
    }];
    
    UILabel *sxfMoneyLabel = [[UILabel alloc] init];
    sxfMoneyLabel.text = @"-";
    sxfMoneyLabel.font = [UIFont systemFontOfSize:12];
    sxfMoneyLabel.textColor = [UIColor redColor];
    sxfMoneyLabel.textAlignment = NSTextAlignmentRight;
    [footerBgView addSubview:sxfMoneyLabel];
    _sxfMoneyLabel = sxfMoneyLabel;
    
    [sxfMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView4.mas_bottom).offset(5);
        make.right.equalTo(footerBgView.mas_right).offset(-marWidht);
    }];
    
    UILabel *sxLabel = [[UILabel alloc] init];
    sxLabel.text = @"手续费:";
    sxLabel.font = [UIFont systemFontOfSize:12];
    sxLabel.textColor = [UIColor colorWithHex:@"#666666"];
    sxLabel.textAlignment = NSTextAlignmentRight;
    [footerBgView addSubview:sxLabel];
    
    [sxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView4.mas_bottom).offset(5);
        make.right.equalTo(sxfMoneyLabel.mas_left).offset(-5);
    }];
    
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"提现" forState:UIControlStateNormal];
    //    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_TX) forControlEvents:UIControlEventTouchUpInside];
    [footerBgView addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(backView4.mas_bottom).offset(50);
        make.left.equalTo(footerBgView.mas_left).offset(marWidht);
        make.right.equalTo(footerBgView.mas_right).offset(-marWidht);
    }];
    
    
    return footerBgView;
    
    
    
    
    
    
    
    
    //    WithdrawView *wdView = [[WithdrawView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    //
    //    [wdView initView];
    //    [wdView.selectBankBtn addTarget:self action:@selector(selectBankAction) forControlEvents:UIControlEventTouchUpInside];
    //    [wdView.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    //    self.wdView = wdView;
    //    self.wdView.bankIconImageView.image = nil;
    //    self.wdView.bankLabel.text = @"添加银行卡";
    //    self.wdView.textField.placeholder = [NSString stringWithFormat:@"最低提现额度%zd元",[[AppModel sharedInstance].commonInfo[@"cashdraw.money.min"] integerValue]];
    //
    //
    //    __weak __typeof(self)weakSelf = self;
    //    [wdView setDesIconBlock:^{
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        [strongSelf onScorllTextLableEvent:nil];
    //    }];
    //
    //    return self.wdView;
}





#pragma mark - 提现说明
- (void)onScorllTextLableEvent:(UITapGestureRecognizer *)gesture {
    [self withdrawalPopAlertView:self.withdrawalDesArray];
}

#pragma mark - 提现说明 弹框
- (void)withdrawalPopAlertView:(NSArray<SystemNotificationModel *> *)sysTextArray {
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

/**
 添加银行卡
 */
- (void)onHeadViewClickEvent {
    [self action_addBankCardBtn];
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
    [list observerSelected:^(WithdrawBankModel *model) {
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


- (NSMutableArray *)withdrawalDesArray {
    if (!_withdrawalDesArray) {
        _withdrawalDesArray = [NSMutableArray array];
    }
    return _withdrawalDesArray;
}
@end
