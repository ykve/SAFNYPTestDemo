//
//  ClubRoomMangaeController.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubRoomMangaeController.h"
#import "RoomMangaeCell.h"
#import "ClubManager.h"
#import "RoomMangaeModel.h"

@interface ClubRoomMangaeController ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;
///
@property (nonatomic, strong) RoomMangaeModel *selectedModel;

@end

@implementation ClubRoomMangaeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"房间管理";
    
    [self.view addSubview:self.tableView];
    [self getClubRoom];
    
    [self.tableView registerClass:[RoomMangaeCell class] forCellReuseIdentifier:@"RoomMangaeCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getClubRoom];
    }];
}

#pragma mark -  俱乐部里的房间
- (void)getClubRoom {
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/rooms"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *modelArray = [RoomMangaeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = modelArray;
            [strongSelf.tableView reloadData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  开启关闭游戏房间
- (void)setOpenClose:(NSInteger)type {
    
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID),
                                 @"session":@(self.selectedModel.ID),  // 房间
                                 @"status":@(type)  // 状态 1 开启 2 关闭   3 删除
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/room/modify"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInView:response[@"message"]];
            CGFloat delay = 0.5;
            if (type == 2) {
                delay = 2;
            }
            // 可以延时调用方法
            [strongSelf performSelector:@selector(getClubRoom) withObject:nil afterDelay:delay];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT- Height_NavBar) style:UITableViewStylePlain];
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
    
    RoomMangaeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomMangaeCell"];
    if(cell == nil) {
        cell = [RoomMangaeCell cellWithTableView:tableView reusableId:@"RoomMangaeCell"];
    }
    RoomMangaeModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    __weak __typeof(self)weakSelf = self;
    cell.roomOpenBlock = ^(RoomMangaeModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedModel = model;
        [strongSelf setOpenClose:1];
    };
    
    cell.roomClosedBlock = ^(RoomMangaeModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedModel = model;
        [strongSelf setOpenClose:2];
    };
    
    cell.roomDeleteBlock = ^(RoomMangaeModel *model) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedModel = model;
        [strongSelf setOpenClose:3];
    };
    
    
    return cell;
}




#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary *dict = self.dataArray[indexPath.row];

}


@end


