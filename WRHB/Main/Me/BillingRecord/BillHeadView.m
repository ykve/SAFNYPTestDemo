//
//  BillHeadView.m
//  WRHB
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "BillHeadView.h"
#import "PayWithdrawalCenterController.h"

#define BIMGTAG 1000
#define BClickTAG 1000
#define BLABELTAG 2000
#define BSCAL 2.28

@implementation BillHeadView



+ (BillHeadView *)headView:(BOOL)isAll{
    CGFloat w = (kSCREEN_WIDTH-1)/2;
    CGFloat h = w / BSCAL + 15;
    NSInteger n = 1;
    if(isAll)
        n = 1;
    BillHeadView *headView = [[BillHeadView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, h*n+2 + 25) isAll:isAll];
    return headView;
}

- (instancetype)initWithFrame:(CGRect)frame isAll:(BOOL)isAll{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAll = isAll;
        [self setupSubViews];
    }
    return self;
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    CGFloat w = (kSCREEN_WIDTH-1)/2;
    CGFloat h = w / BSCAL + 15;
    NSArray *list = @[@"me_bill_calender_begin",@"me_bill_calender_end"];
    NSArray *titles = @[@"开始时间:",@"结束时间:"];
    NSArray *tags = @[@0,@1];
    
    NSInteger allInt = 0;
    if(self.isAll) {
        allInt = 2;
    }
    for (NSInteger index = allInt; index < list.count; index++) {
        NSInteger m = index - allInt;
        UIButton *b = [self item:list[index] title:titles[index] frame:CGRectMake((1+w)*(m%2), (1+h)*(m/2), w, h)];
        b.tag = BClickTAG + [tags[index] integerValue];
        [b addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        if(index == 0){
            UILabel *label = [b viewWithTag:BLABELTAG];
            self.balanceLabel = label;
        }
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =  [UIColor colorWithHex:@"#F7F7F7"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
    
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"账单记录";
    titLabel.font = [UIFont systemFontOfSize:13];
    titLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [self addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    
    UILabel *allMoneyLabel = [[UILabel alloc] init];
    allMoneyLabel.text = @"-元";
    allMoneyLabel.font = [UIFont systemFontOfSize:13];
    allMoneyLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [self addSubview:allMoneyLabel];
    _allMoneyLabel = allMoneyLabel;
    
    [allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    UILabel *ttLabel = [[UILabel alloc] init];
    ttLabel.text = @"累计:";
    ttLabel.font = [UIFont systemFontOfSize:13];
    ttLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [self addSubview:ttLabel];
    
    [ttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.right.equalTo(allMoneyLabel.mas_left).offset(-1);
    }];
} 

- (UIButton *)item:(NSString *)img title:(NSString *)title frame:(CGRect)rect{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [UIImageView new];
    [btn addSubview:imgView];
    imgView.image = [UIImage imageNamed:img];
    imgView.tag = BIMGTAG;
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn.mas_top).offset(33);
    }];
    
    UILabel *label = [UILabel new];
    [btn addSubview:label];
    label.textColor = Color_3;
    label.font = [UIFont systemFontOfSize2:14];
    label.numberOfLines = 0;
    label.tag = BLABELTAG;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left).offset(4);
        make.right.equalTo(btn.mas_right).offset(-4);
        make.top.equalTo(imgView.mas_bottom).offset(0);
    }];
    
    return btn;
}

- (void)handle:(UIButton *)sender{
    if (sender.tag == BClickTAG+0) {//开始时间
        if (self.beginChange) {
            self.beginChange(nil);
        }
    }
    else if (sender.tag == BClickTAG+1) {//结束时间
        if (self.endChange) {
            self.endChange(nil);
        }
    }
    else if (sender.tag == BClickTAG+1) {//类型
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i = 0; i < self.billTypeList.count; i ++) {
            NSDictionary *dic = self.billTypeList[i];
            [arr addObject:dic[@"title"]];
        }
    } else if(sender.tag == BClickTAG + 5){
        PayWithdrawalCenterController *vc = [[PayWithdrawalCenterController alloc] init];
        [[[FunctionManager sharedInstance] currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setBeginTime:(NSString *)beginTime{
    _beginTime = beginTime;
    [self update:0+BClickTAG content:[NSString stringWithFormat:@"开始时间：%@",beginTime]];
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self update:1+BClickTAG content:[NSString stringWithFormat:@"结束时间：%@",endTime]];
}

- (void)update:(NSInteger)sender content:(NSString *)content{
    UIButton *btn = [self viewWithTag:sender];
    UILabel *label = [btn viewWithTag:BLABELTAG];
    label.text = content;
}

@end
