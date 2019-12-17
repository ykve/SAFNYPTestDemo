//
//  GameItemSelectedCollViewCell.m
//  WRHB
//
//  Created by AFan on 2019/11/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "GameItemSelectedCollViewCell.h"

@implementation GameItemSelectedCollViewCell

- (void)dealloc {
    NSLog(@"1");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"game_redpacket_bg"];
    backImageView.layer.cornerRadius = 5;
    backImageView.layer.masksToBounds = YES;
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:titleLabel];
    _titleLabel = titleLabel;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView.mas_centerX);
        make.top.equalTo(backImageView.mas_top).offset(15);
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 30));
    }];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"-";
    contentLabel.font = [UIFont systemFontOfSize:24];
    contentLabel.textColor = [UIColor colorWithHex:@"#FFF664"];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView.mas_centerX);
        make.centerY.equalTo(backImageView.mas_centerY).offset(0);
        //        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 30));
    }];
    
    //创建一个滚动文字的label
    JJScorllTextLable *deslabel = [[JJScorllTextLable alloc] init];
    //    label.text = @"设置滚动文字的内容";   //设置滚动文字的内容
    deslabel.font = [UIFont systemFontOfSize:13];
    deslabel.textColor = [UIColor whiteColor];
    deslabel.rate = 0.3;
    [backImageView addSubview:deslabel]; //把滚动文字的lable加到视图
    _scorllTextLable = deslabel;
    //    label.backgroundColor= [UIColor redColor];
    
    
    [deslabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(5);
        make.left.equalTo(backImageView.mas_left).offset(15);
        make.right.equalTo(backImageView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    
    
    UILabel *btnLabel = [[UILabel alloc] init];
    btnLabel.text = @"开始游戏";
    btnLabel.font = [UIFont systemFontOfSize:14];
    btnLabel.textColor = [UIColor colorWithHex:@"#A64920"];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.layer.cornerRadius = 35/2;
    btnLabel.layer.masksToBounds = YES;
    btnLabel.backgroundColor = [UIColor colorWithHex:@"#FFC55E"];
    [backImageView addSubview:btnLabel];
    
    [btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(backImageView.mas_centerX);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-10);
        make.left.equalTo(backImageView.mas_left).offset(20);
        make.right.equalTo(backImageView.mas_right).offset(-20);
        make.height.mas_equalTo(35);
    }];
}

@end
