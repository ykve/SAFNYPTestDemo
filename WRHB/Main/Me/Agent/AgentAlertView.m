//
//  AgentAlertView.m
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AgentAlertView.h"

@interface AgentAlertView ()

@end

@implementation AgentAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"me_agent_alert_bg"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
//        make.left.equalTo(self.mas_left).offset(25);
//        make.left.equalTo(self.mas_left).offset(-25);
//        make.height.mas_equalTo(293);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您还不是代理，是否申请代理？";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:titleLabel];
//    _nameLabel = nameLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView.mas_centerX);
        make.centerY.equalTo(backImageView.mas_centerY).offset(20);
    }];
    
    UIButton *cancelBtn = [UIButton new];
    [backImageView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:@"#9494A0"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left);
        make.right.equalTo(backImageView.mas_centerX);
        make.bottom.equalTo(backImageView.mas_bottom);
        make.height.equalTo(@(50));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#D1D1DA"];
    [backImageView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backImageView.mas_bottom).offset(-5);
        make.left.equalTo(cancelBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(0.7, 40));
    }];
    
    
    UIButton *okBtn = [UIButton new];
    [backImageView addSubview:okBtn];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHex:@"#FF4444"] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right);
        make.right.equalTo(backImageView.mas_right);
        make.bottom.equalTo(backImageView.mas_bottom);
        make.height.equalTo(@(50));
    }];
    
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor colorWithHex:@"#D1D1DA"];
    [backImageView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(okBtn.mas_top);
        make.left.equalTo(backImageView.mas_left);
        make.right.equalTo(backImageView.mas_right);
        make.height.mas_equalTo(0.7);
    }];
}

- (void)cancelBtn {
    if (self.alertBlock) {
        self.alertBlock(0);
    }
}

- (void)okBtn {
    if (self.alertBlock) {
        self.alertBlock(1);
    }
}



@end
