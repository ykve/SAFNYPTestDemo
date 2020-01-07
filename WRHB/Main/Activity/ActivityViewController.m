//
//  ActivityViewController.m
//  WRHB
//
//  Created AFan on 2019/9/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityView.h"

@interface ActivityViewController ()
@property(nonatomic,strong)ActivityView *activityView;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.vcTitle;
    if(self.userId == 0) {
        self.userId = [AppModel sharedInstance].user_info.userId;
    }
    
    ActivityView *view = [[ActivityView alloc] init];
    view.userId = [NSString stringWithFormat:@"%ld", self.userId];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.activityView = view;
}

@end
