//
//  PriceCell.m
//  LotteryProduct
//
//  Created by vsskyblue on 2018/10/11.
//  Copyright © 2018年 vsskyblue. All rights reserved.
//

#import "PayAmountCell.h"
#import "UIView+AZGradient.h"   // 渐变色

@implementation PayAmountCell

-(UILabel *)pricelab {
    
    if (!_pricelab) {
        
        UILabel *pricelab = [[UILabel alloc] init];
        pricelab.text = @"-";
        pricelab.font = [UIFont systemFontOfSize:17];
        pricelab.textColor = [UIColor colorWithHex:@"#FF4444"];
        pricelab.numberOfLines = 0;
        pricelab.textAlignment = NSTextAlignmentCenter;
        pricelab.backgroundColor = [UIColor colorWithHex:@"#F7F6F9"];
        
        pricelab.layer.cornerRadius = 5;
//        pricelab.layer.borderColor = [UIColor greenColor].CGColor;
//        pricelab.layer.borderWidth = 0.5;
        pricelab.layer.masksToBounds = YES;
        [self addSubview:pricelab];
        _pricelab = pricelab;
    }
    return _pricelab;
}

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
}


-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (self.selected) {
        self.pricelab.backgroundColor = [UIColor colorWithHex:@"#FD8164"];
        // 渐变色
//        [self.pricelab az_setGradientBackgroundWithColors:@[COLOR_X(246, 83, 76),COLOR_X(253, 172, 105)] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        self.pricelab.textColor = [UIColor whiteColor];
        
    } else {
        self.pricelab.backgroundColor = [UIColor colorWithHex:@"#F7F6F9"];
        self.pricelab.textColor = [UIColor colorWithHex:@"#FF4444"];
    }
}

@end
