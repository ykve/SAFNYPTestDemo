//
//  CopyCell.m
//  WRHB
//
//  Created by AFan on 2019/4/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CopyCell.h"
#import "UIView+AZGradient.h"  // 渐变色
@implementation CopyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initView {
    
    self.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    
    
//    UIView *containView = [[UIView alloc] init];
//    containView.backgroundColor = [UIColor whiteColor];
//    containView.layer.masksToBounds = YES;
//    containView.layer.cornerRadius = 8;
//    [self addSubview:containView];
//    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.right.equalTo(self).offset(-10);
//        make.top.equalTo(self.mas_top).offset(5);
//        make.bottom.equalTo(self.mas_bottom).offset(-5);
//    }];
    
//    UILabel *numLabel = [[UILabel alloc] init];
//    numLabel.textColor = [UIColor whiteColor];
//    numLabel.font = [UIFont systemFontOfSize:11];
//    numLabel.textAlignment = NSTextAlignmentCenter;
//    numLabel.layer.masksToBounds = YES;
//    numLabel.layer.cornerRadius = 10;
//    [numLabel az_setGradientBackgroundWithColors:@[COLOR_X(253, 172, 105),COLOR_X(246, 83, 76)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
//    [containView addSubview:numLabel];
//    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(containView).offset(8);
//        make.width.height.equalTo(@20);
//    }];
//    self.numLabel = numLabel;
    
    UIButton *copyButton = [UIButton new];
    [self.contentView addSubview:copyButton];
    copyButton.titleLabel.font = [UIFont systemFontOfSize2:14];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 5;
    [copyButton az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
         make.top.equalTo(self.contentView.mas_top).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.equalTo(@60);
    }];
    [copyButton addTarget:self action:@selector(onCopyAction) forControlEvents:UIControlEventTouchUpInside];
    self.copBtn = copyButton;
    
    CGFloat marginWidth = 10;
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"pop_cellbg"];
    [self.contentView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(marginWidth);
        make.right.equalTo(copyButton.mas_left).offset(-marginWidth);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize2:16];
    textLabel.textColor = COLOR_X(80, 80, 80);
    textLabel.numberOfLines = 0;
    [backImageView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backImageView.mas_left).offset(marginWidth);
        make.centerY.equalTo(backImageView.mas_centerY);
        make.right.equalTo(backImageView.mas_right).offset(-marginWidth);
        make.bottom.equalTo(backImageView.mas_bottom).offset(-marginWidth);
    }];
    self.tLabel = textLabel;
    
    
    
    
}

-(void)setIndex:(NSInteger)index{
    self.numLabel.text = INT_TO_STR(index);
    NSInteger topY = 5;
    if(index == 1)
        topY = 0;
    [self.numLabel.superview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(topY);
        make.bottom.equalTo(self).offset(-5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)onCopyAction{
    NSString *s = self.tLabel.text;
    if(s.length == 0)
        s = @"";
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = s;
    [MBProgressHUD showSuccessMessage:@"复制成功"];
}
@end
