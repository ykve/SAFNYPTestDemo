//
//  ClubMemberDetailsCollectionCell.m
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberDetailsCollectionCell.h"

@interface ClubMemberDetailsCollectionCell ()

@end

@implementation ClubMemberDetailsCollectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = @"-";
    textLabel.font = [UIFont systemFontOfSize:18];
    textLabel.textColor = [UIColor colorWithHex:@"#222222"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:textLabel];
    _textLabel = textLabel;
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHex:@"#5B5B5B"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
    }];
}


@end

