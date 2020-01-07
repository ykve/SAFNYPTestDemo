//
//  ReportCell.m
//  WRHB
//
//  Created AFan on 2019/9/9.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ReportCell.h"
#import "ReportFormsView.h"

@implementation ReportCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)setModel:(ReportFormsItem *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.moneyLabel.text = model.desc;
    
    self.desLabel.hidden = YES;
    if (model.desc2.length > 0) {
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backView.mas_centerY).offset(-12);
        }];
        self.desLabel.text = model.desc2;
        self.desLabel.hidden = NO;
    }
    
    if (model.isShowDesBtn) {
        self.ddsLabel.hidden = NO;
    }
}

-(void)initView {
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor colorWithHex:@"#FFE7E7"];
    [self.contentView addSubview:backView];
    _backView = backView;
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIImageView *topIcon = [[UIImageView alloc] init];
    topIcon.image = [UIImage imageNamed:@"sub_des_icon"];
    [self.contentView addSubview:topIcon];
    [topIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(104.5, 27.5));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topIcon addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topIcon.mas_centerX);
         make.centerY.equalTo(topIcon.mas_centerY).offset(-3);
    }];
    
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    moneyLabel.font = [UIFont systemFontOfSize:22];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView.mas_centerY).offset(2);
    }];
    _moneyLabel = moneyLabel;
    
    
    _desLabel = [[UILabel alloc] init];
    _desLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    _desLabel.font = [UIFont systemFontOfSize:22];
    _desLabel.hidden = YES;
    _desLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
    }];
    
    UILabel *ddsLabel = [[UILabel alloc] init];
//    ddsLabel.text = @"*点击可查看详情";
    ddsLabel.hidden = YES;
    ddsLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    ddsLabel.font = [UIFont systemFontOfSize:11];
    ddsLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:ddsLabel];
    [ddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.bottom.equalTo(backView.mas_bottom).offset(-3);
    }];
    _ddsLabel = ddsLabel;
}
@end
