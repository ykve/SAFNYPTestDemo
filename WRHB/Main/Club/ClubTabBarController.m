//
//  ClubTabBarController.m
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubTabBarController.h"

#import "ClubGameTypeController.h"
#import "ChatsHallController.h"
#import "UnionHallController.h"
#import "ClubManageController.h"
#import "ClubModel.h"
#import "ClubManager.h"
#import "LMGameTypeController.h"

@interface ClubTabBarController ()< UITabBarControllerDelegate, UITabBarDelegate >

// 记录上次数
@property (nonatomic,assign) NSInteger weChatslastBadgeNum;

@end

@implementation ClubTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // 装载子视图控制器
    [self loadViewControllers];
    //添加突出按钮：（替换原位置Item，若不使用此句话，显示原item）
//    [self addUpperButtonIndex:2];
    //通过注册 KVO 来观察选择器的改变，同时切换突出按钮 对属性赋值改的时候进行响应
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSetBadgeValue:)name:kApplicationJoinClubNotification object:nil];
    [self updateSetBadgeValue:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationJoinClubNotification object:nil];
}

/**
 设置角标
 */
- (void)updateSetBadgeValue:(NSNotification *)notification {
    
    BOOL isRefresh = YES;
    if ((self.weChatslastBadgeNum > 100 && [UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum > 100) || self.weChatslastBadgeNum == [UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum) {
        isRefresh = NO;
    }
    self.weChatslastBadgeNum = [UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum;
    
    if (isRefresh) {
        NSString *value = nil;
        if ([UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum > 0) {
            if ([UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum >= kMessageMaxNum) {
                value = @"99+";
            } else {
                value = [NSString stringWithFormat:@"%ld", (long)[UnreadMessagesNumSingle sharedInstance].clubAppltJoinNum];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBar.items[3] setBadgeValue: value];
        });
    }
    
}



#pragma mark ---" NSKeyValueObserving  观察者"---

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //改变的内容: [change objectForKey:@"new"]、change 要改变的属性 keyPath
    //    NSLog(@"--->change: %@",change);
    NSLog(@"--->_upperIndex: %ld",(long)_upperIndex);
    //    NSLog(@"--->new: %ld \n ",[[change objectForKey:@"new"] integerValue]);
    
    if ([keyPath isEqualToString:@"selectedIndex"])
    {
        if (_upperIndex == [[change objectForKey:@"new"] integerValue]) {
            self.zmTabBar.UpperBtn.selected = YES;
        }else{
            self.zmTabBar.UpperBtn.selected = NO;
        }
    }
}

#pragma mark- UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //    NSLog(@"---> getCurrentVC_CC = %@",[[Common getCurrentVC] class]);
    //    NSLog(@"---> selectedIndex_11 = %ld",self.selectedIndex);
    //不可选
    //    if (viewController == self.viewControllers[3]) {
    //        return NO;
    //    }
    return YES;
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    //NSLog(@"--> _upperIndex = %ld ",self.upperIndex);
    NSLog(@"--> didSelect = %ld \n ",(long)self.selectedIndex);
    if (tabBarController.selectedIndex == 1) {
        [ClubManager sharedInstance].isClickTabBarInChat = YES;
    }
    if (self.selectedIndex==2) {
        [self tabBarController:tabBarController shouldSelectViewController:viewController];
    }
    // 换页和 突出按钮 button的状态关联上
    if (self.selectedIndex==_upperIndex) {
        self.zmTabBar.UpperBtn.selected=YES;
    }else{
        self.zmTabBar.UpperBtn.selected=NO;
    }
}

#pragma mark- UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"--> selectedIndex = %ld ",(long)self.selectedIndex);
    
}


#pragma mark- 装载子视图控制器

- (void)loadViewControllers {
    
    //1.
    ClubGameTypeController *v1 =[[ClubGameTypeController alloc] init];

//    v1.navigationItem.title = self.clubModel.club_name;
    //2.
    ChatsHallController *v2= [[ChatsHallController alloc] init];
    //3.
    LMGameTypeController *v3 = [[LMGameTypeController alloc] init];

    //4.
    ClubManageController *v4= [[ClubManageController alloc] init];
    
    
    ZMNavController* navRootVC_1 = [[ZMNavController alloc] initWithRootViewController:v1];
    ZMNavController* navRootVC_2 = [[ZMNavController alloc] initWithRootViewController:v2];
    ZMNavController* navRootVC_3 = [[ZMNavController alloc] initWithRootViewController:v3];
    ZMNavController* navRootVC_4 = [[ZMNavController alloc] initWithRootViewController:v4];
    
    self.viewControllers = @[navRootVC_1,
                             navRootVC_2,
                             navRootVC_3,
                             navRootVC_4];
    UITabBarItem *tabBarItem_1 =[self getTabBarItemOfNavController:navRootVC_1  myVC:v1 title:@"游戏大厅"
                                                     normolImgName:@"club_tb_homegame_normal"
                                                     selectImgName:@"club_tb_homegame_press"];
    
    UITabBarItem *tabBarItem_2 =[self getTabBarItemOfNavController: navRootVC_2 myVC: v2 title:@"聊天大厅"
                                                     normolImgName:@"club_tb_chat_normal"
                                                     selectImgName:@"club_tb_chat_press"];
    
    UITabBarItem *tabBarItem_3 =[self getTabBarItemOfNavController: navRootVC_3 myVC: v3 title:@"联盟大厅"
                                                     normolImgName:@"club_tb_alliance_normal"
                                                     selectImgName:@"club_tb_alliance_press"];
    
    UITabBarItem *tabBarItem_4 =[self getTabBarItemOfNavController: navRootVC_4 myVC: v4 title:@"俱乐部管理"
                                                     normolImgName:@"club_tb_manage_normal"
                                                     selectImgName:@"club_tb_manage_press"];
    
    // 调整tabbar
    [self setUpTabBar];
    self.zmTabBar.items = @[tabBarItem_1,
                            tabBarItem_2,
                            tabBarItem_3,
                            tabBarItem_4];
    //设置默认 显示项
    self.zmTabBar.selectedItem = tabBarItem_1;
    /**
     *  更换系统自带的tabbar：利用 KVC 把系统的 tabBar 类型改为自定义类型。
     *  注意：替换的位置必须在 设置 items 的后面
     */
    [self setValue:self.zmTabBar forKey:@"tabBar"];
}

#pragma mark- 自定义 UITabBar
- (void)setUpTabBar {
    // 设置背景颜色（有效）、设置代理
    self.zmTabBar = [[ZMTabBar alloc] init];
    self.zmTabBar.barTintColor = [UIColor whiteColor];
    self.zmTabBar.delegate = self;
}

- (UITabBarItem *)getTabBarItemOfNavController:(UINavigationController *)navVC
                                          myVC:(UIViewController *)myVC
                                         title:(NSString *)title
                                 normolImgName:(NSString *)normolImgName
                                 selectImgName:(NSString *)selectImgName    {
    myVC.title = title;
    myVC.tabBarItem.title= title;
    
    UIImage *normolImg = [UIImage imageNamed:normolImgName];
    UIImage *selectImg = [UIImage imageNamed:selectImgName];
    
    navVC.tabBarItem.image         = [normolImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navVC.tabBarItem.selectedImage = [selectImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [navVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                               NSForegroundColorAttributeName:[UIColor colorWithHex:@"#888888"]} forState:UIControlStateNormal];
    [navVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                               NSForegroundColorAttributeName:[UIColor colorWithHex:@"#FF4444"]} forState:UIControlStateSelected];
    //设置导航 标题 颜色
    [navVC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor colorWithHex:@"#333333"],NSForegroundColorAttributeName,
                                                 [UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil]];
    return navVC.tabBarItem;
}


#pragma mark- 添加突出按钮 替换索引位置的Item
- (void)addUpperButtonIndex:(NSInteger)upperIndex
{
    self.upperIndex = upperIndex;
    [self addUpperButtonWithImage:[UIImage imageNamed:@"tabbar_huodong_press"]
                    selectedImage:[UIImage imageNamed:@"tabbar_huodong_press"]
                       upperIndex:_upperIndex];
    //（覆盖原位置Item）应该把 UITabBarItem 的图片置空 @"" ,避免UpperBtn图片没有完全覆盖 UITabBarItem图
    self.zmTabBar.items[_upperIndex].image = IMG(@"");
    self.zmTabBar.items[_upperIndex].selectedImage = IMG(@"");
    // 设置代理：UITabBarControllerDelegate 为了换页和 突出按钮Btn的状态关联上
    self.delegate = self;
    
}
#pragma mark - addCenterButton // 创建一个自定义UIButton并将它添加到我们的标签栏中

-(void)addUpperButtonWithImage:(UIImage*)norImage
                 selectedImage:(UIImage*)selectedImage
                    upperIndex:(NSInteger)upperIndex
{
    self.zmTabBar.UpperBtn = [ZMUpperButton buttonWithType:UIButtonTypeCustom];
    self.zmTabBar.UpperBtn.adjustsImageWhenHighlighted = NO;
    [self.zmTabBar.UpperBtn setImage:norImage forState:UIControlStateNormal];
    [self.zmTabBar.UpperBtn setImage:selectedImage forState:UIControlStateSelected];
    [self.zmTabBar.UpperBtn addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    /*
     *  核心代码：设置button的center，同时做出相对的上浮
     */
    //    CGFloat itemWidth = self.zmTabBar.frame.size.width/self.zmTabBar.items.count;
    //    self.zmTabBar.UpperBtn.frame = CGRectMake(0, 0, itemWidth, self.zmTabBar.frame.size.height+20);
    //    self.zmTabBar.UpperBtn.center = CGPointMake(itemWidth * (upperIndex+ 0.5), self.zmTabBar.frame.size.height/2-10);
    //    self.zmTabBar.UpperBtn.backgroundColor = Clear_COLOR;
    //    [self.zmTabBar addSubview:self.zmTabBar.UpperBtn];
    
    
    CGFloat itemWidth = self.zmTabBar.frame.size.width/self.zmTabBar.items.count;
    self.zmTabBar.UpperBtn.frame = CGRectMake(0, 0, itemWidth, self.zmTabBar.frame.size.height);
    self.zmTabBar.UpperBtn.center = CGPointMake(itemWidth * (upperIndex+ 0.5), self.zmTabBar.frame.size.height/2+2);
    self.zmTabBar.UpperBtn.backgroundColor = Clear_COLOR;
    [self.zmTabBar addSubview:self.zmTabBar.UpperBtn];
    
}
#pragma mark- UpperBtn 的点击响应
-(void)pressChange:(id)sender {
    NSLog(@"--> self.zmTabBar= %d",self.zmTabBar.hidden);
    NSLog(@"--> self.zmTabBar.UpperBtn.selected= %d",self.zmTabBar.UpperBtn.selected);
    NSLog(@"--> _upperIndex = %ld \n ",(long)self.upperIndex);
    //选择器显示 突出控制器
    self.selectedIndex = _upperIndex;
    //突显图片
    self.zmTabBar.UpperBtn.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 计算色值：16进制色值转化为RGB返回UIColor类型对象
- (UIColor *)colorHexString:(NSString *)hexValue {
    
    //将一个 NSString = @“#FF0000”转换成 RGB的方法
    NSMutableString *color = [[NSMutableString alloc] initWithString:hexValue];
    [color insertString:@"0x" atIndex:0];
    
    // 转换成标准16进制数：十六进制字符串转成整形，通过位与方法获取三色值
    long colorLong = strtoul([color cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];;
}


@end

