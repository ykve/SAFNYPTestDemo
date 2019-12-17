//
//  MeCollectionViewCell.m
//  WRHB
//
//  Created by AFan on 2019/11/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MeCollectionViewCell.h"

@interface MeCollectionViewCell ()

@end

@implementation MeCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"-"];
    [self addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(@(50));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
    }];
}


@end
