//
//  MeTopViewTowLabel.m
//  WRHB
//
//  Created by AFan on 2019/11/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MeTopViewTowLabel.h"

@implementation MeTopViewTowLabel

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = @"-";
    valueLabel.font = [UIFont systemFontOfSize:11];
    valueLabel.textColor = [UIColor colorWithHex:@"#E55E5E"];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
    _valueLabel = valueLabel;
    
    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(2);
        make.centerX.equalTo(self.mas_centerX);
    }];
}

@end
