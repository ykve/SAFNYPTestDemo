//
//  SettingViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginForgetPsdController.h"
#import "AppDelegate.h"
#import "BankCardManageController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

///
@property (nonatomic, strong) UITableView *tableView;

/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UISwitch *inewMessageSwitch;
@property (nonatomic, strong) UISwitch *redPacketSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [self footView];
}

-(UIView *)footView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *exitBtn = [[UIButton alloc] init];
    [footView addSubview:exitBtn];
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [exitBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
    exitBtn.layer.cornerRadius = 5.0f;
    exitBtn.layer.masksToBounds = YES;
    //    exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn addTarget:self action:@selector(action_exit) forControlEvents:UIControlEventTouchUpInside];
    [exitBtn delayEnable];
    [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(16);
        make.right.equalTo(footView.mas_right).offset(-16);
        make.top.equalTo(footView.mas_top).offset(50);
        make.height.equalTo(@(44));
    }];
    
    return footView;
}

- (void)action_exit {
    __weak __typeof(self)weakSelf = self;
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    [view showWithText:@"你确定要退出吗？" button1:@"取消" button2:@"确定退出" callBack:^(id object) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSInteger tag = [object integerValue];
        if(tag == 1){
            [strongSelf signOut];
        }
    }];
}
#pragma mark -  退出登录
-(void)signOut {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate logOut];
}

#pragma mark ----- Data
- (void)initData {
    _dataArray = @[
                   @[@{@"title":@"账号",@"content":[NSString stringWithFormat:@"%ld", [AppModel sharedInstance].user_info.userId]},
                     @{@"title":@"手机号",@"content":[AppModel sharedInstance].user_info.mobile ? [AppModel sharedInstance].user_info.mobile : @"-"}],
                   
                   @[@{@"title":@"新消息提示音",@"content":@"0"},
                     @{@"title":@"红包提示音",@"content":@"0"}],
                   
                   @[@{@"title":@"银行卡管理",@"content":@"0"},
                     @{@"title":@"重设密码",@"content":@"0"}],
                   
                   @[@{@"title":@"帮助中心",@"content":@"0"},
                     @{@"title":@"版本",@"content":@"v1.0.0"}]
                   ];
}

#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT - Height_NavBar - kiPhoneX_Bottom_Height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        _tableView.rowHeight = 50;   // 行高
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = self.dataArray[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"result"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"result"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize2:15];
        cell.textLabel.textColor = [UIColor colorWithHex:@"#343434"];
        cell.backgroundColor = [UIColor whiteColor];
        NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
        NSString *text = dict[@"title"];
        cell.textLabel.text = text;
        
        if ((indexPath.section == 0) || (indexPath.section == 3 && indexPath.row == 1)) {
            
            UILabel *desLabel = [UILabel new];
            [cell.contentView addSubview:desLabel];
            desLabel.font = [UIFont systemFontOfSize2:15];
            desLabel.textColor = Color_6;
            
            NSString *text = dict[@"content"];
            desLabel.text = text;
            
            [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
            }];
        }
        
        if (indexPath.section == 1) {
            UISwitch *swich = [UISwitch new];
            [cell.contentView addSubview:swich];
            
            if (indexPath.row == 0) {
                swich.on = ([AppModel sharedInstance].turnOnSound == NO) ? YES : NO;
                self.inewMessageSwitch = swich;
            } else {
                swich.on = ([AppModel sharedInstance].turnOnSound == NO) ? YES : NO;
                self.redPacketSwitch = swich;
            }
            
            [swich addTarget:self action:@selector(action_setSound:) forControlEvents:UIControlEventValueChanged];
            [swich mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-12);
                make.centerY.equalTo(cell.contentView);
            }];
            
        }
        
        
        if(indexPath.section == 2 || (indexPath.section == 3 && indexPath.row == 0)) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 12;
    } else {
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    NSString *text = dict[@"title"];
    
    if ([text isEqualToString:@"重设密码"]) {
        LoginForgetPsdController *vc = [[LoginForgetPsdController alloc] init];
        vc.navigationItem.title = text;
        [self.navigationController pushViewController:vc animated:YES];
    } if ([text isEqualToString:@"银行卡管理"]) {
        BankCardManageController *vc = [[BankCardManageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)action_setSound:(UISwitch *)sw {
    [AppModel sharedInstance].turnOnSound = (sw.on== NO)?YES:NO;;
    [[AppModel sharedInstance] saveAppModel];
}



@end
