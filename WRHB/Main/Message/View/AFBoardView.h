//
//  AFBoardView.h
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFMarqueeModel;
@interface AFBoardView : UIView

-(instancetype)initWithFrame:(CGRect)frame Model:(AFMarqueeModel *)model;

@property (nonatomic, copy) void (^boardItemClick)(AFMarqueeModel *model);
@property (nonatomic, strong) UILabel *titleLb;

@end
