//
//  TestViewController.m
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/8.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "TitleViewController.h"
#import "JXCategoryTitleView.h"

@interface TitleViewController ()

@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@end

@implementation TitleViewController

- (void)viewDidLoad {
    if (self.titles == nil) {
        self.titles = @[@"百家乐", @"三公", @"苹果"];
    }

    [super viewDidLoad];

    self.myCategoryView.titles = self.titles;
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

@end
