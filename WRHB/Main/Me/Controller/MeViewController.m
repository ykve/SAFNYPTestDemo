//
//  MeViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MeViewController.h"
#import "LoginViewController.h"
#import "MeTableViewCell.h"
#import "SettingViewController.h"
#import "MeInfoViewController.h"
#import "BillTypeViewController.h"
#import "AgentCenterViewController.h"
#import "PayWithdrawalCenterController.h"
#import "BankCardManageController.h"
#import "PayAssetsModel.h"
#import "ShareViewController.h"
#import "AppDelegate.h"


#import "SwipeTableView.h"
#import "STHeaderView.h"
#import "UIView+STFrame.h"
#import "CustomSegmentControl.h"
#import "CustomCollectionView.h"
#import "MeACollectionView.h"
#import "MeTopViewTowLabel.h"
#import "WKWebViewController.h"

#import "BillTypeModel.h"
#import "BillItemModel.h"
#import "BillViewController.h"
#import "RedPacketDetListController.h"
#import "ShareDetailViewController.h"
#import "GameFeedbackController.h"

#import "PayTopUpTypeController.h"


#define kSTRefreshHeaderHeight  60
#define kSTRefreshImageWidth    40
#define kMarginWidth  15
#define kBViewHeight  240

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate, SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>

///
@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) MeACollectionView *aaView;
@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) STHeaderView * tableViewHeader;
@property (nonatomic, strong) CustomSegmentControl * segmentBar;
@property (nonatomic, strong) CustomCollectionView * collectionView;
@property (nonatomic, strong) CustomCollectionView * collectionViewB;

@property (nonatomic, strong) NSMutableDictionary * billGameDict;

/// 头像
@property (nonatomic, strong) UIImageView *headImageView;
/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// 账号
@property (nonatomic, strong) UILabel *idLabel;
/// 个性签名
@property (nonatomic, strong) UILabel *desLabel;

///
@property (nonatomic, strong) UITableView *meTableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

/// GOLO
@property (nonatomic, strong) PayAssetsModel *assetsModel;
/// 性别
@property (nonatomic, strong) UIImageView *genderImageView;
/// 余额
@property (nonatomic, strong) UILabel *moneyLabel;



/// 今日充值
@property (nonatomic, strong) MeTopViewTowLabel * topView0;
/// 今日提现
@property (nonatomic, strong) MeTopViewTowLabel *topView1;
/// 今日优惠
@property (nonatomic, strong) MeTopViewTowLabel *topView2;
/// 今日盈利
@property (nonatomic, strong) MeTopViewTowLabel *topView3;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
//    self.view.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
    self.view.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
    
    [self setNavUI];
    [self.view addSubview:self.meTableView];
    [self setupUI];
    [self setAaView];
    
    // init data
    _billGameDict = [@{} mutableCopy];
    [self setSwipeView];
    
    __weak __typeof(self)weakSelf = self;
    
    self.meTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getUserInfoData:nil];
    }];
    
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [self.view addSubview:self.meTableView];
    
    
    //    [self.meTableView registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoData:) name:kRefreshUserInfoNotification object:nil];
    
    [self getGamesRecordType];
}


- (void)setAaView {
    
    NSArray *aaArray = @[
                         @{@"title":@"提现中心", @"image":@"me_a_tikuan"},
                         @{@"title":@"分享赚钱", @"image":@"me_a_fenxiang"},
                         @{@"title":@"余额宝", @"image":@"me_a_yuEbao"},
                         @{@"title":@"资金明细", @"image":@"me_a_zijin"},
                         @{@"title":@"代理中心", @"image":@"me_a_daili"},
                         @{@"title":@"玩法规则", @"image":@"me_a_wanfa"},
                         @{@"title":@"帮助中心", @"image":@"me_a_help"},
                         @{@"title":@"游戏反馈", @"image":@"me_a_fankui"}];
    
    MeACollectionView *aaBackView = [[MeACollectionView alloc] initWithFrame:CGRectMake(0, 205+39, kSCREEN_WIDTH, 220-40)];
//    aaBackView.layer.cornerRadius = 5;
//    aaBackView.layer.masksToBounds = YES;
    aaBackView.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
    
    __weak __typeof(self)weakSelf = self;
    aaBackView.selectABlock = ^(NSDictionary *dict) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf selectItemString:dict[@"title"]];
    };
    
    [self.contentView addSubview:aaBackView];
    _aaView = aaBackView;
    
    aaBackView.model = aaArray;
}


#pragma mark - Top View 点击
- (void)onLabelViewClickEvent:(UITapGestureRecognizer *)gesture {
    if ([gesture view].tag == 1000) {

        PayTopUpTypeController *vc = [[PayTopUpTypeController alloc] init];
        vc.isHidTabBar = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([gesture view].tag == 1001) {
        [self onWithdrawal];
    } else if ([gesture view].tag == 1002) {
        BillTypeModel *model = [[BillTypeModel alloc] init];
        model = [[BillTypeModel alloc] init];
        model.icon = @"me_bill_jiangli";
        model.title = @"奖励记录";
        model.category = 10;
        model.tag = 1;
        
        [self selectItemModel:model];
    } else if ([gesture view].tag == 1003) {
        
        BillTypeModel *model = [[BillTypeModel alloc] init];
        model = [[BillTypeModel alloc] init];
        model.icon = @"me_bill_all";
        model.title = @"盈亏记录";
        model.category = 13;
        model.tag = 0;
        
        [self selectItemModel:model];
    }
   
}

#pragma mark -  A选择的 item
- (void)selectItemString:(NSString *)title {
    if ([title isEqualToString:@"提现中心"]) {
        PayWithdrawalCenterController *vc = [[PayWithdrawalCenterController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([title isEqualToString:@"分享赚钱"]) {
        [self goto_onShareBtn];
        return;
    } else if ([title isEqualToString:@"余额宝"]) {
        NSLog(@"me1111余额宝11111");
    } else if ([title isEqualToString:@"资金明细"]) {
        BillTypeViewController *vc = [[BillTypeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([title isEqualToString:@"代理中心"]) {
        [self onAgencyBtn];
        return;
    } else if ([title isEqualToString:@"玩法规则"]) {
        WKWebViewController *vc = [[WKWebViewController alloc] init];
        [vc loadWebURLSring:kWanFaJieSaoURL];
        vc.title = @"玩法规则";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if ([title isEqualToString:@"帮助中心"]) {
        NSLog(@"me111111111帮助中心");
    } else if ([title isEqualToString:@"游戏反馈"]) {
        GameFeedbackController *vc = [[GameFeedbackController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else {
        NSLog(@"未知 title");
    }
    
    [MBProgressHUD showTipMessageInWindow:title];
}

/// B
- (void)selectItemModel:(BillTypeModel *)model {
    // B bottom
    if ([model.title isEqualToString:@"扫雷记录"]) {
        NSLog(@"me11111111扫雷记录1");
    } else if ([model.title isEqualToString:@"禁抢记录"]) {
        NSLog(@"me1111111禁抢记录11");
    } else if ([model.title isEqualToString:@"牛牛记录"]) {
        NSLog(@"me1111111牛牛记录11");
    } else if ([model.title isEqualToString:@"幸运记录"]) {
        NSLog(@"me11111111幸运记录1");
    } else if ([model.title isEqualToString:@"接龙记录"]) {
        NSLog(@"me1111111龙记录11");
    } else if ([model.title isEqualToString:@"福利记录"]) {
        NSLog(@"me1111福利记录11111");
    } else {
        NSLog(@"未知 title");
    }
    
    BillViewController *vc = [[BillViewController alloc] init];
    vc.title = model.title;
    vc.sourceType = 1;
    vc.billTypeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)setSwipeView {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 205+39 + (220-40), kSCREEN_WIDTH, 5)];
    backView.backgroundColor = [UIColor colorWithHex:@"#DDDDDD"];
    [self.contentView addSubview:backView];
    
    self.type = STControllerTypeDisableBarScroll;
    
    BOOL disableBarScroll = YES;
    
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc] initWithFrame:CGRectMake(0, 205+39 + (220-40) + 5, kSCREEN_WIDTH, kBViewHeight)];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    //    _swipeTableView.swipeHeaderView = disableBarScroll?nil:self.tableViewHeader;
    _swipeTableView.swipeHeaderBar = self.segmentBar;
    _swipeTableView.swipeHeaderBarScrollDisabled = disableBarScroll;
    if (disableBarScroll) {
        _swipeTableView.swipeHeaderTopInset = 0;
    }
    _swipeTableView.layer.cornerRadius = 5;
    _swipeTableView.layer.masksToBounds = YES;
    [self.contentView addSubview:_swipeTableView];
    
    // edge gesture
    [_swipeTableView.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.screenEdgePanGestureRecognizer];
    
}
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

- (CustomSegmentControl * )segmentBar {
    if (nil == _segmentBar) {
//        self.segmentBar = [[CustomSegmentControl alloc] initWithTitles:@[@"红包游戏",@"棋牌游戏",@"电子游戏",@"休闲游戏"] images:@[@"me_title_hongbao",@"me_title_qipai",@"me_title_dianzi",@"me_title_xiuxian"]];
        self.segmentBar = [[CustomSegmentControl alloc] initWithTitles:@[@"红包游戏",@"棋牌游戏",@"电子游戏",@"休闲游戏"] images:nil];
        
        _segmentBar.st_size = CGSizeMake(kSCREEN_WIDTH, 38);
        _segmentBar.font = [UIFont systemFontOfSize:12];
        _segmentBar.textColor = [UIColor blackColor];
        _segmentBar.selectedTextColor = [UIColor redColor];
        _segmentBar.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
        _segmentBar.selectionIndicatorColor = [UIColor whiteColor];
        _segmentBar.selectedSegmentIndex = _swipeTableView.currentItemIndex;
        [_segmentBar addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentBar;
}
- (void)changeSwipeViewIndex:(UISegmentedControl *)seg {
    if (seg.selectedSegmentIndex > 0) {
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
        return;
    }
    [_swipeTableView scrollToItemAtIndex:seg.selectedSegmentIndex animated:NO];
    // request data at current index
    [self getDataAtIndex:seg.selectedSegmentIndex];
}


- (CustomCollectionView *)collectionView {
    if (nil == _collectionView) {
        _collectionView = [[CustomCollectionView alloc]initWithFrame:_swipeTableView.bounds];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (CustomCollectionView *)collectionViewB {
    if (nil == _collectionViewB) {
        _collectionViewB = [[CustomCollectionView alloc]initWithFrame:_swipeTableView.bounds];
        _collectionViewB.backgroundColor = [UIColor whiteColor];
    }
    return _collectionViewB;
}

#pragma mark - Data Reuqest

// 请求数据（根据视图滚动到相应的index后再请求数据）
- (void)getDataAtIndex:(NSInteger)index {
    //    if (nil != _billGameDict[@(index)]) {
    //        return;
    //    }
    //    NSArray *dataArr = _billGameDict[@(index)];
    //
    //    NSInteger numberOfRows = 0;
    //    switch (index) {
    //        case 0:
    //            numberOfRows = 6;
    //            break;
    //        case 1:
    //            numberOfRows = 3;
    //            break;
    //        case 2:
    //            numberOfRows = 2;
    //            break;
    //        case 3:
    //            numberOfRows = 2;
    //            break;
    //        default:
    //            break;
    //    }
    //    // 请求数据后刷新相应的item
    //    ((void (*)(void *, SEL, NSNumber *, NSInteger))objc_msgSend)((__bridge void *)(self.swipeTableView.currentItemView),@selector(refreshWithData:atIndex:), dataArr,index);
    //    // 保存数据
    //    [_billGameDict setObject:dataArr forKey:@(index)];
}


#pragma mark - SwipeTableView M

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 4;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    switch (_type) {
        case STControllerTypeHybrid:
        case STControllerTypeDisableBarScroll:
        case STControllerTypeHiddenNavBar:
        {
            if (index == 0 || index == 2) {
                CustomCollectionView * collectionView = self.collectionViewB;
                __weak __typeof(self)weakSelf = self;
                collectionView.selectBlock = ^(BillTypeModel *model) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf selectItemModel:model];
                };
                // 获取当前index下item的数据，进行数据刷新
                id data = _billGameDict[@(index)];
                [collectionView refreshWithData:data atIndex:index];
                
                view = self.collectionViewB;
            } else {
                CustomCollectionView * collectionView = self.collectionView;
                __weak __typeof(self)weakSelf = self;
                collectionView.selectBlock = ^(BillTypeModel *model) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    [strongSelf selectItemModel:model];
                };
                // 获取当前index下item的数据，进行数据刷新
                id data = _billGameDict[@(index)];
                [collectionView refreshWithData:data atIndex:index];
                
                view = self.collectionView;
            }
            
        }
            break;
        default:
            break;
    }
    
    return view;
}

// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _segmentBar.selectedSegmentIndex = swipeView.currentItemIndex;
}

// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    [self getDataAtIndex:swipeView.currentItemIndex];
}

/**
 *  以下两个代理，在未定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT，并自定义下拉刷新的时候，必须实现
 *  如果设置了下拉刷新的宏，以下代理可根据需要实现即可
 */
- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
}

- (CGFloat)swipeTableView:(SwipeTableView *)swipeTableView heightForRefreshHeaderAtIndex:(NSInteger)index {
    return 0;
}









#pragma mark - 收到消息重新刷新
- (void)getUserInfoData:(NSNotification *)noti {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"user/info"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf.meTableView.mj_header endRefreshing];
            [strongSelf updateUserInfo:response[@"data"]];
            [strongSelf.meTableView reloadData];
            //
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


/**
 更新用户信息
 */
-(void)updateUserInfo:(NSDictionary *)dict {
    AppModel *appModel = [AppModel mj_objectWithKeyValues:dict];
    [AppModel sharedInstance].user_info = appModel.user_info;
    [AppModel sharedInstance].user_info.isLogined = YES;
    [AppModel sharedInstance].assets = appModel.assets;
    [[AppModel sharedInstance] saveAppModel];
    
    [self updateMeInfoView];
}

- (void)setNavUI {
    
    UIBarButtonItem *rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_set_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonSetting:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor greenColor]}];
    
    //    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)rightBarButtonSetting:(UIBarButtonItem *)sender{
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserInfoData:nil];
    [self onMoneyBtn];
//    //把背景设为空
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //处理导航栏有条线的问题
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUD];
//    [self.navigationController.navigationBar setShadowImage:nil];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - vvUITableView
- (UITableView *)meTableView {
    if (!_meTableView) {
        _meTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT - Height_NavBar - Height_TabBar) style:UITableViewStylePlain];
        _meTableView.backgroundColor = [UIColor whiteColor];
        _meTableView.dataSource = self;
        _meTableView.delegate = self;
        //        self.meTableView.tableHeaderView = self.headView;
        //        if (@available(iOS 11.0, *)) {
        //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        _meTableView.rowHeight = 76;   // 行高
        _meTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _meTableView.estimatedRowHeight = 0;
        _meTableView.estimatedSectionHeaderHeight = 0;
        _meTableView.estimatedSectionFooterHeight = 0;
        _meTableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0 );
    }
    return _meTableView;
}


#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeTableViewCell"];
    if(cell == nil) {
        cell = [MeTableViewCell cellWithTableView:tableView reusableId:@"MeTableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.unusualMarkIndex = 100 + indexPath.row;
    }
    // 倒序
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    if ([dict[@"title"] isEqualToString:@"邀请码"]) {
        [self onCopyBtn];
    } else if ([dict[@"title"] isEqualToString:@"充值中心"]) {
        
    } else if ([dict[@"title"] isEqualToString:@"提现中心"]) {
        
        [self onWithdrawal];
    } else if ([dict[@"title"] isEqualToString:@"账单记录"]) {
        
        BillTypeViewController *vc = [[BillTypeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dict[@"title"] isEqualToString:@"银行卡"]) {
        
        BankCardManageController *vc = [[BankCardManageController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onWithdrawal {
    PayWithdrawalCenterController *vc = [[PayWithdrawalCenterController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onCopyBtn {
    NSString *s = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].user_info.userId];
    if(s.length == 0) {
        s = @"";
    }
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = s;
    [MBProgressHUD showSuccessMessage:@"复制成功"];
}


#pragma mark -  个人信息

- (void)gotoMeInfo {
    MeInfoViewController *vc = [[MeInfoViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.shareUrl = @"www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUI {
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, 205+220+kBViewHeight+45)];
    contentView.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
    _contentView = contentView;
    self.meTableView.tableHeaderView = contentView;
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"me_top_bg"];
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(205);
    }];
    
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
    headImageView.layer.cornerRadius = 55/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth = 1.5;
    headImageView.layer.borderColor = [UIColor colorWithRed:0.914 green:0.804 blue:0.631 alpha:1.000].CGColor;
    headImageView.userInteractionEnabled = YES;
    [backImageView addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(35);
        make.left.equalTo(backImageView.mas_left).offset(kMarginWidth);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [backImageView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top).offset(2);
        make.left.equalTo(headImageView.mas_right).offset(10);
    }];
    
    UIImageView *genderImageView = [[UIImageView alloc] init];
    genderImageView.image = [UIImage imageNamed:@"me_gender_woman"];
    [backImageView addSubview:genderImageView];
    _genderImageView = genderImageView;
    
    [genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UILabel *idLabel = [[UILabel alloc] init];
    idLabel.text = @"-";
    idLabel.font = [UIFont systemFontOfSize:10];
    idLabel.textColor = [UIColor colorWithHex:@"#D4D4D4"];
    idLabel.textAlignment = NSTextAlignmentLeft;
    [backImageView addSubview:idLabel];
    _idLabel = idLabel;
    
    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView.mas_bottom).offset(-2);
        make.left.equalTo(headImageView.mas_right).offset(10);
    }];
    
    // 个性签名
//    UILabel *desLabel = [[UILabel alloc] init];
//    desLabel.text = @"-";
//    desLabel.font = [UIFont systemFontOfSize:11];
//    desLabel.textColor = [UIColor whiteColor];
//    desLabel.textAlignment = NSTextAlignmentLeft;
//    [backImageView addSubview:desLabel];
//    _desLabel = desLabel;
//
//    [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headImageView.mas_bottom).offset(-2);
//        make.left.equalTo(nameLabel.mas_left);
//    }];
    
    UIButton *cclickBackViewBtn = [[UIButton alloc] init];
    [cclickBackViewBtn addTarget:self action:@selector(gotoMeInfo) forControlEvents:UIControlEventTouchUpInside];
    cclickBackViewBtn.backgroundColor = [UIColor clearColor];
    [backImageView addSubview:cclickBackViewBtn];
    [cclickBackViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_top);
        make.centerX.equalTo(headImageView.mas_centerX);
        make.bottom.equalTo(idLabel.mas_bottom);
        make.width.mas_equalTo(130);
    }];
    
    
    
    UIView *topBBView = [[UIView alloc] initWithFrame:CGRectMake(kMarginWidth, 205-(127-39), kSCREEN_WIDTH-kMarginWidth*2, 127)];
    topBBView.backgroundColor = [UIColor whiteColor];
    topBBView.layer.cornerRadius = 5;
    topBBView.layer.masksToBounds = YES;
    [self.contentView addSubview:topBBView];
    // 添加圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topBBView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
//     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//     maskLayer.frame = topBBView.bounds;
//     maskLayer.path = maskPath.CGPath;
//     topBBView.layer.mask = maskLayer;
    
    UIButton *moneyBackBtn = [UIButton new];
    [moneyBackBtn addTarget:self action:@selector(onMoneyBtn) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:moneyBackBtn];
//    moneyBackBtn.backgroundColor = [UIColor redColor];

    [moneyBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImageView.mas_centerY);
        make.right.equalTo(backImageView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
    
    
    UIImageView *moneyImageView = [[UIImageView alloc] init];
    moneyImageView.image = [UIImage imageNamed:@"me_money"];
    [moneyBackBtn addSubview:moneyImageView];

    [moneyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.top.equalTo(moneyBackBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(48, 32));
    }];

    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"-";
    moneyLabel.font = [UIFont systemFontOfSize:12];
    moneyLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [moneyBackBtn addSubview:moneyLabel];
    _moneyLabel = moneyLabel;

    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(moneyBackBtn.mas_centerX);
        make.bottom.equalTo(moneyBackBtn.mas_bottom).offset(-2);
    }];
    
    
    
    UIStackView *topStackView = [[UIStackView alloc] init];
        topStackView.backgroundColor = [UIColor greenColor];
    //子控件的布局方向
    topStackView.axis = UILayoutConstraintAxisHorizontal;
    topStackView.distribution = UIStackViewDistributionFillEqually;
    topStackView.spacing = 5;
    topStackView.alignment = UIStackViewAlignmentFill;
    //    _playerStackView.frame = CGRectMake(0, 100, ScreenWidth, 200);
    [topBBView addSubview:topStackView];
    [topStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topBBView);
        make.top.equalTo(topBBView.mas_top).offset(10);
        make.bottom.equalTo(topBBView.mas_centerY);
        //        make.left.top.right.bottom.equalTo(topBBView);
    }];
    
    MeTopViewTowLabel * topView0 = [[MeTopViewTowLabel alloc] init];
    //    topView1.backgroundColor = [UIColor greenColor];
     topView0.titleLabel.textColor = [UIColor colorWithHex:@"#F5901A"];
     topView0.titleLabel.font = [UIFont boldSystemFontOfSize:18];
     topView0.titleLabel.text = @"-";
     topView0.valueLabel.text = @"今日充值";
     topView0.valueLabel.textColor = [UIColor colorWithHex:@"#666666"];
     topView0.valueLabel.font = [UIFont systemFontOfSize:12];
    [topStackView addArrangedSubview: topView0];
    topView0.tag = 1000;
    _topView0 =  topView0;
    //添加手势事件
    UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelViewClickEvent:)];
    //将手势添加到需要相应的view中去
    [topView0 addGestureRecognizer:tapGesture0];
    //选择触发事件的方式（默认单机触发）
    [tapGesture0 setNumberOfTapsRequired:1];
    
    MeTopViewTowLabel *topView1 = [[MeTopViewTowLabel alloc] init];
//    topView1.backgroundColor = [UIColor greenColor];
    topView1.titleLabel.text = @"-";
    topView1.titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    topView1.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    topView1.valueLabel.text = @"今日提现";
    topView1.valueLabel.textColor = [UIColor colorWithHex:@"#666666"];
    topView1.valueLabel.font = [UIFont systemFontOfSize:12];
    [topStackView addArrangedSubview:topView1];
    topView1.tag = 1001;
    _topView1 = topView1;
    //添加手势事件
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelViewClickEvent:)];
    //将手势添加到需要相应的view中去
    [topView1 addGestureRecognizer:tapGesture1];
    //选择触发事件的方式（默认单机触发）
    [tapGesture1 setNumberOfTapsRequired:1];

    
    UIStackView *bottomStackView = [[UIStackView alloc] init];
    bottomStackView.backgroundColor = [UIColor orangeColor];
    //子控件的布局方向
    bottomStackView.axis = UILayoutConstraintAxisHorizontal;
    bottomStackView.distribution = UIStackViewDistributionFillEqually;
    bottomStackView.spacing = 5;
    bottomStackView.alignment = UIStackViewAlignmentFill;
    //    _playerStackView.frame = CGRectMake(0, 100, ScreenWidth, 200);
    [topBBView addSubview:bottomStackView];
    [bottomStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(topBBView);
        make.top.equalTo(topBBView.mas_centerY);
        make.bottom.equalTo(topBBView.mas_bottom).offset(-10);
        //        make.left.top.right.bottom.equalTo(topBBView);
    }];
    
    MeTopViewTowLabel *topView2 = [[MeTopViewTowLabel alloc] init];
    topView2.titleLabel.text = @"-";
    topView2.titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    topView2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    topView2.valueLabel.text = @"今日优惠";
    topView2.valueLabel.textColor = [UIColor colorWithHex:@"#666666"];
    topView2.valueLabel.font = [UIFont systemFontOfSize:12];
    [bottomStackView addArrangedSubview:topView2];
    topView2.tag = 1002;
    _topView2 = topView2;
    //添加手势事件
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelViewClickEvent:)];
    //将手势添加到需要相应的view中去
    [topView2 addGestureRecognizer:tapGesture2];
    //选择触发事件的方式（默认单机触发）
    [tapGesture2 setNumberOfTapsRequired:1];

    MeTopViewTowLabel *topView3 = [[MeTopViewTowLabel alloc] init];
    topView3.titleLabel.text = @"-";
    topView3.titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    topView3.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    topView3.valueLabel.text = @"今日盈利";
    topView3.valueLabel.textColor = [UIColor colorWithHex:@"#666666"];
    topView3.valueLabel.font = [UIFont systemFontOfSize:12];
    [bottomStackView addArrangedSubview:topView3];
    topView3.tag = 1003;
    _topView3 = topView3;
    //添加手势事件
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelViewClickEvent:)];
    //将手势添加到需要相应的view中去
    [topView3 addGestureRecognizer:tapGesture3];
    //选择触发事件的方式（默认单机触发）
    [tapGesture3 setNumberOfTapsRequired:1];
    
}

#pragma mark -  刷新余额
- (void)onMoneyBtn {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/assets"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        NSArray *payArray = [PayAssetsModel mj_objectArrayWithKeyValuesArray:cacheJson];
        [self moneyUpdate:payArray];
        [self updateMeInfoView];
    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *payArray = [PayAssetsModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [strongSelf moneyUpdate:payArray];
            [strongSelf updateMeInfoView];
            //
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)moneyUpdate:(NSArray *)array {
    for (PayAssetsModel *model in array) {
        if ([model.coin_name isEqualToString:@"GOLD"]) {
            self.assetsModel = model;
            break;
        }
    }
}

#pragma mark -  更新我的资产数据
- (void)updateMeInfoView {
    
    if ([AppModel sharedInstance].user_info.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", [AppModel sharedInstance].user_info.avatar]];
        if (image) {
            self.headImageView.image = image;
        } else {
            self.headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImageView cd_setImageWithURL:[NSURL URLWithString:[AppModel sharedInstance].user_info.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    NSInteger sex = [AppModel sharedInstance].user_info.sex;
    if(sex == 2) {
        self.genderImageView.image = [UIImage imageNamed:@"me_male"];
    } else {
        self.genderImageView.image = [UIImage imageNamed:@"me_female"];
    }
    self.nameLabel.text = [AppModel sharedInstance].user_info.name;
    self.idLabel.text = [NSString stringWithFormat:@"ID:%ld",[AppModel sharedInstance].user_info.userId];
    self.desLabel.text = [AppModel sharedInstance].user_info.des;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"余额:%@元", self.assetsModel.over_num ? self.assetsModel.over_num: @"0.00"];
    
    
    [self moneyUpdate:[AppModel sharedInstance].assets];
    self.topView0.titleLabel.text = [AppModel sharedInstance].user_info.recharge;
    self.topView1.titleLabel.text = [AppModel sharedInstance].user_info.withdraw;
    self.topView2.titleLabel.text = [AppModel sharedInstance].user_info.reward;
    self.topView3.titleLabel.text = [AppModel sharedInstance].user_info.profit;
}


- (void)onAgencyBtn {
    AgentCenterViewController *vc = [[AgentCenterViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 分享赚钱
 */
- (void)goto_onShareBtn {
    ShareDetailViewController *vc = [[ShareDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onLogin {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark -   获取游戏记录类型ITEM
- (void)getGamesRecordType {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/billGameDesc"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        NSArray *billArray = [BillTypeModel mj_objectArrayWithKeyValuesArray:cacheJson];
        [self billTypeArray:billArray];
    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *billArray = [BillTypeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [strongSelf billTypeArray:billArray];
            //
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)billTypeArray:(NSArray *)billArray {
    
    NSArray *redPacketArray = billArray;
    NSArray *qipaiArray = redPacketArray;
    NSArray *dianziArray = redPacketArray;
    NSArray *xiuxianArray = redPacketArray;
    
    [_billGameDict setObject:redPacketArray forKey:@(0)];
    [_billGameDict setObject:qipaiArray forKey:@(1)];
    [_billGameDict setObject:dianziArray forKey:@(2)];
    [_billGameDict setObject:xiuxianArray forKey:@(3)];
    
    [self.swipeTableView reloadData];
}
@end

