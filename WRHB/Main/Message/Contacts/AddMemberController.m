//
//  AddMemberController.m
//  Project
//
//  Created by AFan on 2019/2/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AddMemberController.h"
#import "SearchCell.h"

#define TopViewHeight 52

@interface AddMemberController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

//
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) BaseUserModel *userModel;
@property (nonatomic, assign) BaseUserModel *selectedModel;


@end

@implementation AddMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#FDFDFD"];
    
    if (self.addType == AddType_Friend) {
        self.navigationItem.title = @"添加好友";
    } else {
       self.navigationItem.title = @"添加成员";
    }
    
    [self ininUI];
    [self.view addSubview:self.tableView];
    [self initNotif];
}

- (void)ininUI {
    // 左边图片和文字
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.layer.cornerRadius = 3;
//    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
//    doneButton.frame = CGRectMake(0, 0, 53, 32);
//    [doneButton setTitle:@"添加" forState:UIControlStateNormal];
//    [doneButton setTintColor:[UIColor whiteColor]];
//    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
//    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
//    [doneButton addTarget:self action:@selector(onDoneButton) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    
    
    UIView *topView = [[UIView alloc] init];
    //    topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(TopViewHeight);
    }];
    
    
    
    
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"group_search"];
//    searchImage.backgroundColor = [UIColor grayColor];
    [topView addSubview:searchImage];
    
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    UITextField *searchTextField = [[UITextField alloc] init];
    searchTextField.placeholder = @"搜索好友";
//    searchTextField.keyboardType = UIKeyboardTypeWebSearch;
    searchTextField.returnKeyType = UIReturnKeySearch; // 变为搜索按钮
    searchTextField.delegate = self;//设置代理
    [topView addSubview:searchTextField];
    _searchTextField = searchTextField;
    
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(searchImage.mas_right).offset(10);
        make.right.equalTo(topView.mas_right).offset(-20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:0.906 green:0.906 blue:0.906 alpha:1.000];
    [self.view addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"点击了搜索");
    if (self.addType == AddType_Friend) {
        [self queryMemberData];
    } else if (self.addType == AddType_GroupMember) {
        [self getUserInfoData];
    }
    return YES;
}

- (void)onDoneButton {
    if (self.selectedModel) {
        if (self.addType == AddType_Friend) {
            [self requestAddFriend];
        } else if (self.addType == AddType_GroupMember) {
            [self addMember];
        }
    } else {
         [MBProgressHUD showTipMessageInWindow:@"请选择成员"];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,Height_NavBar+ TopViewHeight + 2, kSCREEN_WIDTH, kSCREEN_HEIGHT - Height_NavBar -TopViewHeight -1) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#FDFDFD"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    }
    
    return _tableView;
}



- (UIView *)setHeaderView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"该用户不存在";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    return backView;
}



/**
 添加群成员
 */
- (void)addMember {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"social/skChatGroup/addgroupMember"];

    NSMutableArray *userIdArray = [NSMutableArray array];
    [userIdArray addObject: self.searchTextField.text];
    
    entity.needCache = NO;
    NSDictionary *parameters = @{
                                 @"groupId":@(self.groupId),
                                 @"userIds": userIdArray
                                 };
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 0) {
            NSString *msg = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
            [MBProgressHUD showSuccessMessage:msg];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}



- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)text {
    UITextField *textField = (UITextField *)text.object;
    if (textField.text.length == 0) {
        return;
    }
    NSString *num = @"^[0-9]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
//    BOOL isNum = [pre evaluateWithObject:textField.text];
//    if (isNum) {
//        if (self.addType == AddType_Friend) {
//            [self queryMemberData];
//        } else if (self.addType == AddType_GroupMember) {
//             [self getUserInfoData];
//        }
//    }
}
#pragma mark -  搜索用户
// 搜索用户
- (void)queryMemberData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/searchUser"];
    NSDictionary *parameters = @{
                                 @"user":[NSString stringWithFormat:@"%@",self.searchTextField.text]
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.userModel = [BaseUserModel mj_objectWithKeyValues:response[@"data"]];
            [strongSelf.tableView reloadData];
            if (!strongSelf.userModel) {
                strongSelf.tableView.tableHeaderView = [strongSelf setHeaderView];
            }
        } else {
            strongSelf.userModel = nil;
            [strongSelf.tableView reloadData];
            strongSelf.tableView.tableHeaderView = [strongSelf setHeaderView];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}
#pragma mark -  申请成为好友
// 申请成为好友
- (void)requestAddFriend {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/add"];
    NSDictionary *parameters = @{
                                 @"user":@([self.searchTextField.text integerValue])
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
//            [strongSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}
#pragma mark -  查询群成员
// 查询群成员
- (void)getUserInfoData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"social/skChatGroup/select"];
    NSDictionary *parameters = @{
                                 @"id":[NSString stringWithFormat:@"%@",self.searchTextField.text]
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.userModel = [BaseUserModel mj_objectWithKeyValues:response[@"data"]];
            [strongSelf.tableView reloadData];
        } else {
             strongSelf.userModel = nil;
            [strongSelf.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.userModel) {
        return 1;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    if (cell == nil) {
        cell = [[SearchCell alloc]initWithStyle:0 reuseIdentifier:@"user"];
    }
    cell.model = self.userModel;
    __weak __typeof(self)weakSelf = self;
    cell.addBtnBlock = ^(BaseUserModel *model) {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedModel = model;
        [strongSelf onDoneButton];
        return;
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //    header.contentView.backgroundColor= [UIColor whiteColor];
    [header.textLabel setTextColor:[UIColor colorWithHex:@"#333333"]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
}




@end
