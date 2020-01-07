//
//  SysMessageListController.m
//  WRHB
//
//  Created by AFan on 2019/11/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SysMessageListController.h"
#import "SysMessageListCell.h"
#import "WHC_ModelSqlite.h"
#import "SysMessageListModel.h"
#import "SPAlertController.h"
#import "UIView+AZGradient.h"  // 渐变色

@interface SysMessageListController ()<UITableViewDataSource, UITableViewDelegate>
///
@property (nonatomic, strong) UITableView *tableView;
///
@property (nonatomic, strong) NSMutableArray *dataArray;
///
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *readBtn;

@end

@implementation SysMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
//     self.view.backgroundColor = [UIColor redColor];
    
    [self setupUI];
    [self.view addSubview:self.tableView];
    
    [self getHistoryNotification];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHistoryNotification];
    }];
    
    [self.tableView registerClass:[SysMessageListCell class] forCellReuseIdentifier:@"SysMessageListCell"];
    /// 刷新会话信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHistoryNotification) name:kSysMessageListNotification object:@"kUpdateSysMessageList"];
}




- (void)setupUI {
    UIButton *deleteBtn = [UIButton new];
    deleteBtn.hidden = YES;
    [self.view addSubview:deleteBtn];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [deleteBtn setTitle:@"批量删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(onDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.cornerRadius = 44/2;
    deleteBtn.tag = 4000;
    [deleteBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FFA948"],[UIColor colorWithHex:@"#FF7F47"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    _deleteBtn = deleteBtn;
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_centerX).offset(-25);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *readBtn = [UIButton new];
    readBtn.hidden = YES;
    [self.view addSubview:readBtn];
    readBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [readBtn setTitle:@"标为已读" forState:UIControlStateNormal];
    [readBtn addTarget:self action:@selector(onReadBtn) forControlEvents:UIControlEventTouchUpInside];
    [readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    readBtn.layer.masksToBounds = YES;
    readBtn.layer.cornerRadius = 44/2;
    readBtn.tag = 4000;
    [readBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#50ACFF"],[UIColor colorWithHex:@"#1278EB"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [readBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    _readBtn = readBtn;
    [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-8);
        make.left.equalTo(self.view.mas_centerX).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.mas_equalTo(44);
    }];
}


- (void)setIsShowSelectImg:(BOOL)isShowSelectImg {
    _isShowSelectImg = isShowSelectImg;
//     self.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.frame.size.height);
    
    for (SysMessageListModel *model in self.dataArray) {
        model.isSelected = NO;
    }
    self.selectedArray = nil;
    if (isShowSelectImg) {
        self.deleteBtn.hidden = NO;
        self.readBtn.hidden = NO;
         self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.frame.size.height-60);
    } else {
        self.deleteBtn.hidden = YES;
        self.readBtn.hidden = YES;
         self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.frame.size.height);
    }
    
   
   
    [self.tableView reloadData];
}



- (void)getHistoryNotification {
    
    NSString *query = [NSString stringWithFormat:@"select * from SysMessageListModel where userId = %ld order by updateTime desc", (long)[AppModel sharedInstance].user_info.userId];
    
    NSArray *historyArray = [WHC_ModelSqlite query:[SysMessageListModel class] sql:query];
    if (historyArray.count == 0) {
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        [UnreadMessagesNumSingle sharedInstance].sysMessageListNum = 0;
        return;
    }
   
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.dataArray removeAllObjects];
        strongSelf.dataArray = nil;
        [strongSelf.dataArray addObjectsFromArray:historyArray];
        [strongSelf.tableView reloadData];
    });
    
}


#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-Height_NavBar-kTopItemHeight-Height_TabBar) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (@available(iOS 11.0, *)) {
            // 这句代码会影响 UICollectionView 嵌套使用
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tableView.rowHeight = 105;   // 行高
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
    SysMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SysMessageListCell"];
    if(cell == nil) {
        cell = [SysMessageListCell cellWithTableView:tableView reusableId:@"SysMessageListCell"];
    }
    
    cell.model = self.dataArray[indexPath.row];
    cell.isShowSelectImg = self.isShowSelectImg;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     SysMessageListModel *model = self.dataArray[indexPath.row];
    if (self.isShowSelectImg) {
        
        if (model.isSelected) {
            model.isSelected = NO;
            [self.selectedArray removeObject:model];
        } else {
            [self.selectedArray addObject:model];
             model.isSelected = YES;
        }
       
        [self.tableView reloadData];
    } else {
        [self showAlertViewModel:model];
    }
   
}

- (void)showAlertViewModel:(SysMessageListModel *)model {
     NSString *whereStr = [NSString stringWithFormat:@"updateTime=%ld",(long)model.updateTime];
    
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:model.title message:model.content preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    alertController.needDialogBlur = YES;
    
    __weak __typeof(self)weakSelf = self;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"删除" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            BOOL isSuccess = [WHC_ModelSqlite delete:[SysMessageListModel class] where:whereStr];
            if (!isSuccess) {
                NSLog(@"1");
            }
        });
        [strongSelf.dataArray removeObject:model];
        [strongSelf.tableView reloadData];
        NSLog(@"点击了删除");
        
        if (model.isReaded) {
            return;
        }
        [UnreadMessagesNumSingle sharedInstance].sysMessageListNum -= 1;

        /// 系统消息列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kSysMessageListNotification object: @"kUpdateBadgeView"];
    }];
    // SPAlertActionStyleDestructive默认文字为红色(可修改)
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"我知道了" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"点击了取消");
        if (model.isReaded) {
            return;
        }
        model.isReaded = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite update:model where:whereStr];
            if (!isSuccess) {
                NSLog(@"1");
            }
        });
        
        [UnreadMessagesNumSingle sharedInstance].sysMessageListNum -= 1;
        /// 系统消息列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kSysMessageListNotification object: @"kUpdateBadgeView"];
        [strongSelf.tableView reloadData];
    }];
    // 设置第2个action的颜色
    action2.titleColor = [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onDeleteBtn {
    NSInteger mesNum = 0;
    for (SysMessageListModel *model in self.selectedArray) {
        if (!model.isReaded) {
            mesNum++;
        }
        NSString *whereStr = [NSString stringWithFormat:@"updateTime=%ld",(long)model.updateTime];
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //            __strong __typeof(weakSelf)strongSelf = weakSelf;
            BOOL isSuccess = [WHC_ModelSqlite delete:[SysMessageListModel class] where:whereStr];
            if (!isSuccess) {
                NSLog(@"1");
            }
        });
        [self.dataArray removeObject:model];
    }
    [self.selectedArray removeAllObjects];
    
    [UnreadMessagesNumSingle sharedInstance].sysMessageListNum -= mesNum;
    /// 系统消息列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kSysMessageListNotification object: @"kUpdateBadgeView"];
    [self.tableView reloadData];
}
- (void)onReadBtn {
    
    NSInteger mesNum = 0;
    for (SysMessageListModel *model in self.selectedArray) {
        NSString *whereStr = [NSString stringWithFormat:@"updateTime=%ld",(long)model.updateTime];
         model.isSelected = NO;
        if (model.isReaded) {
            continue;
        }
        mesNum++;
        model.isReaded = YES;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL isSuccess = [WHC_ModelSqlite update:model where:whereStr];
            if (!isSuccess) {
                NSLog(@"1");
            }
        });
    }
    [self.selectedArray removeAllObjects];
    
    [UnreadMessagesNumSingle sharedInstance].sysMessageListNum -= mesNum;
    
    /// 系统消息列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kSysMessageListNotification object: @"kUpdateBadgeView"];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}
@end
