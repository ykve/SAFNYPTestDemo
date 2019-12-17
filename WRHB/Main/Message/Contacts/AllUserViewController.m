//
//  AllUserViewController.m
//  Project
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "AllUserViewController.h"
#import "UserTableViewCell.h"

#import "SessionInfoModel.h"
#import "GroupHeadView.h"
#import "SelectContactsController.h"
#import "ChatsModel.h"

// 群成员控制器
@interface AllUserViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (nonatomic ,strong)  UITableView *tableView;

@property (nonatomic, strong) GroupHeadView *headView;

@end

@implementation AllUserViewController
+ (AllUserViewController *)allUser:(id)obj {
    AllUserViewController *vc = [[AllUserViewController alloc]init];
    vc.sessionModel = obj;
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupSubViews];
    
    [self updateGroupUser];
}

- (void)updateGroupUser {
    __weak __typeof(self)weakSelf = self;
    
    BOOL isGroupLord = NO;
    if (self.sessionModel.creator == [AppModel sharedInstance].user_info.userId) {
        isGroupLord = YES;
    }
    _headView = [GroupHeadView headViewWithModel:self.sessionModel showRow:999 isGroupLord:isGroupLord];
    
    _headView.headAddOrDeleteClick = ^(NSInteger index) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (index == 0) {
            // 添加群员
            [strongSelf addGroupMember];
        } else if (index == 1) {
            // 删减群员
            [strongSelf deleteGroupMember];
        } else {
//            [strongSelf gotoAllGroupUsers];
        }
    };
    _tableView.tableHeaderView = _headView;
    
}

- (void)addGroupMember {
    SelectContactsController *vc = [[SelectContactsController alloc] init];
    vc.title = @"添加群成员";
    vc.sessionId = self.chatsModel.sessionId;
    vc.addedArray = self.sessionModel.group_users;
    
    //    vc.groupId = self.chatsModel.sessionId;
    //    vc.addType = AddType_GroupMember;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)deleteGroupMember {
    SelectContactsController *vc = [[SelectContactsController alloc] init];
    vc.title = @"删除成员";
    vc.sessionId = self.chatsModel.sessionId;
    vc.addedArray = self.sessionModel.group_users;
    
    //    vc.groupId = self.chatsModel.sessionId;
    //    vc.addType = AddType_GroupMember;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ----- subView
- (void)setupSubViews {
    self.view.backgroundColor = BaseColor;
//    self.navigationItem.title = self.title;
//    self.navigationItem.title = @"所有成员";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    __weak __typeof(self)weakSelf = self;
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
////        [strongSelf getGroupUsersData];
//    }];
//
//    _tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//       __strong __typeof(weakSelf)strongSelf = weakSelf;
////        [strongSelf getGroupUsersData];
//    }];
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.sessionModel.group_users.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.isDelete = self.isDelete;
    cell.obj = self.sessionModel.group_users[indexPath.row];
    __weak __typeof(self)weakSelf = self;
    cell.deleteBtnBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
       BaseUserModel *model = strongSelf.sessionModel.group_users[indexPath.row];
        [strongSelf exit_group:model.userId];
        return;
    };
    
    return cell;
}



#pragma mark -  移除群组确认
/**
 移除群组确认
 */
-(void)exit_group:(NSInteger)userId {
    WEAK_OBJ(weakSelf, self);
    
    [[AlertViewCus createInstanceWithView:nil] showWithText:@"确认移除该玩家？" button1:@"取消" button2:@"确认" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1)
            [weakSelf action_exitGroup:userId];
    }];
}



/**
 删除群成员
 */
- (void)action_exitGroup:(NSInteger)userId {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"social/skChatGroup/delgroupMember"];

    entity.needCache = NO;
    NSDictionary *parameters = @{
                                 @"chatGroupId":@(self.groupId),
                                 @"userId":@(userId)
                                 };
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
            [MBProgressHUD showSuccessMessage:msg];
//            [strongSelf getGroupUsersData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

@end
