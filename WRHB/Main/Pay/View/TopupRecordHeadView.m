//
//  TopupRecordHeadView.m
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "TopupRecordHeadView.h"
#import "PayWithdrawalCenterController.h"

#define BIMGTAG 1000
#define BClickTAG 1000
#define BLABELTAG 2000
#define BSCAL 2.28

@implementation TopupRecordHeadView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    CGFloat widht = 70;
    CGFloat height = 70;
    NSArray *list = @[@"pay_calender_begin",@"pay_calender_end"];
    NSArray *titles = @[@"开始时间",@"结束时间"];
    
    for (NSInteger index = 0; index < list.count; index++) {
        UIButton *b = [self item:list[index] title:titles[index] frame:CGRectMake((1+widht + 15)*(index%2) +15, (1+height)*(index/2) + 20, widht, height)];
        b.tag = BClickTAG + index;
        [b addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        if(index == 0){
            UILabel *label = [b viewWithTag:BLABELTAG];
            self.balanceLabel = label;
        }
    }
    
    UILabel *allMoneyLabel = [[UILabel alloc] init];
    allMoneyLabel.text = @"-元";
    allMoneyLabel.textAlignment = NSTextAlignmentCenter;
    allMoneyLabel.font = [UIFont systemFontOfSize:23];
    allMoneyLabel.textColor = [UIColor colorWithHex:@"#404040"];
    [self addSubview:allMoneyLabel];
    _allMoneyLabel = allMoneyLabel;
    
    [allMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-30);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(165);
    }];
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"累计充值";
    titLabel.font = [UIFont systemFontOfSize:13];
    titLabel.textColor = [UIColor colorWithHex:@"#404040"];
    [self addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(allMoneyLabel.mas_left);
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
        make.top.equalTo(btn.mas_top);
        make.centerX.equalTo(btn);
        make.size.mas_equalTo(51);
    }];
    
    UILabel *label = [UILabel new];
    [btn addSubview:label];
    label.numberOfLines = 2;
    label.textColor = [UIColor colorWithHex:@"#404040"];
    label.font = [UIFont systemFontOfSize:12];
    label.tag = BLABELTAG;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left);
        make.right.equalTo(btn.mas_right);
        make.top.equalTo(imgView.mas_bottom).offset(0);
    }];
    
    return btn;
}

- (void)handle:(UIButton *)sender{
    if (sender.tag == BClickTAG+0) {//开始时间
        if (self.beginChange) {
            self.beginChange(nil);
        }
    } else if (sender.tag == BClickTAG+1) {//结束时间
        if (self.endChange) {
            self.endChange(nil);
        }
    }
}

- (void)setBeginTime:(NSString *)beginTime{
    _beginTime = beginTime;
    [self update:0+BClickTAG content:[NSString stringWithFormat:@"%@",beginTime]];
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    [self update:1+BClickTAG content:[NSString stringWithFormat:@"%@",endTime]];
}

- (void)update:(NSInteger)sender content:(NSString *)content{
    UIButton *btn = [self viewWithTag:sender];
    UILabel *label = [btn viewWithTag:BLABELTAG];
    label.text = content;
}

@end
