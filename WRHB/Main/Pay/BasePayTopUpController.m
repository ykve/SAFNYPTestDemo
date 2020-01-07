//
//  BasePayTopUpController.m
//  WRHB
//
//  Created by John on 2020/1/5.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "BasePayTopUpController.h"

@interface BasePayTopUpController ()

@end

@implementation BasePayTopUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showPlaceholderDefaultView {
    if (self.dataArray == nil || self.dataArray.count == 0) {
        if (self.placeholderView.superview == nil) {
            [self.tableView addSubview:self.placeholderView];
            [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.tableView);
                make.centerY.mas_equalTo(self.tableView);
                make.width.mas_equalTo(254);
                make.height.mas_equalTo(240);
            }];
        }
        
    }else {
        [self.placeholderView removeFromSuperview];
    }
    
    
}

-(UIView*)placeholderView
{
    if (_placeholderView == nil) {
        _placeholderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 254, 240)];
        _placeholderView.backgroundColor = [UIColor clearColor];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(18.5, 0, 225.5, 188.5)];
        img.image = [UIImage imageNamed:@"pay_placeHold"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 202, 254, 37)];
        label.textColor = Gray_999999;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        label.text = @"充值页面走丢啦，过会儿再来看看吧";
        label.adjustsFontSizeToFitWidth = YES;
        [_placeholderView addSubview:img];
        [_placeholderView addSubview:label];
    }
    return _placeholderView;
}

@end
