//
//  AFBoardView.m
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019年 AFan. All rights reserved.
//

#import "AFBoardView.h"
#import "AFMarqueeModel.h"
#import "UIImageView+WebCache.h"

@interface AFBoardView ()

@property (nonatomic, strong) AFMarqueeModel *model;

@property (nonatomic, strong) UIImageView *headImgView;

@end

@implementation AFBoardView

-(instancetype)initWithFrame:(CGRect)frame Model:(AFMarqueeModel *)model{
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
//    self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
//    self.headImgView.layer.masksToBounds = YES;
//    self.headImgView.layer.cornerRadius = 15;
//    [self addSubview:self.headImgView];
//    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.model.userImg] placeholderImage: [UIImage imageNamed:@"UserBitmap"]];
    
    self.titleLb = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.model.titleWidth, self.frame.size.height)];
    self.titleLb.font = [UIFont systemFontOfSize:12];
    self.titleLb.textColor = [UIColor redColor];
    self.titleLb.text = self.model.title;
    [self addSubview:self.titleLb];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClickAction)]];
}

-(void)itemClickAction{
    if (self.boardItemClick) {
        self.boardItemClick(self.model);
    }
}
@end
