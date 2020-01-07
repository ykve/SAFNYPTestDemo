//
//  PayYSKefuChatHistoryRecordVC.m
//  WRHB
//
//  Created by AFan on 2019/12/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayYSKefuChatHistoryRecordVC.h"
#import "MessageTableViewCell.h"
#import "CServiceChatController.h"
#import "ChatsModel.h"
#import "WHC_ModelSqlite.h"
#import "PushMessageNumModel.h"
#import "CServiceChatController.h"

@interface PayYSKefuChatHistoryRecordVC ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PayYSKefuChatHistoryRecordVC

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"充值记录";
    
    [self getDataList];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"MessageTableViewCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    
    
}

#pragma mark - 获取客服历史聊天数据
- (void)getDataList {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSString *query = @"select * from PushMessageNumModel where chatSessionType = 8 group by sessionId  order by create_time desc";
        NSArray *ysKefuArray = [WHC_ModelSqlite query:[PushMessageNumModel class] sql:query];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (NSInteger index =0; index < ysKefuArray.count; index++) {
            PushMessageNumModel *pushModel = ysKefuArray[index];
            ChatsModel *model = [[ChatsModel alloc] init];
            model.sessionId = pushModel.sessionId;
            model.name = pushModel.name;
            model.avatar = pushModel.avatar;
            model.isJoinChatsList = YES;
            model.sessionType = ChatSessionType_YSCustomerService;
            [tmpArray addObject:model];
        }
        strongSelf.dataArray = [tmpArray copy];
        
        /*! 回到主线程刷新UI */
        dispatch_async(dispatch_get_main_queue(), ^{
            // 结束刷新
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView reloadData];
        });
    });
}




#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat height = kSCREEN_HEIGHT- Height_NavBar;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tableView.rowHeight = 70;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableViewCell"];
    if(cell == nil) {
        cell = [MessageTableViewCell cellWithTableView:tableView reusableId:@"MessageTableViewCell"];
    }
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatsModel *model = self.dataArray[indexPath.row];
    [self goto_Chat:model];
}


#pragma mark - goto聊天界面
- (void)goto_Chat:(ChatsModel *)chatsModel {
    CServiceChatController *vc = [CServiceChatController chatsFromModel:chatsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/// 退出动画
- (void)exitAnimation {
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}


@end

