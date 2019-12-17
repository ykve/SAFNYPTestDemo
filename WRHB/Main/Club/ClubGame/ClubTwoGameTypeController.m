//
//  TwoGameGroupTypeController.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubTwoGameTypeController.h"
#import "ClubTwoBaseGameItemController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "RedPacketItemSubVC.h"

#import "CreateGroupController.h"
#import "UIImageView+WebCache.h"

#import "ChatsModel.h"
#import "ClubTabBarController.h"

#import "HQFlowView.h"
#import "HQImagePageControl.h"
#import "ChatViewController.h"

#define kViewTag 666




@interface ClubTwoGameTypeController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,HQFlowViewDelegate,HQFlowViewDataSource>

// ***** Top 卡片 *****
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

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, assign) CGFloat offsetRatio;
@property (nonatomic, assign) NSInteger activeIndex;
@property (nonatomic, assign) BOOL isTopScrollViewSlide;

@end

@implementation ClubTwoGameTypeController


- (void)dealloc
{
    self.pageFlowView.delegate = nil;
    self.pageFlowView.dataSource = nil;
    [self.pageFlowView stopTimer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
//    // 拦截返回事件
//    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
//        //        _chatVC = nil;
//    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _currentIndex = -1;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView addSubview:self.pageC];
    [self.pageFlowView reloadData];//刷新轮播
    [self.pageFlowView scrollToPage:self.topImgSelectedIndex];
    
    [self setControllerScrollView];

    [self topViewAddController];

    [self reloadData];
}


// Controller
- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
{
    //
    if ([eventName isEqualToString:@"ClubTwoBaseGameItemControllerGoToChat"]) {
         ChatsModel *chatModel = (ChatsModel *)user_info[@"model"];
        GamesTypeModel *gameModel = (GamesTypeModel *)user_info[@"gamesTypeModel"];
        ChatViewController *vc = [ChatViewController chatsFromModel:chatModel];
        vc.gamesTypeModel = gameModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    [super routerEventWithName:eventName user_info:user_info];
}





- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    _selectedItemIndex = selectedItemIndex;
    _activeIndex = selectedItemIndex;
    _topImgSelectedIndex = selectedItemIndex;

}

#pragma mark -  controllerScrollView
- (void)setControllerScrollView {
    self.contents = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i ++)
    {
        [self.contents addObject:[NSNull null]];
    }
    
    CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
    CGFloat scrollViewHeightY = kGameTopHeight;
    
    _controllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewHeightY, kSCREEN_WIDTH, scrollViewHeight)];
    _controllerScrollView.delegate = self;   // 设置代理
    _controllerScrollView.pagingEnabled = YES;  // 设置分页
    _controllerScrollView.showsHorizontalScrollIndicator = NO;  // 去掉滚动条
    _controllerScrollView.showsVerticalScrollIndicator = NO;
    _controllerScrollView.backgroundColor = [UIColor whiteColor];
    
    _controllerScrollView.contentSize = CGSizeMake(self.dataArray.count * kSCREEN_WIDTH, 0);
    [self.view addSubview:_controllerScrollView];
}


- (void)reloadData
{
    [self.controllerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < 3; i ++)
    {
        NSInteger thisPage = [self validIndexValue: self.activeIndex - 1 + i];
  
        ClubTwoBaseGameItemController *targetViewController = self.myChildViewControllers[thisPage];
        targetViewController.topImgSelectedIndex = thisPage;
        
        [self.contents replaceObjectAtIndex:i withObject:targetViewController];  // 返回哪一个控制器
    }
    
    for (int i = 0; i < 3; i++)
    {
        UIViewController* viewController = [self.contents objectAtIndex:i];
        UIView* view = viewController.view;
        view.userInteractionEnabled = YES;
        
        view.frame = CGRectOffset(CGRectMake(self.controllerScrollView.frame.origin.x, 0, self.controllerScrollView.frame.size.width, self.controllerScrollView.frame.size.height), view.frame.size.width * i, 0);
        
        [self.controllerScrollView addSubview: view];
    }
    
    [self.controllerScrollView setContentOffset:CGPointMake(self.controllerScrollView.frame.size.width + self.controllerScrollView.frame.size.width * self.offsetRatio, 0)];
    NSLog(@"1");
}


- (NSInteger)validIndexValue:(NSInteger)value
{
    self.currentIndex = value;
    if(value == -1)
    {
        value = self.dataArray.count - 1;
    }
    
    if(value == self.dataArray.count)
    {
        value = 0;
    }
    
    return value;
}

- (void)setActiveIndex:(NSInteger)activeIndex
{
    if (_activeIndex != activeIndex)
    {
        if (!self.isTopScrollViewSlide) {
            [self.pageFlowView scrollToPage:self.currentIndex];
        }
        
        _activeIndex = activeIndex;
        [self reloadData];
    }
}

- (void)setOffsetRatio:(CGFloat)offsetRatio
{
    
    if (_offsetRatio != offsetRatio)
    {
        _offsetRatio = offsetRatio;
        
        [self.controllerScrollView setContentOffset:CGPointMake(self.controllerScrollView.frame.size.width + self.controllerScrollView.frame.size.width * offsetRatio, 0)];
        if (offsetRatio > 0.5)
        {
            _offsetRatio = offsetRatio - 1;
            self.activeIndex = [self validIndexValue: self.activeIndex + 1];
        }
        
        if (offsetRatio < -0.5)
        {
            _offsetRatio = offsetRatio + 1;
            self.activeIndex = [self validIndexValue: self.activeIndex - 1];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isTopScrollViewSlide) {
        return;
    }
    self.offsetRatio = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame) - 1;
}

#pragma mark -  加载内容控制器
- (void)topViewAddController {
    
    NSArray *controllerClassNames = nil;
    controllerClassNames = [NSArray arrayWithObjects:@"ClubRedPacketItemSubVC",@"ClubRedPacketItemSubVC2",@"ClubRedPacketItemSubVC3",@"ClubRedPacketItemSubVC4",@"ClubRedPacketItemSubVC5",@"ClubRedPacketItemSubVC6", nil];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        if (controllerClassNames.count > i) {
            ClubTwoBaseGameItemController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            baseVc.dataArray = self.dataArray;
//            baseVc.navController = self;
            [self.myChildViewControllers addObject:baseVc];
        }
    }
}





- (NSMutableArray *)myChildViewControllers {
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}





- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    self.currentIndex = 0;
}














#pragma mark -  电影卡片 轮播图

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
        _pageFlowView.orginPageCount = self.dataArray.count;
        _pageFlowView.isOpenAutoScroll = NO;
        //        _pageFlowView.isCarousel = NO;
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
//    NSLog(@"点击第%ld个广告",(long)subIndex);
}
#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return self.dataArray.count;
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
    
    GamesTypeModel *model = self.dataArray[index];
    //加载本地图片
//    bannerView.mainImageView.image = [[FunctionManager sharedInstance] gifImgImageStr: [NSString stringWithFormat:@"chats_gif_%@", model.avatar]];
    
    bannerView.mainImageView.animatedImage = [[FunctionManager sharedInstance] gifFLAnimatedImageStr:[NSString stringWithFormat:@"chats_gif_%@", model.avatar]];
    
    
    return bannerView;
}

/**
 *  将要滚动开始滚动
 */
- (void)willStartScrolling:(UIScrollView *)scrollView {
    self.isTopScrollViewSlide = YES;
}


- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView
{
        [self.pageFlowView.pageControl setCurrentPage:pageNumber];
        self.topImgSelectedIndex = pageNumber;
    
        if (self.isTopScrollViewSlide) {
//            self.offsetRatio = pageNumber;
            self.activeIndex = pageNumber;
            self.offsetRatio = 0;
            self.isTopScrollViewSlide = NO;
        }
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


@end
