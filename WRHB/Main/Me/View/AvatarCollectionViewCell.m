//
//  AvatarCollectionViewCell.m
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AvatarCollectionViewCell.h"

@implementation AvatarCollectionViewCell

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
    headImageView.layer.cornerRadius = 5;
    headImageView.layer.masksToBounds = YES;
    [self addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    
    UIImageView *selectedImageView = [[UIImageView alloc] init];
    selectedImageView.image = [UIImage imageNamed:@"group_selected"];
    selectedImageView.hidden = YES;
    [headImageView addSubview:selectedImageView];
    _selectedImageView = selectedImageView;
    
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top).offset(0);
        make.right.equalTo(headImageView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

@end

