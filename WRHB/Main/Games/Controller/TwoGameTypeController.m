//
//  TwoGameGroupTypeController.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "TwoGameTypeController.h"
#import "TwoBaseGameItemController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "RedPacketItemSubVC.h"
#import "DianZiItemController.h"
#import "QiPaiItemController.h"
#import "CasualItemController.h"
#import "ClubItemController.h"


#import "SessionSingle.h"
#import "ChatViewController.h"
#import "MessageItem.h"
#import "YPMenu.h"
#import "HelpCenterWebController.h"
#import "HelpCenterWebController.h"
#import "AgentCenterViewController.h"
#import "CreateGroupController.h"


#import "EnterPwdBoxView.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "UIImageView+WebCache.h"
#import "GridCell.h"
#import "GameMainCell.h"

#import "ChatsModel.h"

#import "SystemNotificationModel.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"

#import "ClubTabBarController.h"
#import "JJScrollTextLable.h"
#import "BannerModels.h"
#import "BannerModel.h"

#import "HQFlowView.h"
#import "HQImagePageControl.h"
#import "GamesTypeModel.h"

#define kViewTag 666




@interface TwoGameTypeController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,HQFlowViewDelegate,HQFlowViewDataSource>

// ***** Top 卡片 *****
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *advArray;
/**
 *  轮播图
 */
@property (nonatomic, strong) HQImagePageControl *pageC;
@property (nonatomic, strong) HQFlowView *pageFlowView;
@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图容器
/// 电影卡片选择下标
@property (nonatomic, assign) NSInteger topImgSelectedIndex;


@property (nonatomic, strong) UIScrollView *controllerScrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) EnterPwdBoxView *entPwdView;
@property (nonatomic, strong) GridCell *gridV;

@end

@implementation TwoGameTypeController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.topImgSelectedIndex = self.selectedItemIndex;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView addSubview:self.pageC];
    [self.pageFlowView reloadData];//刷新轮播
    
    
//    [self topInitBannerData];
    
    
    [self.view addSubview:self.controllerScrollView];
    [self topViewAddController];
    
    [self.pageFlowView scrollToPage:self.topImgSelectedIndex];
}



#pragma mark -  电影卡片 轮播图
- (NSMutableArray *)advArray
{
    if (!_advArray) {
        _advArray = [NSMutableArray arrayWithObjects:@"chats_gif_405",@"chats_gif_406",@"chats_gif_407",@"chats_gif_499",@"chats_gif_409",@"chats_gif_410", nil];
    }
    return _advArray;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kGameTopHeight)];
        _scrollView.backgroundColor = [UIColor colorWithHex:@"#DDDDDD"];
    }
    return _scrollView;
}

- (HQFlowView *)pageFlowView
{
    if (!_pageFlowView) {
        
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kGameTopHeight)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.5;
        _pageFlowView.leftRightMargin = 6;
        _pageFlowView.topBottomMargin = 24;
        _pageFlowView.orginPageCount = _advArray.count;
        _pageFlowView.isOpenAutoScroll = NO;
//         _pageFlowView.isCarousel = NO;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
        
    }
    return _pageFlowView;
}

- (HQImagePageControl *)pageC
{
    if (!_pageC) {
        
        //初始化pageControl
        if (!_pageC) {
            _pageC = [[HQImagePageControl alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 15, self.scrollView.frame.size.width, 7.5)];
        }
        [self.pageFlowView.pageControl setCurrentPage:0];
        self.pageFlowView.pageControl = _pageC;
        
    }
    return _pageC;
}

#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView
{
    return CGSizeMake(115, self.scrollView.frame.size.height-2*15);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    TwoBaseGameItemController *targetViewController = self.myChildViewControllers[self.topImgSelectedIndex];
    targetViewController.topImgSelectedIndex = subIndex;
    NSLog(@"点击第%ld个广告",(long)subIndex);
}
#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return self.dataArray.count >= self.advArray.count ? self.advArray.count : self.dataArray.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.layer.cornerRadius = 5;
        bannerView.layer.masksToBounds = YES;
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    //在这里下载网络图片
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.advArray[index]] placeholderImage:nil];
    //加载本地图片
//    bannerView.mainImageView.image = [[FunctionManager sharedInstance] gifImgImageStr: [NSString stringWithFormat:@"chats_gif_%@", model.avatar]];
    
    GamesTypeModel *model = self.dataArray[index];
    bannerView.mainImageView.animatedImage = [[FunctionManager sharedInstance] gifFLAnimatedImageStr:[NSString stringWithFormat:@"chats_gif_%@", model.avatar]];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView
{
    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
    self.topImgSelectedIndex = pageNumber;
    
    
    if (!self.controllerScrollView.isDragging) { // 判断用户是否在拖拽scrollView
        [self.controllerScrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * self.topImgSelectedIndex, 0) animated:YES];
    }
    
    if (self.myChildViewControllers.count <= self.topImgSelectedIndex) {return;}
    
    TwoBaseGameItemController *targetViewController = self.myChildViewControllers[self.topImgSelectedIndex];
    targetViewController.topImgSelectedIndex = self.topImgSelectedIndex;
    
    // 如果已经加载过，就不再加载
//    if ([targetViewController isViewLoaded]) {
//        return;
//    }
    CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
    targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.topImgSelectedIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
    [self.controllerScrollView addSubview:targetViewController.view];
    
}
#pragma mark --旋转屏幕改变JQFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}








#pragma mark -  加载内容控制器
- (void)topViewAddController {
    
    NSArray *controllerClassNames = nil;
    controllerClassNames = [NSArray arrayWithObjects:@"RedPacketItemSubVC",@"RedPacketItemSubVC",@"RedPacketItemSubVC",@"RedPacketItemSubVC",@"RedPacketItemSubVC",@"RedPacketItemSubVC", nil];
    
        for (int i = 0; i < self.advArray.count; i++) {
            
            if (controllerClassNames.count > i) {
                TwoBaseGameItemController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
                baseVc.dataArray = self.dataArray;
                [self addChildViewController:baseVc];
                // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
                [self.myChildViewControllers addObject:baseVc];
            }
            
        }
    
    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.topImgSelectedIndex < self.myChildViewControllers.count) {
        TwoBaseGameItemController *baseVc = self.myChildViewControllers[self.topImgSelectedIndex];
        baseVc.topImgSelectedIndex = self.topImgSelectedIndex;
        baseVc.isDataLoaded = YES;
        [self.controllerScrollView addSubview:baseVc.view];
        CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
        baseVc.view.frame = CGRectMake(kSCREEN_WIDTH*self.topImgSelectedIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
        self.controllerScrollView.contentOffset = CGPointMake(kSCREEN_WIDTH*self.topImgSelectedIndex, 0);
        self.controllerScrollView.contentSize = CGSizeMake(self.advArray.count*kSCREEN_WIDTH, 0);
    }
}
- (NSMutableArray *)myChildViewControllers {
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}
- (UIScrollView *)controllerScrollView {
    if (!_controllerScrollView) {
        CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
        CGFloat scrollViewHeightY = kGameTopHeight;
        
        _controllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewHeightY, kSCREEN_WIDTH, scrollViewHeight)];
        _controllerScrollView.delegate = self;
        _controllerScrollView.pagingEnabled = YES;
        _controllerScrollView.showsHorizontalScrollIndicator = NO;
        _controllerScrollView.showsVerticalScrollIndicator = NO;
        _controllerScrollView.backgroundColor = [UIColor whiteColor];
    }
    return  _controllerScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int currentPage = floor(scrollView.contentOffset.x / kSCREEN_WIDTH);
    [self.pageFlowView scrollToPage:currentPage];
    [self.pageFlowView.pageControl setCurrentPage:currentPage];
    
    self.topImgSelectedIndex = currentPage;
    
    if (!self.controllerScrollView.isDragging) { // 判断用户是否在拖拽scrollView
        [self.controllerScrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * self.topImgSelectedIndex, 0) animated:YES];
    }
    
    if (self.myChildViewControllers.count <= self.topImgSelectedIndex) {return;}
    
    TwoBaseGameItemController *targetViewController = self.myChildViewControllers[self.topImgSelectedIndex];
    targetViewController.topImgSelectedIndex = self.topImgSelectedIndex;
    
    // 如果已经加载过，就不再加载
    //    if ([targetViewController isViewLoaded]) {
    //        return;
    //    }
    CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
    targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * self.topImgSelectedIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
    [self.controllerScrollView addSubview:targetViewController.view];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
    [MBProgressHUD hideHUD];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark -  俱乐部入口
- (void)leftBarButtonDown:(UIBarButtonItem *)sender {
    //隐藏现在的tabbar和navi
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    ClubTabBarController *ccTab = [[ClubTabBarController alloc]init];
    [self.navigationController pushViewController:ccTab animated:YES];
}







/// ***** 下拉菜单 暂时没使用*****
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

@end

