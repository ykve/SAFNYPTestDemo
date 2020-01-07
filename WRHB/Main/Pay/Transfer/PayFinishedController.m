//
//  PayFinishedController.m
//  WRHB
//
//  Created by AFan on 2020/1/3.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "PayFinishedController.h"

@interface PayFinishedController ()

@end

@implementation PayFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

}

- (void)onFinished {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.onFinishedBlock) {
        self.onFinishedBlock();
    }
}

- (void)setupUI {
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"pay_ts_finished"];
    [self.view addSubview:topImgView];
    
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.equalTo(@(60));
    }];
    
    UILabel *tLabel = [[UILabel alloc] init];
    tLabel.text = @"支付成功";
    tLabel.font = [UIFont boldSystemFontOfSize:15];
    tLabel.textColor = [UIColor redColor];
    [self.view addSubview:tLabel];
    
    [tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
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
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"完成" forState:UIControlStateNormal];
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
    
}

@end
