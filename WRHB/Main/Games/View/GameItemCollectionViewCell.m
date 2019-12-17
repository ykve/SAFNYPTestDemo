//
//  GameItemCollectionViewCell.m
//  WRHB
//
//  Created by AFan on 2019/11/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "GameItemCollectionViewCell.h"
#import "FLAnimatedImageView.h"

@implementation GameItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    FLAnimatedImageView *headImageView = [[FLAnimatedImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"-"];
    headImageView.layer.cornerRadius = 5;
    headImageView.layer.masksToBounds = YES;
    [self addSubview:headImageView];
    _headImageView = headImageView;
    
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"-";
//    titleLabel.font = [UIFont systemFontOfSize:13];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.layer.cornerRadius = 5;
//    titleLabel.layer.masksToBounds = YES;
//    titleLabel.numberOfLines = 2;
//    titleLabel.backgroundColor = [UIColor colorWithHex:@"#FB300F"];
//    [self addSubview:titleLabel];
//    _titleLabel = titleLabel;
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(self.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 30));
//    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
//        make.top.equalTo(self.mas_top);
//        make.centerX.equalTo(self.mas_centerX);
//        make.bottom.equalTo(titleLabel.mas_top).offset(-5);
//        make.width.mas_equalTo(self.frame.size.width);
    }];
}

@end
