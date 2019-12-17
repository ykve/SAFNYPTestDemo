//
//  ContactsTypeController.m
//  WRHB
//
//  Created by AFan on 2019/11/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ContactsTypeController.h"
#import "SPPageMenu.h"
#import "JSBadgeView.h"
#import "BaseGameItemController.h"
#import <SDWebImage/UIImage+GIF.h>
#import "RedPacketItemController.h"
#import "DianZiItemController.h"
#import "QiPaiItemController.h"
#import "CasualItemController.h"

#import "YPContactsTableView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "YPContacts.h"
#import "AFContactCell.h"
#import "PinYinForObjc.h"

#import "MessageNet.h"
#import "ChatViewController.h"
#import "MessageItem.h"
#import "YPMenu.h"
#import "HelpCenterWebController.h"
#import "MessageViewController.h"
#import "BaseContactsController.h"
#import "AddMemberController.h"
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



#define kViewTag 666
#define kBannerHeight 120



#define scrollViewHeight (kSCREEN_HEIGHT-Height_NavBar-kTopItemHeight-Height_TabBar)

@interface ContactsTypeController ()<UITableViewDelegate,UITableViewDataSource, SPPageMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *topDataArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) JSBadgeView *badgeView0;
@property (nonatomic, strong) JSBadgeView *badgeView2;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *myChildViewControllers;

@property (nonatomic, strong) UIView *animationView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MessageNet *model;

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) EnterPwdBoxView *entPwdView;
@property (nonatomic, strong) GridCell *gridV;

@property (nonatomic ,strong) NSMutableArray *dataList;   // 群组

@property (nonatomic, strong) YPContactsTableView *contactTableView;
@property (nonatomic, strong) NSMutableArray *indexTitles;

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UISearchBar *contactsSearchBar;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic, strong) NSMutableArray *kefuArray;
@property (nonatomic, strong) NSMutableArray *haoyouArray;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, strong) NSMutableArray *sysArray;

@end

@implementation ContactsTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微聊";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNavUI];
    
    [self topItemView];
    [self topViewAddController];
    [self.view addSubview:self.scrollView];
    
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeView) name:kAddressBookUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageBadgeView:)name:kUnreadMessageNumberChange object:@"kUpdateSetBadgeValue"];
}

- (void)updateMessageBadgeView:(NSNotification *)notification {
    
    BOOL isRefresh = YES;
    if (([AppModel sharedInstance].lastBadgeNum > 100 && [AppModel sharedInstance].unReadAllCount > 100) || [AppModel sharedInstance].lastBadgeNum == [AppModel sharedInstance].unReadAllCount) {
        isRefresh = NO;
    }
    
    [AppModel sharedInstance].lastBadgeNum = [AppModel sharedInstance].unReadAllCount;
    
    if (isRefresh) {
        NSString *value = nil;
        if ([AppModel sharedInstance].unReadAllCount > 0) {
            if ([AppModel sharedInstance].unReadAllCount >= kMessageMaxNum) {
                value = @"99+";
            } else {
                value = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].unReadAllCount];
            }
        }
        
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
             __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.badgeView0.badgeText = value;
        });
    }
}

- (void)updateBadgeView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([AppModel sharedInstance].sysMessageNum > 0) {
            //        self.messageMumLabel.hidden = NO;
            self.badgeView2.badgeText = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].sysMessageNum];
        } else {
            //        self.messageMumLabel.hidden = YES;
            self.badgeView2.badgeText = @"";
        }
    });
}

- (void)setupNavUI {
    
    UIButton *redpiconBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [redpiconBtn setImage:[UIImage imageNamed:@"nav_contacts_serch"] forState:UIControlStateNormal];
    redpiconBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [redpiconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redpiconBtn addTarget:self action:@selector(goto_searchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *exItem = [[UIBarButtonItem alloc]initWithCustomView:redpiconBtn];
    UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [info setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
    [info addTarget:self action:@selector(rightBarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
    
    self.navigationItem.rightBarButtonItems = @[infoItem,exItem];
    
    
    self.contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, Height_TabBar, self.view.bounds.size.width, 40)];
    self.contactsSearchBar.delegate = self;
    [self.contactsSearchBar setPlaceholder:@"搜索联系人"];
    self.contactsSearchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.contactsSearchBar contentsController:self];
    
    self.searchDisplayController.active = NO;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
}



- (void)topItemView {
    self.topDataArr = nil;
    NSArray *images = nil;
    CGFloat imageTitleSpace = 8;
    UIEdgeInsets edgeI = UIEdgeInsetsMake(10, 20, 30, 20);
    self.topDataArr = @[@"我的消息",@"在线客服",@"我的好友",@"我的群组",@"系统消息"];
    images = @[@"cc_my_message",@"cc_kefu",@"cc_haoyou",@"cc_group",@"cc_sys_message"];
    
    
    
    
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kTopItemHeight) trackerStyle:SPPageMenuTrackerStyleLine];
    pageMenu.backgroundColor = [UIColor whiteColor];
    // 传递数组，默认选中第1个
    [pageMenu setItems:self.topDataArr selectedItemIndex:self.selectedItemIndex];
    pageMenu.itemTitleFont = [UIFont  systemFontOfSize:13];
    pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    
    
    SPPageMenuButtonItem *item0 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[0] image:[UIImage imageNamed:images[0]]];
    item0.imagePosition = SPItemImagePositionTop;
    item0.imageTitleSpace = imageTitleSpace;
//    item0.imageEdgeInsets = edgeI;
    [pageMenu setItem:item0 forItemAtIndex:0];
    
    SPPageMenuButtonItem *item1 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[1] image:[UIImage imageNamed:images[1]]];
    item1.imagePosition = SPItemImagePositionTop;
    item1.imageTitleSpace = imageTitleSpace;
//    item1.imageEdgeInsets = edgeI;
    [pageMenu setItem:item1 forItemAtIndex:1];
    
    SPPageMenuButtonItem *item2 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[2] image:[UIImage imageNamed:images[2]]];
    item2.imagePosition = SPItemImagePositionTop;
    item2.imageTitleSpace = imageTitleSpace;
//    item2.imageEdgeInsets = edgeI;
    [pageMenu setItem:item2 forItemAtIndex:2];
    
    SPPageMenuButtonItem *item3 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[3] image:[UIImage imageNamed:images[3]]];
    item3.imagePosition = SPItemImagePositionTop;
    item3.imageTitleSpace = imageTitleSpace;
//    item3.imageEdgeInsets = edgeI;
    [pageMenu setItem:item3 forItemAtIndex:3];
    
    SPPageMenuButtonItem *item4 = [SPPageMenuButtonItem itemWithTitle:self.topDataArr[4] image:[UIImage imageNamed:images[4]]];
    item4.imagePosition = SPItemImagePositionTop;
    item4.imageTitleSpace = imageTitleSpace;
//    item4.imageEdgeInsets = edgeI;
    [pageMenu setItem:item4 forItemAtIndex:4];
    
    NSArray *buttons = [pageMenu valueForKey:@"_buttons"];
    UIButton *button0 = [buttons objectAtIndex:0];
    JSBadgeView *badgeView0 = [[JSBadgeView alloc] initWithParentView:button0 alignment:JSBadgeViewAlignmentTopRight];
    badgeView0.badgePositionAdjustment = CGPointMake(-20, 20);
    badgeView0.badgeBackgroundColor = [UIColor redColor];
    badgeView0.badgeOverlayColor = [UIColor clearColor];
    badgeView0.badgeStrokeColor = [UIColor redColor];
    _badgeView0 = badgeView0;
    
    
    
    UIButton *button2 = [buttons objectAtIndex:2];
    JSBadgeView *badgeView2 = [[JSBadgeView alloc] initWithParentView:button2 alignment:JSBadgeViewAlignmentTopRight];
    badgeView2.badgePositionAdjustment = CGPointMake(-20, 20);
    badgeView2.badgeBackgroundColor = [UIColor redColor];
    badgeView2.badgeOverlayColor = [UIColor clearColor];
    badgeView2.badgeStrokeColor = [UIColor redColor];
     _badgeView2 = badgeView2;
    
    if ([AppModel sharedInstance].sysMessageNum > 0) {
//        self.messageMumLabel.hidden = NO;
        badgeView2.badgeText = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].sysMessageNum];
    } else {
//        self.messageMumLabel.hidden = YES;
        badgeView2.badgeText = @"";
    }
    
    
    pageMenu.delegate = self;
    // 给pageMenu传递外界的大scrollView，内部监听self.scrollView的滚动，从而实现让跟踪器跟随self.scrollView移动的效果
    pageMenu.bridgeScrollView = self.scrollView;
    
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    
}

- (UIImage *)gifImgImageStr:(NSString *)imgStr {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imgStr ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage sd_imageWithGIFData:imageData];
    return image;
}

- (void)topViewAddController {
    NSArray *controllerClassNames = [NSArray arrayWithObjects:@"MessageViewController",@"KeFuViewController",@"MyFriendListController",@"MyGroupListController",@"SysMessageListController", nil];
    for (int i = 0; i < self.topDataArr.count; i++) {
        if (controllerClassNames.count > i) {
            if (i == 0) {
                MessageViewController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
                [self addChildViewController:baseVc];
                // 控制器本来自带childViewControllers,但是遗憾的是该数组的元素顺序永远无法改变，只要是addChildViewController,都是添加到最后一个，而控制器不像数组那样，可以插入或删除任意位置，所以这里自己定义可变数组，以便插入(删除)(如果没有插入(删除)功能，直接用自带的childViewControllers即可)
                [self.myChildViewControllers addObject:baseVc];
            } else {
                BaseContactsController *baseVc = [[NSClassFromString(controllerClassNames[i]) alloc] init];
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
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, kSCREEN_WIDTH, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    
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
    
    
    
    if (toIndex == 0 || toIndex == 3) {
        UIViewController *targetViewController = self.myChildViewControllers[toIndex];
        // 如果已经加载过，就不再加载
        //    if ([targetViewController isViewLoaded]) return;
        
        targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * toIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
        [_scrollView addSubview:targetViewController.view];
    } else {
        BaseContactsController *targetViewController = self.myChildViewControllers[toIndex];
        targetViewController.selectedItemIndex = toIndex;
        // 如果已经加载过，就不再加载
        //    if ([targetViewController isViewLoaded]) return;
        
        targetViewController.view.frame = CGRectMake(kSCREEN_WIDTH * toIndex, 0, kSCREEN_WIDTH, scrollViewHeight);
        [_scrollView addSubview:targetViewController.view];
    }
   
    if (toIndex == 2) {
        self.badgeView2.badgeText = @"";
        [AppModel sharedInstance].sysMessageNum = 0;
    }
    
}


#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 这一步是实现跟踪器时刻跟随scrollView滑动的效果,如果对self.pageMenu.scrollView赋了值，这一步可省
    // [self.pageMenu moveTrackerFollowScrollView:scrollView];
}



- (void)groupChat:(ChatsModel *)model isNew:(BOOL)isNew{
    ChatViewController *vc = [ChatViewController chatsFromModel:model];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - 下拉菜单
- (NSMutableArray *)menuItems {
    if (!_menuItems) {
        __weak __typeof(self)weakSelf = self;
        _menuItems = [[NSMutableArray alloc] initWithObjects:
                      
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_addfriend"]
                                          title:@"添加好友"
                                         action:^(YPMenuItem *item) {
                                             AddMemberController *vc = [[AddMemberController alloc]init];
                                             vc.addType = AddType_Friend;
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_addgroup"]
                                          title:@"创建群组"
                                         action:^(YPMenuItem *item) {
                                             CreateGroupController *vc = [[CreateGroupController alloc] init];
                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      [YPMenuItem itemWithImage:[UIImage imageNamed:@"nav_moments"]
                                          title:@"我的圈圈"
                                         action:^(YPMenuItem *item) {
//                                             CreateGroupController *vc = [[CreateGroupController alloc] init];
//                                             [weakSelf.navigationController pushViewController:vc animated:YES];
                                         }],
                      
                      nil];
    }
    return _menuItems;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
//    [MBProgressHUD hideHUD];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}





//导航栏弹出
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    YPMenu *menu = [[YPMenu alloc] initWithItems:self.menuItems];
    menu.menuCornerRadiu = 5;
    menu.showShadow = NO;
    menu.minMenuItemHeight = 48;
    menu.titleColor = [UIColor darkGrayColor];
    menu.menuBackGroundColor = [UIColor whiteColor];
    [menu showFromNavigationController:self.navigationController WithX:[UIScreen mainScreen].bounds.size.width-32];
}


- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark -  搜索栏
// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchResults = [[NSMutableArray alloc]init];
    if (self.contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.contactsSearchBar.text]) {
        for (NSArray *section in self.haoyouArray) {
            for (YPContacts *contact in section)
            {
                if ([ChineseInclude isIncludeChineseInString:contact.name]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.name];
                    NSRange titleResult=[tempPinYinStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        [self.searchResults addObject:contact];
                    } else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [self.searchResults  addObject:contact];
                        }
                    }
                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.name];
                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleHeadResult.length>0) {
                        if (![self.searchResults containsObject:contact]) {
                            [self.searchResults  addObject:contact];
                        }
                    }
                } else {
                    NSRange titleResult=[contact.name rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [self.searchResults  addObject:contact];
                    }
                }
            }
        }
    } else if (self.contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.contactsSearchBar.text]) {
        
        for (NSArray *section in self.haoyouArray) {
            for (YPContacts *contact in section)
            {
                NSString *tempStr = contact.name;
                NSRange titleResult=[tempStr rangeOfString:self.contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResults addObject:contact];
                }
                
            }
        }
    }
    
}


// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    //    [UIView animateWithDuration:1.0 animations:^{
    //        self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
    //        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //
    //    }];
    return YES;
}
//-(void) setCorrectFocus {
//    [self.contactsSearchBar becomeFirstResponder];
//}
// 搜索
- (void)goto_searchBar:(UIBarButtonItem *)sender {
    
    self.contactTableView.tableView.tableHeaderView = self.contactsSearchBar;
    self.searchDisplayController.active = YES;
    [self.contactsSearchBar becomeFirstResponder];
    
    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    //    [UIView animateWithDuration:1.0 animations:^{
    //        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //
    //    }];
    //    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜索结束后，恢复原状
    //    [UIView animateWithDuration:1.0 animations:^{
    //        self.contactTableView.tableView.tableHeaderView = nil;
    //        self.contactTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //    }];
    
    if (self.contactsSearchBar.text.length == 0) {
        self.contactTableView.tableView.tableHeaderView = nil;
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.contactTableView.tableView.tableHeaderView = nil;
    self.contactTableView.frame = CGRectMake(0, 90, self.view.bounds.size.width, self.view.bounds.size.height-Height_NavBar-Height_TabBar);
}





#pragma mark - UITableViewDelegate  UITableViewDataSource

- (void)createTableView {
    _contactTableView = [[YPContactsTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _contactTableView.delegate = self;
    _contactTableView.hidden = YES;
    
    [self.view addSubview:self.contactTableView];
    
    __weak __typeof(self)weakSelf = self;
    self.contactTableView.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf queryContactsData];
    }];
    
}


- (NSArray *)sectionIndexTitlesForABELTableView:(YPContactsTableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    } else {
        if (self.selectedItemIndex == 2) {
            return self.indexTitles;
        }
        return nil;
    }
}

// 设置头部title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView )
    {
        return nil;
        
    }
    return nil;
    
}

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return 1;
    } else {
        
        return 0;
    }
    
}

//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.self.searchDisplayController.searchResultsTableView)  // 有搜索
    {
        return self.searchResults.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    AFContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [AFContactCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    cell.delegate = self;
    if (tableView == self.self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        YPContacts *contact = self.searchResults[indexPath.row];
        cell.model = contact;
        
    }
    
    return cell;
    
}

// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// 编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YPContacts *model;
    if (tableView == self.self.searchDisplayController.searchResultsTableView)
    {
        // 搜索结果显示
        model = self.searchResults[indexPath.row];
        
    }
//    [self goto_groupChat:model];
}



- (void)initData {
    self.kefuArray = [[NSMutableArray alloc] init];
    self.haoyouArray = [[NSMutableArray alloc] init];
    self.groupArray = [[NSMutableArray alloc] init];
    self.sysArray = [[NSMutableArray alloc] init];
    self.indexTitles = [NSMutableArray array];
}

@end

