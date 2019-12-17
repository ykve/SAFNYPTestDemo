//
//  ClubManageController.m
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubManageController.h"
#import "ClubManageTableViewCell.h"
#import "ClubPropertyController.h"
#import "ClubRoomMangaeController.h"
#import "SPAlertController.h"
#import "ClubManager.h"
#import "ClubMemberManageController.h"
#import "ClubBillController.h"

@interface ClubManageController ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ClubManageController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kApplicationJoinClubNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.title = @"俱乐部管理";
    
    NSString *title = @"退出";
    _dataArray = @[
                   @{@"title":title,@"image":@"club_exit"}];
    if ([ClubManager sharedInstance].clubInfo.role == 2 || [ClubManager sharedInstance].clubInfo.role == 3) {
        title = @"解散俱乐部";
        _dataArray = @[
                       @{@"title":@"俱乐部属性",@"image":@"club_property"},
                       @{@"title":@"成员管理",@"image":@"club_member_manage"},
                       @{@"title":@"房间管理",@"image":@"club_room_manage"},
                       @{@"title":@"俱乐部账单",@"image":@"club_bill"},
                       @{@"title":title,@"image":@"club_exit"}];
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[ClubManageTableViewCell class] forCellReuseIdentifier:@"ClubManageTableViewCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSetBadgeValue:)name:kApplicationJoinClubNotification object:nil];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT- Height_NavBar -Height_TabBar) style:UITableViewStylePlain];
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
    
    ClubManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClubManageTableViewCell"];
    if(cell == nil) {
        cell = [ClubManageTableViewCell cellWithTableView:tableView reusableId:@"ClubManageTableViewCell"];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.headView.image = [UIImage imageNamed:dict[@"image"]];
    cell.titleLabel.text = dict[@"title"];
    if ([AppModel sharedInstance].appltJoinClubNum > 0 && indexPath.row == 1) {
        cell.messageNumLabel.hidden = NO;
        cell.messageNumLabel.text = [NSString stringWithFormat:@"%zd", [AppModel sharedInstance].appltJoinClubNum];
    } else {
        cell.messageNumLabel.hidden = YES;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if ([dict[@"title"] isEqualToString:@"俱乐部属性"]) {
        ClubPropertyController *vc = [[ClubPropertyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dict[@"title"] isEqualToString:@"成员管理"]) {
        
        ClubMemberManageController *vc = [[ClubMemberManageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dict[@"title"] isEqualToString:@"房间管理"]) {
        
        ClubRoomMangaeController *vc = [[ClubRoomMangaeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dict[@"title"] isEqualToString:@"俱乐部账单"]) {
        
        ClubBillController *vc = [[ClubBillController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dict[@"title"] isEqualToString:@"退出"] || [dict[@"title"] isEqualToString:@"解散俱乐部"]) {
        [self popSelectAlert:dict[@"title"]];
    }
}


// alert 默认动画(收缩动画)
- (void)popSelectAlert:(NSString *)string {
    
    NSString *msg = @"确定解散俱乐部吗？";
    if ([string isEqualToString:@"退出"]) {
        msg = @"确定退出俱乐部吗？";
    }
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:msg message:nil preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    //    alertController.needDialogBlur = _lookBlur;
    
    __weak __typeof(self)weakSelf = self;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"确定" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"点击了确定");
        [strongSelf exitClub:string];
    }];
    // SPAlertActionStyleDestructive默认文字为红色(可修改)
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    // 设置第2个action的颜色
    action2.titleColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
            // 可以延时调用方法
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
