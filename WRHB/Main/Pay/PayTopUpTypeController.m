//
//  PayTopUpTypeController.m
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopUpTypeController.h"
#import "JXCategoryTitleView.h"
#import "BillTypeModel.h"
#import "BillViewController.h"
#import "PayTopupRecordController.h"


@interface PayTopUpTypeController ()
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation PayTopUpTypeController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    
    JXCategoryTitleView *titleCategoryView = (JXCategoryTitleView *)self.categoryView;
    titleCategoryView.titleColor = [UIColor colorWithHex:@"#666666"];
    titleCategoryView.titleSelectedColor = [UIColor whiteColor];
    //    titleCategoryView
    titleCategoryView.titleColorGradientEnabled = YES;
    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
    //    backgroundView.backgroundColor = [UIColor redColor];
    backgroundView.indicatorColor = [UIColor redColor];
    backgroundView.indicatorWidth = 100;
    backgroundView.indicatorHeight = 32;
    backgroundView.indicatorCornerRadius = JXCategoryViewAutomaticDimension;
    titleCategoryView.indicators = @[backgroundView];
    
    if (self.titles == nil) {
        self.titles = @[@"网关充值", @"官方充值", @"盈商充值"];
    }
    
    
    
    [super viewDidLoad];
    self.navigationItem.title = @"充值中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = YES;
    //    doneButton.layer.cornerRadius = 3;
    //    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    //    doneButton.frame = CGRectMake(0, 0, 56, 30);
    [doneButton setTitle:@"充值记录" forState:UIControlStateNormal];
    //    [doneButton setTintColor:[UIColor colorWithHex:@"#333333"]];
    [doneButton setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(onTopupRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    self.myCategoryView.titles = self.titles;
}

/**
 充值记录
 */
- (void)onTopupRecord {
    BillTypeModel *model = [[BillTypeModel alloc] init];
    model.title = @"充值记录";
    model.category = 11;
    
    
//    PayTopupRecordController
    PayTopupRecordController *vc = [[PayTopupRecordController alloc] init];
    vc.title = model.title;
    vc.sourceType = 2;
    vc.billTypeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}




@end
