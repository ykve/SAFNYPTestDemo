//
//  CommentCodeController.m
//  WRHB
//
//  Created by AFan on 2019/12/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CommentCodeController.h"

@interface CommentCodeController ()

@end

@implementation CommentCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//#pragma mark - 下拉菜单
////导航栏弹出
//- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
//    YPMenu *menu = [[YPMenu alloc] initWithItems:self.menuItems];
//    menu.menuCornerRadiu = 5;
//    menu.showShadow = NO;
//    menu.minMenuItemHeight = 48;
//    menu.titleColor = [UIColor darkGrayColor];
//    menu.menuBackGroundColor = [UIColor whiteColor];
//    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
//}
//
//- (NSMutableArray *)menuItems {
//    if (!_menuItems) {
//
//        __weak __typeof(self)weakSelf = self;
//
//        _menuItems = [[NSMutableArray alloc] initWithObjects:
//
//                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_up"]
//                                          title:@"快速充值"
//                                         action:^(YPMenuItem *item) {
//                                             //                                             UIViewController *vc = [[Recharge2ViewController alloc]init];
//                                             //                                             vc.hidesBottomBarWhenPushed = YES;
//                                             //                                             [weakSelf.navigationController pushViewController:vc animated:YES];
//                                         }],
//                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_agent"]
//                                          title:@"代理中心"
//                                         action:^(YPMenuItem *item) {
//                                             AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
//                                             vc.hidesBottomBarWhenPushed = YES;
//                                             [weakSelf.navigationController pushViewController:vc animated:YES];
//
//                                         }],
//                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_help"]
//                                          title:@"帮助中心"
//                                         action:^(YPMenuItem *item) {
//                                             HelpCenterWebController *vc = [[HelpCenterWebController alloc] init];
//                                             vc.hidesBottomBarWhenPushed = YES;
//                                             [weakSelf.navigationController pushViewController:vc animated:YES];
//
//                                         }],
//                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_rule"]
//                                          title:@"玩法规则"
//                                         action:^(YPMenuItem *item) {
//
//                                             NSString *url = [NSString stringWithFormat:@"%@/dist/#/mainRules", [AppModel sharedInstance].commonInfo[@"website.address"]];
//
//                                             WKWebViewController *vc = [[WKWebViewController alloc] init];
//                                             [vc loadWebURLSring:url];
//
//                                             vc.navigationItem.title = @"玩法规则";
//                                             vc.hidesBottomBarWhenPushed = YES;
//                                             //[vc loadWithURL:url];
//                                             [self.navigationController pushViewController:vc animated:YES];
//
//                                         }],
//                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_down_group"]
//                                          title:@"创建群组"
//                                         action:^(YPMenuItem *item) {
//                                             CreateGroupController *vc = [[CreateGroupController alloc] init];
//                                             vc.hidesBottomBarWhenPushed = YES;
//                                             [weakSelf.navigationController pushViewController:vc animated:YES];
//                                         }],
//
//
//
//
//                      nil];
//    }
//
//    return _menuItems;
//}


/// 设置TextField文字开头间距
//levelTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];

@end

