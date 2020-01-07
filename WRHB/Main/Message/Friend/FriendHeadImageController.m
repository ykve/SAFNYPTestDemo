//
//  FriendHeadImageController.m
//  WRHB
//
//  Created by AFan on 2019/12/24.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "FriendHeadImageController.h"
#import "HeadImageTopCell.h"
#import "HeadImageArrowCell.h"
#import "HeadImageAVCell.h"
#import "WHC_ModelSqlite.h"
#import "ChatViewController.h"
#import "UpdateRemarkNameController.h"
#import "FriendChatInfoController.h"


static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";


// 群成员控制器
@interface FriendHeadImageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)  UITableView *tableView;
@property (nonatomic ,strong)  NSArray *dataArray;
@end

@implementation FriendHeadImageController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *info = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [info setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [info setImage:[UIImage imageNamed:@"fc_more"] forState:UIControlStateNormal];
    [info addTarget:self action:@selector(rightBarButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc]initWithCustomView:info];
    
    //    self.navigationItem.rightBarButtonItems = @[infoItem,exItem];
    
    self.navigationItem.rightBarButtonItems = @[infoItem];
    
    
    [self setupSubViews];
    
    _dataArray = @[
                   @{@"title": @""},
                   @{@"title": @"设备备注和标签"},
                   @{@"title": @""},
//                   @{@"title": @"朋友圈"},
                   @{@"title": @"更多信息"},
                   @{@"title": @""},
                   @{@"title": @"发消息", @"image": @"fc_mess"},
                   @{@"title": @"音视频通话", @"image": @"fc_video"}];
}

- (void)rightBarButtonDown:(UIButton *)sender {
    
    NSString *userId = [NSString stringWithFormat:@"%ld_%ld",self.userId,[AppModel sharedInstance].user_info.userId];
    YPContacts *contact = [[AppModel sharedInstance].myFriendListDict objectForKey:userId];
    [self goto_FriendChatInfo:contact];
}

/**
 好友聊天信息页
 
 @param contacts 联系人模型
 */
- (void)goto_FriendChatInfo:(YPContacts *)contacts {
    [self.view endEditing:YES];
    FriendChatInfoController *vc = [[FriendChatInfoController alloc] init];
    vc.contacts = contacts;
    vc.chatsModel = self.chatsModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ----- subView
- (void)setupSubViews {
    
    _tableView = [UITableView normalTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:@"#EDEDED"];
    //    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   NSDictionary *dict = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        HeadImageTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadImageTopCell"];
        if (cell == nil) {
            cell = [[HeadImageTopCell alloc]initWithStyle:0 reuseIdentifier:@"HeadImageTopCell"];
        }
        cell.userId = self.userId;
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 3) {
        HeadImageArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadImageArrowCell"];
        if (cell == nil) {
            cell = [[HeadImageArrowCell alloc]initWithStyle:0 reuseIdentifier:@"HeadImageArrowCell"];
        }
        cell.titleLabel.text = dict[@"title"];
        //        cell.contacts = self.contacts;
        return cell;
    } else if (indexPath.row == 5 || indexPath.row == 6) {
        HeadImageAVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadImageAVCell"];
        if (cell == nil) {
            cell = [[HeadImageAVCell alloc]initWithStyle:0 reuseIdentifier:@"HeadImageAVCell"];
        }
        cell.titleLabel.text = dict[@"title"];
        cell.headImage.image = [UIImage imageNamed:dict[@"image"]];
        //        cell.contacts = self.contacts;
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 105;
    } else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 6) {
        return 55;
    } else if (indexPath.row == 2 || indexPath.row == 4) {
        return 10;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        NSString *userId = [NSString stringWithFormat:@"%ld_%ld",self.userId,[AppModel sharedInstance].user_info.userId];
        YPContacts *contact = [[AppModel sharedInstance].myFriendListDict objectForKey:userId];
        
        UpdateRemarkNameController *vc = [[UpdateRemarkNameController alloc] init];
        vc.contact = contact;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 5) {
        [self goto_Chat:self.chatsModel];
    } else if (indexPath.row == 6) {
        [MBProgressHUD showTipMessageInWindow:@"敬请期待"];
    }
}

#pragma mark - goto聊天界面
- (void)goto_Chat:(ChatsModel *)chatsModel {
    ChatViewController *vc = [ChatViewController chatsFromModel:chatsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
