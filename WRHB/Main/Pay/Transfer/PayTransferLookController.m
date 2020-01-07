//
//  PayTransferLookController.m
//  WRHB
//
//  Created by AFan on 2020/1/5.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "PayTransferLookController.h"
#import "TransferModel.h"
#import "NSDate+DaboExtension.h"


@interface PayTransferLookController ()

@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *twoDateLabel;
@property (nonatomic, strong) UILabel *tLabel;

@end

@implementation PayTransferLookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self setupUI];
    [self setInfoData];
}



- (void)setInfoData {
   
    self.nameLabel.text = self.model.sendName;
     self.moneyLabel.text = self.model.money;
     NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
     
    
    if (self.model.cellStatus == TransferCellStatus_Normal) {
        self.twoDateLabel.hidden = YES;
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_waitconfirm"];
        self.dateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
        self.nameLabel.text = [NSString stringWithFormat:@"待 %@ 收款", self.model.receiveName];
    } else if (self.model.cellStatus == TransferCellStatus_MyselfReceived) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_ok"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        self.dateLabel.text = [NSString stringWithFormat:@"收款时间:%@", dateStr];
        
        if (self.model.send_Id == [AppModel sharedInstance].user_info.userId) {
            self.nameLabel.text = [NSString stringWithFormat:@"%@ 已收款", self.model.receiveName];
        } else {
            self.nameLabel.text = @"已收款";
        }
        
        self.tLabel.hidden = YES;
        
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
    } else if (self.model.cellStatus == TransferCellStatus_Refund) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_return"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        
        self.dateLabel.text = [NSString stringWithFormat:@"退还时间:%@", dateStr];
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
        
        self.nameLabel.text = @"已退还";
        self.tLabel.hidden = YES;
    } else if (self.model.cellStatus == TransferCellStatus_Expire) {
        self.topImgView.image = [UIImage imageNamed:@"pay_ts_expire"];
        self.twoDateLabel.hidden = NO;
        
        NSString *dateStr = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%lld",self.model.sendTime] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
        
        self.dateLabel.text = [NSString stringWithFormat:@"退还时间:%@", dateStr];
        self.twoDateLabel.text = [NSString stringWithFormat:@"转账时间:%@", dateStr];
      
        self.nameLabel.text = @"已退还（过期）";
        self.tLabel.hidden = YES;
    }
    
}

- (void)onFinished {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.onFinishedBlock) {
        self.onFinishedBlock();
    }
}

- (void)setupUI {
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"pay_ts_waitconfirm"];
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
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
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
    tLabel.text = @"1天内朋友未确认，将退还给你";
    tLabel.font = [UIFont systemFontOfSize:15];
    tLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [self.view addSubview:tLabel];
    _tLabel = tLabel;
    
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
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
    
    UILabel *twoDateLabel = [[UILabel alloc] init];
    twoDateLabel.text = @"转账时间: 0000-00-00 00:00";
    twoDateLabel.font = [UIFont systemFontOfSize:12];
    twoDateLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [self.view addSubview:twoDateLabel];
    _twoDateLabel = twoDateLabel;
    
    [twoDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(dateLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
//    UIButton *submitBtn = [UIButton new];
//    submitBtn.layer.cornerRadius = 50/2;
//    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
//    submitBtn.layer.masksToBounds = YES;
//    submitBtn.backgroundColor = [UIColor clearColor];
//    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
//        [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
////    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
//
//    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(onFinished) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:submitBtn];
//    [submitBtn delayEnable];
//
//    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.view.mas_centerY).offset(100);
//        make.size.mas_equalTo(CGSizeMake(160, 50));
//    }];
    
}

@end

