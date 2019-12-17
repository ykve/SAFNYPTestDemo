//
//  GroupInfoViewController.m
//  Project
//
//  Created by AFan on 2019/11/9.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "GroupInfoViewController.h"
#import "MessageItem.h"
#import "GroupHeadView.h"
#import "AllUserViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "AddMemberController.h"
#import "NSString+Size.h"
#import "SqliteManage.h"
#import "ImageDetailViewController.h"

#import "ChatsModel.h"
#import "SessionInfoModel.h"
#import "SelectContactsController.h"
#import "UpdateGroupNameController.h"
#import "UpdateGroupInfoController.h"

static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";

@interface GroupInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GroupHeadView *headView;
@property (nonatomic, assign) BOOL enableNotification;
@property (nonatomic, strong) ChatsModel *chatsModel;

@end


@implementation GroupInfoViewController

+ (GroupInfoViewController *)groupVc:(ChatsModel *)model{
    GroupInfoViewController *vc = [[GroupInfoViewController alloc]init];
    vc.chatsModel = model;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self initLayout];
    [self updateGroupUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSessionInfoData) name:kReloadMyMessageGroupList object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)updateGroupUser {
    __weak __typeof(self)weakSelf = self;
    
    BOOL isGroupLord = NO;
    if (self.sessionModel.creator == [AppModel sharedInstance].user_info.userId) {
        isGroupLord = YES;
    }
    _headView = [GroupHeadView headViewWithModel:self.sessionModel showRow:3 isGroupLord:isGroupLord];
    
    _headView.headAddOrDeleteClick = ^(NSInteger index) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (index == 0) {
            // 添加群员
            [strongSelf addGroupMember];
        } else if (index == 1) {
            // 删减群员
            [strongSelf deleteGroupMember];
        } else {
            [strongSelf gotoAllGroupUsers];
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


#pragma mark -  退出群组
/**
 退出群组确认
 */
-(void)exit_group:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"解散群组"]) {
        WEAK_OBJ(weakSelf, self);
        [[AlertViewCus createInstanceWithView:nil] showWithText:@"是否解散群组？" button1:@"取消" button2:@"确认解散" callBack:^(id object) {
            NSInteger tag = [object integerValue];
            if(tag == 1)
                [weakSelf action_exitGroup:1];
        }];
        return;
    }
    WEAK_OBJ(weakSelf, self);
    [[AlertViewCus createInstanceWithView:nil] showWithText:@"是否退出该群？" button1:@"取消" button2:@"退出" callBack:^(id object) {
        NSInteger tag = [object integerValue];
        if(tag == 1)
            [weakSelf action_exitGroup:0];
    }];
}

/**
 退出群组请求  退群 | 解散
 */
- (void)action_exitGroup:(NSInteger)type {
    
    BADataEntity *entity = [BADataEntity new];
    if (type == 1) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/disband"]; // 解散
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/leaveSession"]; // 退出会话
    }
    
    NSDictionary *parameters = @{
                                 @"session":@(self.chatsModel.sessionId)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
            
            [SqliteManage removeGroupSql:strongSelf.chatsModel.sessionId];
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
            [MBProgressHUD showSuccessMessage:msg];
            [strongSelf.navigationController popToViewController:[strongSelf.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark - Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.left.right.equalTo(self.view);
        
        if (@available(iOS 11.0, *)) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view);
        }
        
    }];
}

#pragma mark - subView
- (void)setupSubViews{
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"群信息";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = 50;
    _tableView.sectionFooterHeight = 8.0f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    
    if (self.chatsModel.sessionType == ChatSessionType_ManyPeople_NormalChat) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        
        UIButton *exitBtn = [[UIButton alloc] init];
        [footView addSubview:exitBtn];
        
        exitBtn.layer.cornerRadius = 5;
        exitBtn.layer.masksToBounds = YES;
        //    exitBtn.backgroundColor = MBTNColor;
        exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
        
        if (self.sessionModel.creator == [AppModel sharedInstance].user_info.userId) {
            [exitBtn setTitle:@"解散群组" forState:UIControlStateNormal];
        } else {
            [exitBtn setTitle:@"删除并退出" forState:UIControlStateNormal];
        }
        
        [exitBtn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(exit_group:) forControlEvents:UIControlEventTouchUpInside];
        
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footView.mas_centerY);
            make.centerX.equalTo(footView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH -15*2, 45));
        }];
        
        _tableView.tableFooterView = footView;
    }
    
    
    
}

#pragma mark - 获取会话信息数据 获取群成员
- (void)getSessionInfoData {
    NSDictionary *parameters = @{
                                 @"session":@(self.chatsModel.sessionId)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/session/info"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.sessionModel = [SessionInfoModel mj_objectWithKeyValues:response[@"data"]];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (BaseUserModel *model in strongSelf.sessionModel.group_users) {
                [dict setObject:model forKey:[NSString stringWithFormat:@"%ld_%ld", self.chatsModel.sessionId, model.userId]];   // 用户昵称
            }
            [AppModel sharedInstance].myGroupFriendListDict = [dict copy];
            [strongSelf updateGroupUser];
            [strongSelf.tableView reloadData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (section == 0)?5:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = nil;
    if (indexPath.row == 0) {
        text = self.chatsModel.name;
    } else if (indexPath.row == 1) {
        text = self.sessionModel.notice;
    } else if (indexPath.row == 2) {
        text = self.sessionModel.desc;
    } else if (indexPath.row == 3) {
        text = self.sessionModel.group_regulation;
    } else if (indexPath.row == 4) {
        text = self.sessionModel.play_type_notice;
    } else {
        return 48;
    }
    CGFloat height =  [text heightWithFont:[UIFont systemFontOfSize2:14] constrainedToWidth:kSCREEN_WIDTH-(85+15)];
    return height + 15*2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group"];
    
    UIColor *titleColor = [UIColor colorWithHex:@"#343434"];
    UIColor *textColor = [UIColor colorWithHex:@"#666666"];
    UIFont *textFont = [UIFont systemFontOfSize2:14];
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"group"];
        if (indexPath.row == 0) {
            
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize2:15];
            label.text = @"群聊名称";
            label.textColor = titleColor;
            cell.accessoryType = 0;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                //                    make.height.equalTo(@(48));
                make.top.bottom.equalTo(cell.contentView);
            }];
            
            UILabel *value = [UILabel new];
            [cell.contentView addSubview:value];
            value.textColor = textColor;
            value.text = self.chatsModel.name;
            value.font = textFont;
            value.textAlignment = NSTextAlignmentLeft;
            value.numberOfLines = 0;
            [value mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(85);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.centerY.equalTo(cell.contentView);
            }];
            
            
        } else if (indexPath.row == 1){
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize2:15];
            label.text = @"群公告";
            label.textColor = titleColor;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.top.bottom.equalTo(cell.contentView);
            }];
            
            UILabel *right = [UILabel new];
            [cell.contentView addSubview:right];
            right.font = textFont;
            right.text = self.sessionModel.notice;
            right.textColor = textColor;
            right.textAlignment = NSTextAlignmentLeft;
            right.numberOfLines = 0;
            
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.left.equalTo(cell.contentView.mas_left).offset(85);
                make.centerY.equalTo(label.mas_centerY);
            }];
        } else if (indexPath.row == 2){
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize2:15];
            label.text = @"须知";
            label.textColor = titleColor;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(15);
            }];
            
            UILabel *bot = [UILabel new];
            [cell.contentView addSubview:bot];
            bot.font = textFont;
            bot.text = self.sessionModel.desc;
            bot.numberOfLines = 0;
            bot.textAlignment = NSTextAlignmentLeft;
            bot.textColor = textColor;
            
            [bot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.left.equalTo(cell.contentView.mas_left).offset(85);
                make.centerY.equalTo(label.mas_centerY);
            }];
        } else if (indexPath.row == 3 || indexPath.row == 4){
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize2:15];
            if(indexPath.row == 3)
                label.text = @"群规";
            else
                label.text = @"玩法";
            label.textColor = titleColor;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(15);
                make.centerY.equalTo(cell.contentView);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_right_arrow"]];
            [cell.contentView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@18);
                make.right.equalTo(cell.contentView.mas_right).offset(-17);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
            UILabel *right = [UILabel new];
            [cell.contentView addSubview:right];
            right.font = textFont;
            if(indexPath.row == 3) {
                right.text = self.sessionModel.group_regulation;
            } else if(indexPath.row == 4) {
                right.text = self.sessionModel.play_type_notice;
            }
            right.numberOfLines = 0;
            right.textColor = textColor;
            right.textAlignment = NSTextAlignmentLeft;
            
            [right mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-40);
                make.left.equalTo(cell.contentView.mas_left).offset(85);
                make.centerY.equalTo(label.mas_centerY);
            }];
            
        }
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            RCDBaseSettingTableViewCell *cellee = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cellee) {
                cellee = [[RCDBaseSettingTableViewCell alloc] init];
            }
            [cellee setCellStyle:SwitchStyle];
            cellee.leftLabel.text = @"消息免打扰";
            cellee.leftLabel.font = [UIFont systemFontOfSize2:15];
            cellee.switchButton.hidden = NO;
            cellee.leftLabel.textColor = titleColor;
            
            NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", [AppModel sharedInstance].user_info.userId,self.chatsModel.sessionId];
            // 读取
            BOOL isSwitch = [[NSUserDefaults standardUserDefaults] boolForKey:switchKeyStr];
            
            cellee.switchButton.on = isSwitch;
            
            [cellee.switchButton addTarget:self
                                    action:@selector(clickNotificationBtn:)
                          forControlEvents:UIControlEventValueChanged];
            return cellee;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0){
        if (indexPath.row == 0 && self.sessionModel.creator == [AppModel sharedInstance].user_info.userId) {
            [self onUpdateGroupName];
        } else if (indexPath.row == 1 && self.sessionModel.creator == [AppModel sharedInstance].user_info.userId) {
            [self onUpdateGroupInfo];
        }
        
        NSString *url = nil;
        if(indexPath.row == 3) {
            ImageDetailViewController *vc = [[ImageDetailViewController alloc] init];
            vc.imageUrl = url;
            vc.hiddenNavBar = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if(indexPath.row == 4) {
            //            url = self.groupInfo.howplayImg;
        }
        
        
    }
}

- (void)onUpdateGroupName {
    UpdateGroupNameController *vc = [[UpdateGroupNameController alloc] init];
    vc.model = self.chatsModel;
    vc.sessionModel = self.sessionModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onUpdateGroupInfo {
    
    UpdateGroupInfoController *vc = [[UpdateGroupInfoController alloc] init];
    vc.model = self.chatsModel;
    vc.sessionModel = self.sessionModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - gotoAllGroupUsers
- (void)gotoAllGroupUsers {
    AllUserViewController *vc = [AllUserViewController allUser:self.sessionModel];
    vc.title = @"全部成员";
    vc.groupId = self.sessionModel.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickNotificationBtn:(id)sender {
    UISwitch *swch = sender;
    NSString *switchKeyStr = [NSString stringWithFormat:@"%ld_%ld", [AppModel sharedInstance].user_info.userId,self.chatsModel.sessionId];
    //保存
    [[NSUserDefaults standardUserDefaults] setBool:swch.on forKey:switchKeyStr];
}

@end
