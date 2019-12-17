//
//  PayTypeCell.m
//  LotteryProduct
//
//  Created by vsskyblue on 2018/10/11.
//  Copyright © 2018年 vsskyblue. All rights reserved.
//

#import "PayItemCell.h"

@implementation PayItemCell

-(UIImageView *)iconImageView {
    
    if (!_iconImageView) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
    
}

-(UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"-";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithHex:@"#FFF6DF"];
        _bgView.layer.borderWidth = 1;
        _bgView.layer.borderColor = [UIColor colorWithHex:@"#F4E3CF"].CGColor;
        _bgView.layer.cornerRadius = 5.0;
        [self addSubview:_bgView];
        [self sendSubviewToBack:_bgView];
        _bgView.hidden = YES;
//        self
    }
    return _bgView;
}

-(UIImageView *)maskImageView {
    
    if (!_maskImageView) {
        
        _maskImageView = [[UIImageView alloc] init];
//        _maskImageView.backgroundColor = [UIColor redColor];
        _maskImageView.layer.borderWidth = 1;
        _maskImageView.layer.borderColor = [UIColor colorWithHex:@"#F4E3CF"].CGColor;
        _maskImageView.layer.cornerRadius = 5.0;
        [self addSubview:_maskImageView];
        
//        _maskImageView.hidden = YES;
    }
    return _maskImageView;
}



-(void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(12);
        make.centerX.equalTo(self);
        make.width.offset(35);
        make.height.offset(30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
        make.height.offset(16);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
        make.right.equalTo(self).offset(-2);
    }];
    
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
        make.right.equalTo(self).offset(-2);
    }];

}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (self.selected) {
        self.bgView.hidden = NO;
    } else {
        self.bgView.hidden = YES;
    }
}

@end
