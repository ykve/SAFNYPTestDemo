//
//  BillHeadView.m
//  WRHB
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "ReportHeaderView.h"

#define BIMGTAG 1000
#define BClickTAG 1000
#define BLABELTAG 2000
#define BLABELTAG3 3000
#define BSCAL 2.28

@implementation ReportHeaderView


+ (ReportHeaderView *)headView{
    ReportHeaderView *headView = [[ReportHeaderView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, (kSCREEN_WIDTH/2) * 0.55)];
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}



#pragma mark ----- subView
- (void)setupSubViews {
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.userInteractionEnabled = YES;
//    backImageView.image = [UIImage imageNamed:@"agent_report_top_bg"];
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    CGFloat w = (kSCREEN_WIDTH-1)/2;
    CGFloat h = 50;
    NSArray *list = @[@"pay_calender_begin",@"pay_calender_end"];
    NSArray *titles = @[@"开始时间",@"结束时间"];
    NSArray *dates = @[@"",@""];
    for (int i = 0; i<list.count; i++) {
        UIButton *b = [self item:list[i] title:titles[i] date:dates[i] frame:CGRectMake((1+w)*(i%2), (1+h)*(i/2), w, h)];
        b.tag = BClickTAG + i;
        [b addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
        [backImageView addSubview:b];
    }
} 

- (UIButton *)item:(NSString *)img title:(NSString *)title date:(NSString *)date frame:(CGRect)rect {
    
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = [UIColor clearColor];
    UIImageView *imgView = [UIImageView new];
    [btn addSubview:imgView];
    imgView.image = [UIImage imageNamed:img];
    imgView.tag = BIMGTAG;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left).offset(20);
        make.centerY.equalTo(btn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(51, 51));
    }];
    
    UILabel *titleLabel = [UILabel new];
    [btn addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.font = [UIFont systemFontOfSize2:14];
    titleLabel.numberOfLines = 0;
    titleLabel.tag = BLABELTAG;
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.top.equalTo(imgView.mas_top).offset(8);
    }];
    
    UILabel *dateLabel = [UILabel new];
    [btn addSubview:dateLabel];
    dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    dateLabel.font = [UIFont systemFontOfSize2:11];
    dateLabel.numberOfLines = 0;
    dateLabel.tag = BLABELTAG3;
    dateLabel.text = title;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(5);
        make.bottom.equalTo(imgView.mas_bottom).offset(-8);
    }];
    
    return btn;
}

- (void)handle:(UIButton *)sender{
    if (sender.tag == BClickTAG) {//开始时间
        if (self.beginChange) {
            self.beginChange(nil);
        }
    }
    else if (sender.tag == BClickTAG+1) {//结束时间
        if (self.endChange) {
            self.endChange(nil);
        }
    }
}

- (void)setBeginTime:(NSString *)beginTime{
    _beginTime = beginTime;
    [self update:BClickTAG content:beginTime];
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self update:1+BClickTAG content:endTime];
}

- (void)update:(NSInteger)sender content:(NSString *)content{
    UIButton *btn = [self viewWithTag:sender];
    UILabel *dateLabel = [btn viewWithTag:BLABELTAG3];
    dateLabel.text = content;
}

@end
