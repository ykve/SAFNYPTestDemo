//
//  FriendChatInfoController.m
//  WRHB
//
//  Created by AFan on 2019/6/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "FriendChatInfoController.h"
#import "UserTableViewCell.h"
#import "RCDBaseSettingTableViewCell.h"
#import "FriendChatInfoHeadCell.h"
#import "WHC_ModelSqlite.h"
#import "SPAlertController.h"
#import "ChatsModel.h"
#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "SqliteManage.h"


static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";


// 群成员控制器
@interface FriendChatInfoController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)  UITableView *tableView;

@end

@implementation FriendChatInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人聊天信息";

    [self setupSubViews];

}

#pragma mark ----- subView
- (void)setupSubViews {
    self.view.backgroundColor = BaseColor;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
//    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDBaseSettingTableViewCell *cellee = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cellee) {
        cellee = [[RCDBaseSettingTableViewCell alloc] init];
    }
    
    if (indexPath.section == 3) {
        // 1.定义一个cell的标识
        static NSString *ID = @"reuseIdentifier";
        // 2.从缓存池中取出cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = [UIColor redColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
        
        nameLabel.text = @"删除";
        return cell;
    }
    
    if (indexPath.section == 0) {
        [cellee setCellStyle:SwitchStyle];
        cellee.leftLabel.text = @"消息免打扰";
        
        NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", self.chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
        // 读取
        BOOL isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
        cellee.switchButton.on = isSwitch;
        
        [cellee.switchButton addTarget:self
                                action:@selector(onSwitchNotDisturb:)
                      forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 1) {
        [cellee setCellStyle:SwitchStyle];
        cellee.leftLabel.text = @"置顶聊天";
        cellee.switchButton.hidden = NO;
       
        NSString *queryId = [NSString stringWithFormat:@"%ld_%ld", self.chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
        PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
        
        cellee.switchButton.on = pmModel.isTopChat;
        
        [cellee.switchButton addTarget:self
                                action:@selector(onSwitchTop:)
                      forControlEvents:UIControlEventValueChanged];
        
    } else if (indexPath.section == 100) {
//        [cellee setCellStyle:DefaultStyle];
//        cellee.leftLabel.text = @"查找聊天记录";
    } else if (indexPath.section == 2) {
        [cellee setCellStyle:DefaultStyle];
        cellee.leftLabel.text = @"清空聊天记录";
    }
    cellee.leftLabel.font = [UIFont systemFontOfSize2:15];
    return cellee;
    
}

#pragma mark - UITableViewDelegate
// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self showActionSheetClearChatHistory];
    } else if (indexPath.section == 3) {
        [self showActionSheetDelete];
    }
}
//
- (void)showActionSheetClearChatHistory {
    
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.needDialogBlur = YES;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"清空聊天记录" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
         [MBProgressHUD showActivityMessageInView:nil];
        NSString *whereStr = [NSString stringWithFormat:@"userId = '%ld' and sessionId='%zd'",[AppModel sharedInstance].user_info.userId,self.chatsModel.sessionId];
        [WHC_ModelSqlite delete:[YPMessage class] where:whereStr];
//                [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"已清空聊天记录"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatContentNotification object:nil];
    }];
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了Cancel");
    }];
    action2.titleFont = [UIFont systemFontOfSize:15];
    action2.titleColor = [UIColor blackColor];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)showActionSheetDelete {
    
    NSString *name = self.contacts.nickName ? self.contacts.nickName : self.contacts.name;
    
    NSString *text = [NSString stringWithFormat:@"将联系人“%@”删除，同时删除与该联系人得聊天记录", name];
    
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:text preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.needDialogBlur = YES;
    alertController.messageFont = [UIFont systemFontOfSize:12];
    alertController.messageColor = [UIColor colorWithHex:@"#555555"];
    
    __weak __typeof(self)weakSelf = self;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"删除联系人" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        NSLog(@"11");
        [strongSelf deleteRequest];
    }];
//    action1.titleFont = [UIFont systemFontOfSize:15];
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了Cancel");
    }];
    action2.titleColor = [UIColor blackColor];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:^{}];
}

/// 删除好友
- (void)deleteRequest {
    
    NSDictionary *parameters = @{
                                 @"user":@(self.contacts.user_id)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/delete"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
                NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",self.chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
                [[MessageSingle sharedInstance].unreadAllMessagesDict removeObjectForKey:queryId];
                [SqliteManage removePushMessageNumModelSql:self.chatsModel.sessionId];
            
                /// 移除消息数量
                PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
                [UnreadMessagesNumSingle sharedInstance].myMessageUnReadCount = pmModel.number;
            
            // 通讯录会话变更更新
            [[NSNotificationCenter defaultCenter] postNotificationName: kAddressBookUpdateNotification object: nil];
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void)onSwitchTop:(id)sender {
    UISwitch *swch = sender;
    
    NSString *queryId = [NSString stringWithFormat:@"%ld_%ld", self.chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
    PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
    pmModel.isTopChat = swch.on;
    if (swch.on) {
        pmModel.isTopTime = [NSDate date];
    } else {
        NSDate *date = nil;
        pmModel.isTopTime = date;
    }
    
    [[MessageSingle sharedInstance].unreadAllMessagesDict setObject:pmModel forKey:queryId];
    
    NSString *whereStr = [NSString stringWithFormat:@"sessionId=%zd and userId=%zd",self.chatsModel.sessionId, [AppModel sharedInstance].user_info.userId];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [WHC_ModelSqlite update:pmModel where:whereStr];
        if (!isSuccess) {
            NSLog(@"1");
        }
    });
    
}

- (void)onSwitchNotDisturb:(id)sender {

    UISwitch *swch = sender;
    NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", self.chatsModel.sessionId,[AppModel sharedInstance].user_info.userId];
    //保存
    [[NSUserDefaults standardUserDefaults] setBool:swch.on forKey:switchKeyStr];
}


#pragma mark -  移除群组确认
/**
 移除群组确认
 */
-(void)exit_group:(NSString *)userId {
    WEAK_OBJ(weakSelf, self);
    
//    [[AlertViewCus createInstanceWithView:nil] showWithText:@"确认移除该玩家？" button1:@"取消" button2:@"确认" callBack:^(id object) {
//        NSInteger tag = [object integerValue];
//        if(tag == 1)
//            [weakSelf exitGroupRequest:userId];
//    }];
}






/**
 删除群成员
 */
//- (void)exitGroupRequest:(NSString *)userId {
//
//    BADataEntity *entity = [BADataEntity new];
//    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"social/skChatGroup/delgroupMember"];
//
//    entity.needCache = NO;
//    NSDictionary *parameters = @{
//                                 @"chatGroupId":self.groupId,
//                                 @"userId":userId,
//                                 };
//    entity.parameters = parameters;
//
//    __weak __typeof(self)weakSelf = self;
//    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 0) {
//            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
//            [MBProgressHUD showSuccessMessage:msg);
//            strongSelf.model.page = 1;
//        } else {
//            [[AFHttpError sharedInstance] handleFailResponse:response];
//        }
//    } failureBlock:^(NSError *error) {
//        [[AFHttpError sharedInstance] handleFailResponse:error];
//    } progressBlock:nil];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

