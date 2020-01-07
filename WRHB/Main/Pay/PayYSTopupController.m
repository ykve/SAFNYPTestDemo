//
//  PayYSTopupController.m
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayYSTopupController.h"
#import "YSTopupListCell.h"
#import "ClubPropertyController.h"
#import "ClubRoomMangaeController.h"
#import "SPAlertController.h"
#import "ClubManager.h"
#import "ClubMemberManageController.h"
#import "ClubBillController.h"
#import "YSTopupListModel.h"
#import "CServiceChatController.h"
#import "ChatsModel.h"

@interface PayYSTopupController ()<UITableViewDataSource, UITableViewDelegate>


@end

@implementation PayYSTopupController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    [self.tableView registerClass:[YSTopupListCell class] forCellReuseIdentifier:@"YSTopupListCell"];
    [self tableViewInit];
    [self.view addSubview:self.tableView];
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
     [self getDataList];
}


#pragma mark - 获取数据
- (void)getDataList {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/business"];
    entity.needCache = NO;
    
//    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
//    if (cacheJson) {
//        NSArray *array = [YSTopupListModel mj_objectArrayWithKeyValuesArray:cacheJson];
//        self.dataArray = [array copy];
//        [self.tableView reloadData];
//    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
//    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.dataArray = [NSMutableArray array];
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [YSTopupListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [array copy];
            [strongSelf.tableView reloadData];
            
//            if (strongSelf.dataArray.count > 0) {
//                [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
//                    NSLog(@"1");
//                }];
//            }
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        [self showPlaceholderDefaultView];
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        strongSelf.dataArray = [NSMutableArray array];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
        
        [self showPlaceholderDefaultView];
    } progressBlock:nil];
    
}


/**
 设置角标
 */
- (void)updateSetBadgeValue:(NSNotification *)notification {
    
    __weak __typeof(self)weakSelf = self;
    /*! 回到主线程刷新UI */
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
    
}


#pragma mark - vvUITableView
- (void)tableViewInit {
    if (!self.tableView) {
        
        CGFloat height = kSCREEN_HEIGHT- Height_NavBar -Height_TabBar - 50;
        if (self.isHidTabBar) {
            height = kSCREEN_HEIGHT- Height_NavBar - 50;
        }
        UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        //        _tableView.rowHeight = 44;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        self.tableView = _tableView;
    }
}


#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSTopupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSTopupListCell"];
    if(cell == nil) {
        cell = [YSTopupListCell cellWithTableView:tableView reusableId:@"YSTopupListCell"];
    }
    YSTopupListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSTopupListModel *model = self.dataArray[indexPath.row];
    
    [self createServiceSession:model];
}

#pragma mark -  盈商客服会话创建
/**
 客服会话创建
 */
- (void)createServiceSession:(YSTopupListModel *)model {
    
    NSDictionary *parameters = @{@"id":@(model.ID)};
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/createBusiness"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            ChatsModel *chatsModel = [[ChatsModel alloc] init];
            chatsModel.sessionId = [response[@"data"][@"session"] integerValue];;
            chatsModel.name = response[@"data"][@"title"];
            chatsModel.avatar = model.avatar;
            chatsModel.userId = model.ID;
            chatsModel.kefuType = 1;
            chatsModel.sessionType = ChatSessionType_YSCustomerService;
            
            [strongSelf goto_CServiceChat:chatsModel ysModel:model];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)goto_CServiceChat:(ChatsModel *)chatsModel ysModel:(YSTopupListModel *)ysModel {
    CServiceChatController *vc = [CServiceChatController chatsFromModel:chatsModel];
    vc.ysTopupListModel = ysModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)exitClub:(NSString *)string {
    
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    
    if ([string isEqualToString:@"退出"]) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/leave"];
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/disband"];  // 解散
    }
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccessMessage:response[@"message"]];
            //  
            [strongSelf performSelector:@selector(exitAnimation) withObject:nil afterDelay:1.5];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

/// 退出动画
- (void)exitAnimation {
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}



@end
