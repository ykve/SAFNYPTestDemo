//
//  GroupViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/31.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "GameTypeController.h"



#import "SPPageMenu.h"
#import "BaseGameItemController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "RedPacketItemController.h"
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
#import "MessageTableViewCell.h"

#import "SystemNotificationModel.h"
#import "SystemAlertViewController.h"
#import "VVAlertModel.h"

#import "ClubTabBarController.h"
#import "JJScrollTextLable.h"
#import "BannerModels.h"
#import "BannerModel.h"

#define kViewTag 666




@interface GameTypeController ()<SPPageMenuDelegate, UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) UITableView *topTableView;

@property (nonatomic, strong) NSArray *topDataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) BannerModels *bannerModels;
@property (nonatomic, strong) JJScorllTextLable *scorllTextLable;
@property (nonatomic, strong) NSArray<SystemNotificationModel *> *sysTextArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@property (nonatomic, strong) NSMutableArray * runloopArray;
@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) EnterPwdBoxView *entPwdView;
@property (nonatomic, strong) GridCell *gridV;

///
@property (nonatomic, assign) BOOL isShowSysGonggao;

@end

@implementation GameTypeController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    [AppModel sharedInstance].isClubChat = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _isShowSysGonggao = NO;
    _runloopArray = [NSMutableArray array];
    
    self.navigationItem.title = @"游戏大厅";
    //        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonDown:)];
    //        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    //        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_right_club"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    //        [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    [self getBannerData];
    [self getSystemNotificationData];
    
    [self setBannerUI];
    [self setTextScrollBarUI];
    [self topItemView];
    
    
    [self.view addSubview:self.scrollView];
    [self topViewAddController];
 
     /// 系统公告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemAnnouncementNotification:) name:kSystemAnnouncementNotification object:nil];
}

#pragma mark - SPPageMenu的代理方法
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    
    if (toIndex > 1) {
        return;
    }
    
    // 如果该代理方法是由拖拽self.scrollView而触发，说明self.scrollView已经在用户手指的拖拽下而发生偏移，此时不需要再用代码去设置偏移量，否则在跟踪模式为SPPageMenuTrackerFollowingModeHalf的情况下，滑到屏幕一半时会有闪跳现象。闪跳是因为外界设置的scrollView偏移和用户拖拽产生冲突
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * toIndex, 0) animated:YES];
        }
    }
    
    if (self.myChildViewControllers.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.myChildViewControllers[toIndex];
    
    // 如果已经加载过，就不再加载
    //    if ([targetViewController isViewLoaded]) return;
    CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kBannerHeight-kTopItemHeight-JJScorllTextLableHeight-Height_TabBar;
    targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * toIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
}


#pragma mark -  获取Banner数据
- (void)getBannerData {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/banner/group"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        BannerModels* model = [BannerModels mj_objectWithKeyValues:cacheJson];
        self.bannerModels = model;
        [self analysisData:model];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            BannerModels* model = [BannerModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.bannerModels = model;
            [strongSelf analysisData:model];
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)analysisData:(BannerModels *)models {
    NSMutableArray *bannerUrlArray = [NSMutableArray array];
    for (BannerModel *model in models.banners) {
        [bannerUrlArray addObject:model.img_url];
    }
    self.cycleScrollView.imageURLStringsGroup = bannerUrlArray;
}



#pragma mark -  获取系统公告
- (void)getSystemNotificationData {

    NSArray *arr = @[@(1),@(2)];
    NSDictionary *parameters = @{
                                 @"type":arr
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/notice"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        NSArray *modelArray = [SystemNotificationModel mj_objectArrayWithKeyValuesArray:cacheJson];
        self.sysTextArray = modelArray;
        [self sysAnalysisData:modelArray];
        [self goto_SystemAlertViewController:self.sysTextArray];
    }

    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];

        if ([response[@"status"] integerValue] == 1) {
            NSArray *modelArray = [SystemNotificationModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.sysTextArray = modelArray;
            [strongSelf sysAnalysisData:modelArray];
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }

    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark - 系统公告刷新通知
- (void)systemAnnouncementNotification:(NSNotification *)notification {
    NSArray *array = notification.object;
    [self setSysTextArray:array];
}

- (void)sysAnalysisData:(NSArray<SystemNotificationModel *> *)sysTextArray {
    NSMutableString *muString = [NSMutableString string];
    if(sysTextArray.count > 0) {
        for (SystemNotificationModel *model in sysTextArray) {
            if (model.desTitle) {
                [muString appendString:model.desTitle];
            }
            if (model.detail) {
                [muString appendString:[NSString stringWithFormat:@"   %@;  ", model.detail]];
            }
        }
    }

    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.scorllTextLable.text = muString;
        
        if (!strongSelf.isShowSysGonggao) {
            strongSelf.isShowSysGonggao = YES;
//            [strongSelf goto_SystemAlertViewController:strongSelf.sysTextArray];
        }
        
    });

}


- (void)topViewAddController {
    
    NSArray *controllerClassNames = nil;
    controllerClassNames = [NSArray arrayWithObjects:@"RedPacketItemController",@"ClubItemController",@"DianZiItemController",@"QiPaiItemController",@"CasualItemController", nil];
    
    for (int i = 0; i < self.topDataArr.count; i++) {
        
        if (i == 1) {
            ClubItemController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
            baseVc.index = i;
            [self addChildViewController:baseVc];
            [self.myChildViewControllers addObject:baseVc];
        } else {
            if (controllerClassNames.count > i) {
                BaseGameItemController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
                [self addChildViewController:baseVc];
                // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
                [self.myChildViewControllers addObject:baseVc];
            }
        }
        
    }

    // pageMenu.selectedItemIndex就是选中的item下标
    if (self.pageMenu.selectedItemIndex < self.myChildViewControllers.count) {
        BaseGameItemController *baseVc = self.myChildViewControllers[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:baseVc.view];
        CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kTopItemHeight-JJScorllTextLableHeight-Height_TabBar;
        baseVc.view.frame = CGRectMake(kSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0, kSCREEN_WIDTH, scrollViewHeight);

        self.scrollView.contentOffset = CGPointMake(kSCREEN_WIDTH*self.pageMenu.selectedItemIndex, 0);
        self.scrollView.contentSize = CGSizeMake(self.topDataArr.count*kSCREEN_WIDTH, 0);
    }
}
- (NSMutableArray *)myChildViewControllers {
    if (!_myChildViewControllers) {
        _myChildViewControllers = [NSMutableArray array];
    }
    return _myChildViewControllers;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollViewHeightY = kTopItemHeight + kBannerHeight+ JJScorllTextLableHeight;
        CGFloat scrollViewHeight = kSCREEN_HEIGHT-Height_NavBar-kBannerHeight-kTopItemHeight-JJScorllTextLableHeight-Height_TabBar;

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewHeightY, kSCREEN_WIDTH, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return  _scrollView;
}




#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x>kSCREEN_WIDTH) {
        [scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, scrollView.contentOffset.y) animated:NO];
    }
    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    // [self.pageMenu moveTrackerFollowScrollView:scrollView];
}



#pragma mark -  俱乐部入口
- (void)leftBarButtonDown:(UIBarButtonItem *)sender {
    //隐藏现在的tabbar和navi
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];

    ClubTabBarController *ccTab = [[ClubTabBarController alloc]init];
    [self.navigationController pushViewController:ccTab animated:YES];
}


- (void)topItemView {
    self.topDataArr = nil;
    NSArray *images = nil;
    CGFloat imageTitleSpace = 5;
    //    UIEdgeInsets edgeI = UIEdgeInsetsMake(10, 20, 30, 20);
    UIEdgeInsets edgeI = UIEdgeInsetsMake(15, 3, 20, 3);
    self.topDataArr = @[@"红包游戏",@"俱乐部",@"电子游戏",@"棋牌游戏",@"休闲游戏"];
    //        images = @[@"chats_gif_401",@"chats_gif_402",@"chats_gif_403",@"chats_gif_404"];
    images = @[@"game_top_redpacket",@"game_top_club",@"game_top_dianwan",@"game_top_qipai",@"game_top_xiuxian"];




    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, kBannerHeight+JJScorllTextLableHeight, kSCREEN_WIDTH, kTopItemHeight) trackerStyle:SPPageMenuTrackerStyleLine];
    pageMenu.backgroundColor = [UIColor whiteColor];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.topDataArr selectedItemIndex:self.selectedItemIndex];
    pageMenu.itemTitleFont = [UIFont  systemFontOfSize:12];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;


    SPPageMenuButtonItem *item0 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[0] image:[UIImage imageNamed:images[0]]];
    item0.imagePosition = SPItemImagePositionTop;
    item0.imageTitleSpace = imageTitleSpace;
    item0.imageEdgeInsets = edgeI;
    [pageMenu setItem:item0 forItemAtIndex:0];

    SPPageMenuButtonItem *item1 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[1] image:[UIImage imageNamed:images[1]]];
    item1.imagePosition = SPItemImagePositionTop;
    item1.imageTitleSpace = imageTitleSpace;
    item1.imageEdgeInsets = edgeI;
    [pageMenu setItem:item1 forItemAtIndex:1];

    SPPageMenuButtonItem *item2 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[2] image:[UIImage imageNamed:images[2]]];
    item2.imagePosition = SPItemImagePositionTop;
    item2.imageTitleSpace = imageTitleSpace;
    item2.imageEdgeInsets = edgeI;
    [pageMenu setItem:item2 forItemAtIndex:2];
    

    SPPageMenuButtonItem *item3 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[3] image:[UIImage imageNamed:images[3]]];
    item3.imagePosition = SPItemImagePositionTop;
    item3.imageTitleSpace = imageTitleSpace;
    item3.imageEdgeInsets = edgeI;
    [pageMenu setItem:item3 forItemAtIndex:3];
    
    [pageMenu setEnabled:NO forItemAtIndex:2];
    [pageMenu setEnabled:NO forItemAtIndex:3];
    
    
    SPPageMenuButtonItem *item4 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[4] image:[UIImage imageNamed:images[4]]];
    item4.imagePosition = SPItemImagePositionTop;
    item4.imageTitleSpace = imageTitleSpace;
    item4.imageEdgeInsets = edgeI;
    [pageMenu setItem:item4 forItemAtIndex:4];
    
    [pageMenu setEnabled:NO forItemAtIndex:4];
    

    pageMenu.delegate = self;
    // 给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;

    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;


}



 #pragma mark -  Banner 图片广告
- (void)setBannerUI {
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(5, 5, kSCREEN_WIDTH-10, kBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView.layer.cornerRadius = 5;
    cycleScrollView.layer.masksToBounds  = YES;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    [self.view addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.bannerModels.banners[index];
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:model.jump_url];
    //                vc.navigationItem.title = item.name;
    vc.title = model.title;
    vc.hidesBottomBarWhenPushed = YES;
    //[vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark -  文字滚动条
- (void)setTextScrollBarUI {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHex:@"#EAE9EA"];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kBannerHeight +10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(JJScorllTextLableHeight -10);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"chats_message"];
    [backView addSubview:iconImageView];
    //    iconImageView.backgroundColor = [UIColor greenColor];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(5);
        make.size.mas_equalTo(18);
    }];
    
    //创建一个滚动文字的label
    JJScorllTextLable *label = [[JJScorllTextLable alloc] init];
    //    label.text = @"设置滚动文字的内容";   //设置滚动文字的内容
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHex:@"#666666"];
    label.rate = 0.2;
    [backView addSubview:label]; //把滚动文字的lable加到视图
    _scorllTextLable = label;
    //    label.backgroundColor= [UIColor redColor];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScorllTextLableEvent:)];
    //将手势添加到需要相应的view中去
    [label addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    [label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(30);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
        make.height.mas_equalTo(JJScorllTextLableHeight -10);
    }];
    
    //本项目github地址https://github.com/luowenqi/JJScrollText
    //还有图片轮播，github地址https://github.com/luowenqi/JJCyclePicView
    
    
    /*
     其他的可以设置的内容
     @property (nonatomic, assign) JJTextCycleStyle style;   //设置滚动的样式
     @property (nonatomic, assign)IBInspectable CGFloat interval; //设置滚动的间隔  70
     @property (nonatomic, assign)IBInspectable CGFloat rate;//滚动的速度  0~1  默认 0.5
     @property (nonatomic, copy)IBInspectable NSString *text;  //滚动的文字内容
     @property (nonatomic, strong) UIFont *font;  //设置滚动字体
     @property (nonatomic, strong)IBInspectable UIColor *textColor;  //设置文字颜色
     @property (nonatomic, assign) NSTextAlignment textAlignment;   //设置文字对齐方式
     - (void)pause;  //暂停
     - (void)stop;    //停止
     */
    
}
#pragma mark - 公告栏点击事件
- (void)onScorllTextLableEvent:(UITapGestureRecognizer *)gesture {
    [self goto_SystemAlertViewController:self.sysTextArray]; 
}
#pragma mark - goto 系统公告栏
- (void)goto_SystemAlertViewController:(NSArray<SystemNotificationModel *> *)sysTextArray {
    NSMutableArray *announcementArray = [NSMutableArray array];
    if(sysTextArray.count > 0) {
        for (SystemNotificationModel *model in sysTextArray) {
            NSString *title = model.desTitle;
            NSString *content = model.detail;
            VVAlertModel *model = [[VVAlertModel alloc] init];
            model.name = title;
            if (content.length > 0) {
                model.friends = @[content];
            }
            [announcementArray addObject:model];
        }
    } else {
        return;
    }
    SystemAlertViewController *alertVC = [SystemAlertViewController alertControllerWithTitle:@"公告" dataArray:announcementArray];
    [self presentViewController:alertVC animated:NO completion:nil];
}

-(NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray = [[NSMutableArray alloc]init];
    }
    return _topArray;
}

@end
