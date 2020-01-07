//
//  PayConfirmReceController.m
//  WRHB
//
//  Created by AFan on 2020/1/5.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "PayConfirmReceController.h"
#import "PayFinishedController.h"
#import "TransferModel.h"
#import "NSDate+DaboExtension.h"
#import "SPAlertController.h"
#import "ChatMessagelLayout.h"
#import "YPIMManager.h"
#import "PayTransferLookController.h"

@interface PayConfirmReceController ()
@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *twoDateLabel;
@end

@implementation PayConfirmReceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self setupUI];
    [self setInfoData];
}

- (void)setInfoData {
    
//    self.nameLabel.text = self.model.sendName;
     self.nameLabel.hidden = YES;
    self.moneyLabel.text = self.model.money;
    NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
    
    
    if (self.model.cellStatus == TransferCellStatus_Normal) {
        //        self.twoDateLabel.hidden = YES;
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_waitconfirm"];
        self.dateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
    } else if (self.model.cellStatus == TransferCellStatus_MyselfReceived) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_ok"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"收款时间:%@", dateStr];
        
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
    } else if (self.model.cellStatus == TransferCellStatus_Refund) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_return"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        
        self.dateLabel.text = [NSString stringWithFormat:@"退还时间:%@", dateStr];
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
    } else if (self.model.cellStatus == TransferCellStatus_Expire) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_expire"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        
        self.dateLabel.text = [NSString stringWithFormat:@"退还时间:%@", dateStr];
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
    }
    
}


- (void)onReturnBtn {
    
    NSString *msg = [NSString stringWithFormat:@"是否退还 %@ 的转账", self.model.sendName];
    
        SPAlertController *alertController = [SPAlertController alertControllerWithTitle:@"提醒" message:msg preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
        //    alertController.needDialogBlur = _lookBlur;
        
        __weak __typeof(self)weakSelf = self;
        
        SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"退还" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSLog(@"点击了确定");
            [strongSelf transferReturn];
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

#pragma mark - 转账领取
- (void)transferPickup {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"transfer/obtain"];
    NSDictionary *parameters = @{
                                 @"id":@(self.model.transfer)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            ///
            strongSelf.model.cellStatus = TransferCellStatus_MyselfReceived;
            
            [strongSelf transferGotoVC];
            
            [strongSelf updateTransferStatus];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
        
    } progressBlock:nil];
    
}

#pragma mark - 转账退还
- (void)transferReturn {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"transfer/refuse"];
    NSDictionary *parameters = @{
                                 @"id":@(self.model.transfer)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    
    //    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            ///
            strongSelf.model.cellStatus = TransferCellStatus_Refund;
            [strongSelf transferGotoVC];
            [strongSelf updateTransferStatus];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
        
    } progressBlock:nil];
    
}

- (void)transferGotoVC {
    PayTransferLookController *vc = [[PayTransferLookController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateTransferStatus {
    
    [[YPIMManager sharedInstance] updateTransferInfo:self.model];
}

- (void)onFinished {
    
    [self transferPickup];
    
//    [self dismissViewControllerAnimated:NO completion:nil];
//    if (self.onFinishedBlock) {
//        self.onFinishedBlock();
//    }
}

- (void)setupUI {
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"pay_ts_finished"];
    [self.view addSubview:topImgView];
    _topImgView = topImgView;
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.equalTo(@(60));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(80);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont boldSystemFontOfSize:42];
    moneyLabel.textColor = [UIColor colorWithHex:@"#343434"];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX).offset(20);
    }];
    
    UILabel *sLabel = [[UILabel alloc] init];
    sLabel.text = @"￥";
    sLabel.font = [UIFont boldSystemFontOfSize:32];
    sLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [self.view addSubview:sLabel];
    
    [sLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moneyLabel.mas_left).offset(-2);
        make.centerY.equalTo(moneyLabel.mas_centerY);
    }];
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.text = @"待确认收款";
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textColor = [UIColor colorWithHex:@"#000000"];
    [self.view addSubview:tLabel];
    
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(moneyLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"确认收款" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    //    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onFinished) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn delayEnable];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_centerY).offset(100);
        make.size.mas_equalTo(CGSizeMake(160, 50));
    }];
    
    UILabel *tiLabel = [[UILabel alloc] init];
    tiLabel.text = @"1天内未确认，将退还给对方。";
    tiLabel.font = [UIFont systemFontOfSize:15];
    tiLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [self.view addSubview:tiLabel];
    
    [tiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(submitBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX).offset(-30);
    }];
    
    UIButton *returnBtn = [UIButton new];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    returnBtn.backgroundColor = [UIColor clearColor];
    [returnBtn setTitle:@"立即退还" forState:UIControlStateNormal];
    
    [returnBtn setTitleColor:[UIColor colorWithHex:@"#FF4444"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(onReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    [submitBtn delayEnable];
    
    [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tiLabel.mas_centerY);
        make.left.equalTo(tiLabel.mas_right).offset(3);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"转账时间: 0000-00-00 00:00";
    dateLabel.font = [UIFont systemFontOfSize:12];
    dateLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [self.view addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

@end

