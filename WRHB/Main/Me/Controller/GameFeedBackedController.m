//
//  GameFeedBackedViewController.m
//  WRHB
//
//  Created by John on 2020/1/6.
//  Copyright © 2020 AFan. All rights reserved.
//

#import "GameFeedBackedController.h"
#import "GameFeedbackController.h"
@interface GameFeedBackedController ()

@end

@implementation GameFeedBackedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self initUI];
    [self removeLastVC];
    // Do any additional setup after loading the view.
}

- (void)initUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor clearColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.mas_equalTo(kSCREEN_HEIGHT);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"me_feedback"];
    [contentView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(134);
        make.height.mas_equalTo(147.5);
        make.centerX.equalTo(contentView);
        make.top.mas_equalTo(40);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"留言成功";
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightHeavy];
    titleLabel.textColor = Gray_333333;
    [contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(34);
        make.centerX.equalTo(contentView);
        make.height.mas_equalTo(21.5);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"非常感谢您的支持，我们会尽快联系您";
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    subTitleLabel.textColor = Gray_333333;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:subTitleLabel];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(25.5);
        make.height.mas_equalTo(16);
        make.centerX.equalTo(contentView);
    }];
    
}

- (void)removeLastVC
{
    if (self.navigationController.viewControllers.count >= 3) {//viewControllers.count大于3 才有中间页面
        NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    
        NSMutableArray *arrRemove = [NSMutableArray array];
        for (UIViewController *vc in array) {
            //判断需要销毁的控制器 加入数组
            if ([vc isKindOfClass:[GameFeedbackController class]]) {
                [arrRemove addObject:vc];
            }
        }
    
        if (arrRemove.count) {
            [array removeObjectsInArray:arrRemove];
            [self.navigationController setViewControllers:array animated:NO];
        }
   }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
