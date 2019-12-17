//
//  ClubPropertyController.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubPropertyController.h"
#import "ClubManager.h"
#import "UIButton+GraphicBtn.h"

@interface ClubPropertyController ()

/// 俱乐部名称
@property (nonatomic, strong)  UITextField *clubNameTextField;
/// 俱乐部ID
@property (nonatomic, strong) UILabel *IDLabel;
/// 选择Icon  所有用户
@property (nonatomic, strong) UIButton *selectedIconBtn1;
/// 选择Icon  权限管理
@property (nonatomic, strong) UIButton *selectedIconBtn2;
/// 选择Icon  发包支付
@property (nonatomic, strong) UIButton *selectedIconBtn3;
/// 选择Icon  抢包支付
@property (nonatomic, strong) UIButton *selectedIconBtn4;
/// 俱乐部公告
@property (nonatomic, strong) UITextField *noticeTextField;
/// 禁止说话
@property (nonatomic, strong) UISwitch *noSpeakSwitch;
/// 聊天大厅
@property (nonatomic, strong) UISwitch *chatHallShow;


@end

@implementation ClubPropertyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"俱乐部属性";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self setupUI];
    [self setData];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self updateClubInfo];
    }
    
}



- (void)setData {
    self.clubNameTextField.text = [ClubManager sharedInstance].clubInfo.title;
    self.IDLabel.text = [NSString stringWithFormat:@"%zd", [ClubManager sharedInstance].clubInfo.ID];

    if ([ClubManager sharedInstance].clubInfo.who_create_room == 1) { // 所有用户
        [self.selectedIconBtn1 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
        [self.selectedIconBtn2 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    } else {
        [self.selectedIconBtn1 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [self.selectedIconBtn2 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
    }
    if ([ClubManager sharedInstance].clubInfo.fee_from_who == 1) { // 发包者
        [self.selectedIconBtn3 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
        [self.selectedIconBtn4 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    } else {
        [self.selectedIconBtn3 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [self.selectedIconBtn4 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
    }
    self.noticeTextField.text = [ClubManager sharedInstance].clubInfo.notice;
    
    // 1 不禁言
    self.noSpeakSwitch.on = ([ClubManager sharedInstance].clubInfo.can_speak == 1) ? NO : YES;
    
    // 1 显示
    self.chatHallShow.on = ([ClubManager sharedInstance].clubInfo.show_alliance == 1) ? YES : NO;
    
}

- (void)onSelectedIconBtn:(UIButton *)sender {
    if (sender.tag == 1000) {
        [self.selectedIconBtn1 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
        [self.selectedIconBtn2 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [ClubManager sharedInstance].clubInfo.who_create_room = 1;
    }
    if (sender.tag == 1001) {
        [self.selectedIconBtn1 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [self.selectedIconBtn2 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
        [ClubManager sharedInstance].clubInfo.who_create_room = 2;
    }
    if (sender.tag == 1002) {
        [self.selectedIconBtn3 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
        [self.selectedIconBtn4 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [ClubManager sharedInstance].clubInfo.fee_from_who = 1;
    }
    if (sender.tag == 1003) {
        [ClubManager sharedInstance].clubInfo.fee_from_who = 2;
        [self.selectedIconBtn3 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
        [self.selectedIconBtn4 setImage:[UIImage imageNamed:@"club_selected"] forState:UIControlStateNormal];
    }
}

- (void)onNoSpeakSwitch:(UISwitch *)sw {
    self.noSpeakSwitch.on = sw.on == NO ? YES : NO;
    [ClubManager sharedInstance].clubInfo.can_speak = sw.on == YES ? 2 : 1;
}
- (void)onChatHallShow:(UISwitch *)sw {
    self.chatHallShow.on = sw.on == NO ? YES : NO;
    [ClubManager sharedInstance].clubInfo.show_alliance = sw.on == YES ? 1 : 2;
}
// 俱乐部名称可写
- (void)onClubNameBtn:(UIButton *)sendder {
    sendder.selected = !sendder.selected;
    if (sendder.selected) {
        self.clubNameTextField.userInteractionEnabled = YES;
    } else {
       self.clubNameTextField.userInteractionEnabled = NO;
    }
}
// 公告可写
- (void)onNoticeBtn:(UIButton *)sendder {
    sendder.selected = !sendder.selected;
    if (sendder.selected) {
        self.noticeTextField.userInteractionEnabled = YES;
    } else {
        self.noticeTextField.userInteractionEnabled = NO;
    }
}



#pragma mark -  修改俱乐部信息
- (void)updateClubInfo {
    
    if (self.clubNameTextField.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"俱乐部名称不能为空"];
        return;
    }
    
    [ClubManager sharedInstance].clubInfo.title = self.clubNameTextField.text;
    [ClubManager sharedInstance].clubInfo.notice = self.noticeTextField.text;
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID),   // ID
                                 @"name":[ClubManager sharedInstance].clubInfo.title,  // 俱乐部名称
                                 @"who_create_room":@([ClubManager sharedInstance].clubInfo.who_create_room),   // 创建房间方式 1 全员 2 管理者
                                 @"fee_from_who":@([ClubManager sharedInstance].clubInfo.fee_from_who),   // 房间费用支付方式 1 发包 2 抢包
                                 @"notice":[ClubManager sharedInstance].clubInfo.notice,   // 会话公告
                                 @"can_speak":@([ClubManager sharedInstance].clubInfo.can_speak),   // 是否禁言
                                 @"show_alliance":@([ClubManager sharedInstance].clubInfo.show_alliance)   // 是否显示在大联盟 1 显示 2 不显示
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/modify"];
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
//    [MBProgressHUD showActivityMessageInView:@"正在保存"];
//    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//        [MBProgressHUD hideHUD];
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTipMessageInWindow:@"更新俱乐部信息成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kClubInfoUpdateNotification object:nil];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}



- (void)setupUI {
    
    CGFloat nSWidht = 120;
    // ************ View1 ************
    UIView *backView1 = [[UIView alloc] init];
    backView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView1];
    
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.text = @"俱乐部名称";
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.textColor = [UIColor colorWithHex:@"#343434"];
    [backView1 addSubview:titleLabel1];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(backView1.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *iconView = [[UIButton alloc] init];
    [iconView setBackgroundImage:[UIImage imageNamed:@"club_write_update"] forState:UIControlStateNormal];
    [iconView addTarget:self action:@selector(onClubNameBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView1 addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.right.equalTo(backView1.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(17, 19));
    }];
    
    UITextField *clubNameTextField = [[UITextField alloc] init];
//    clubNameTextField.backgroundColor = [UIColor yellowColor];
    //    textField.tag = 100;
    // textField.backgroundColor = [UIColor greenColor];  // 更改背景颜色
    clubNameTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    clubNameTextField.font = [UIFont systemFontOfSize:15];  // 字体
    clubNameTextField.textColor = [UIColor colorWithHex:@"#666666"];  // 字体颜色
//    clubNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    clubNameTextField.clearsOnBeginEditing = YES; // 当编辑时清空
    clubNameTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    clubNameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    clubNameTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    clubNameTextField.userInteractionEnabled = NO;
    [backView1 addSubview:clubNameTextField];
    _clubNameTextField = clubNameTextField;
    [clubNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
        make.right.equalTo(iconView.mas_left).offset(-5);
        make.height.mas_equalTo(@(35));
    }];
    
    // ************ View2 ************
    UIView *backView2 = [[UIView alloc] init];
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView2];
    
    [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView1.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.text = @"俱乐部ID";
    titleLabel2.font = [UIFont systemFontOfSize:15];
    titleLabel2.textColor = [UIColor colorWithHex:@"#343434"];
    [backView2 addSubview:titleLabel2];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(backView2.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *IDLabel = [[UILabel alloc] init];
    IDLabel.font = [UIFont systemFontOfSize:15];
    IDLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView2 addSubview:IDLabel];
    _IDLabel = IDLabel;
    
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
        make.width.mas_equalTo(100);
    }];
    
    // ************ View3 ************
    UIView *backView3 = [[UIView alloc] init];
    backView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView3];
    
    [backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView2.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel3 = [[UILabel alloc] init];
    titleLabel3.text = @"创建房间";
    titleLabel3.font = [UIFont systemFontOfSize:15];
    titleLabel3.textColor = [UIColor colorWithHex:@"#343434"];
    [backView3 addSubview:titleLabel3];
    
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *selectedIconBtn1 = [[UIButton alloc] init];
    [selectedIconBtn1 setTitle:@"所有用户" forState:UIControlStateNormal];
    [selectedIconBtn1 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectedIconBtn1 setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    selectedIconBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectedIconBtn1 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    [selectedIconBtn1 setImagePosition:WPGraphicBtnTypeLeft spacing:8];
    selectedIconBtn1.tag = 1000;
    selectedIconBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView3 addSubview:selectedIconBtn1];
    _selectedIconBtn1 = selectedIconBtn1;
    
    [selectedIconBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    UIButton *selectedIconBtn2 = [[UIButton alloc] init];
    [selectedIconBtn2 setTitle:@"权限管理" forState:UIControlStateNormal];
    [selectedIconBtn2 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectedIconBtn2 setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    selectedIconBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectedIconBtn2 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    [selectedIconBtn2 setImagePosition:WPGraphicBtnTypeLeft spacing:8];
    selectedIconBtn2.tag = 1001;
    selectedIconBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView3 addSubview:selectedIconBtn2];
    _selectedIconBtn2 = selectedIconBtn2;
    
    [selectedIconBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_centerX).offset(50);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
//    UIButton *selectedIconBtn2= [[UIButton alloc] init];
//    [selectedIconBtn2 setBackgroundImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
//    [selectedIconBtn2 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
//    selectedIconBtn2.tag = 1001;
//    [backView3 addSubview:selectedIconBtn2];
//    _selectedIconBtn2 = selectedIconBtn2;
//
//    [selectedIconBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView3.mas_centerY);
//        make.left.equalTo(backView3.mas_centerX).offset(50);
//        make.size.mas_equalTo(16);
//    }];
//
//    UILabel *tit32 = [[UILabel alloc] init];
//    tit32.text = @"权限管理";
//    tit32.font = [UIFont systemFontOfSize:15];
//    tit32.textColor = [UIColor colorWithHex:@"#343434"];
//    [backView3 addSubview:tit32];
//
//    [tit32 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView3.mas_centerY);
//        make.left.equalTo(selectedIconBtn2.mas_right).offset(8);
//    }];
    
    
    
    // ************ View4 ************
    UIView *backView4 = [[UIView alloc] init];
    backView4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView4];
    
    [backView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView3.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel4 = [[UILabel alloc] init];
    titleLabel4.text = @"房间费用";
    titleLabel4.font = [UIFont systemFontOfSize:15];
    titleLabel4.textColor = [UIColor colorWithHex:@"#343434"];
    [backView4 addSubview:titleLabel4];
    
    [titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(backView4.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *selectedIconBtn3 = [[UIButton alloc] init];
    [selectedIconBtn3 setTitle:@"发包支付" forState:UIControlStateNormal];
    [selectedIconBtn3 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectedIconBtn3 setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    selectedIconBtn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectedIconBtn3 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    [selectedIconBtn3 setImagePosition:WPGraphicBtnTypeLeft spacing:8];
    selectedIconBtn3.tag = 1002;
    selectedIconBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView4 addSubview:selectedIconBtn3];
    _selectedIconBtn3 = selectedIconBtn3;
    
    [selectedIconBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    UIButton *selectedIconBtn4 = [[UIButton alloc] init];
    [selectedIconBtn4 setTitle:@"抢包支付" forState:UIControlStateNormal];
    [selectedIconBtn4 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectedIconBtn4 setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    selectedIconBtn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectedIconBtn4 setImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
    [selectedIconBtn4 setImagePosition:WPGraphicBtnTypeLeft spacing:8];
    selectedIconBtn4.tag = 1003;
    selectedIconBtn4.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backView4 addSubview:selectedIconBtn4];
    _selectedIconBtn4 = selectedIconBtn4;
    
    [selectedIconBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView4.mas_centerY);
        make.left.equalTo(backView4.mas_centerX).offset(50);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    
    
//    UIButton *selectedIconBtn3= [[UIButton alloc] init];
//    [selectedIconBtn3 setBackgroundImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
//    [selectedIconBtn3 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
//    selectedIconBtn3.tag = 1002;
//    [backView4 addSubview:selectedIconBtn3];
//    _selectedIconBtn3 = selectedIconBtn3;
//
//    [selectedIconBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView4.mas_centerY);
//        make.left.equalTo(self.view.mas_left).offset(nSWidht);
//        make.size.mas_equalTo(16);
//    }];
//
//    UILabel *tit4 = [[UILabel alloc] init];
//    tit4.text = @"发包支付";
//    tit4.font = [UIFont systemFontOfSize:15];
//    tit4.textColor = [UIColor colorWithHex:@"#343434"];
//    [backView4 addSubview:tit4];
//
//    [tit4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView4.mas_centerY);
//        make.left.equalTo(selectedIconBtn3.mas_right).offset(8);
//    }];
//
//    UIButton *selectedIconBtn4= [[UIButton alloc] init];
//    [selectedIconBtn4 setBackgroundImage:[UIImage imageNamed:@"club_notselected"] forState:UIControlStateNormal];
//    [selectedIconBtn4 addTarget:self action:@selector(onSelectedIconBtn:) forControlEvents:UIControlEventTouchUpInside];
//    selectedIconBtn4.tag = 1003;
//    [backView3 addSubview:selectedIconBtn4];
//    _selectedIconBtn4 = selectedIconBtn4;
//
//    [selectedIconBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView4.mas_centerY);
//        make.left.equalTo(backView4.mas_centerX).offset(50);
//        make.size.mas_equalTo(16);
//    }];
//
//    UILabel *tit42 = [[UILabel alloc] init];
//    tit42.text = @"抢包支付";
//    tit42.font = [UIFont systemFontOfSize:15];
//    tit42.textColor = [UIColor colorWithHex:@"#343434"];
//    [backView4 addSubview:tit42];
//
//    [tit42 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(backView4.mas_centerY);
//        make.left.equalTo(selectedIconBtn4.mas_right).offset(8);
//    }];
    
    
    // ************ View5 ************
    UIView *backView5 = [[UIView alloc] init];
    backView5.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView5];
    
    [backView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView4.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel5 = [[UILabel alloc] init];
    titleLabel5.text = @"俱乐部公告";
    titleLabel5.font = [UIFont systemFontOfSize:15];
    titleLabel5.textColor = [UIColor colorWithHex:@"#343434"];
    [backView5 addSubview:titleLabel5];
    
    [titleLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView5.mas_centerY);
        make.left.equalTo(backView5.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UIButton *iconView2 = [[UIButton alloc] init];
    [iconView2 setBackgroundImage:[UIImage imageNamed:@"club_write_update"] forState:UIControlStateNormal];
    [iconView2 addTarget:self action:@selector(onNoticeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView5 addSubview:iconView2];
    
    [iconView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView5.mas_centerY);
        make.right.equalTo(backView5.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(17, 19));
    }];
    
    UITextField *noticeTextField = [[UITextField alloc] init];
//    noticeTextField.backgroundColor = [UIColor yellowColor];
    //    textField.tag = 100;
    // textField.backgroundColor = [UIColor greenColor];  // 更改背景颜色
    noticeTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    noticeTextField.font = [UIFont systemFontOfSize:15];  // 字体
    noticeTextField.textColor = [UIColor colorWithHex:@"#666666"];  // 字体颜色
//    noticeTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    noticeTextField.clearsOnBeginEditing = YES; // 当编辑时清空
    noticeTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    noticeTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    noticeTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    noticeTextField.userInteractionEnabled = NO;
    [backView5 addSubview:noticeTextField];
    _noticeTextField = noticeTextField;
    [noticeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView5.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
        make.right.equalTo(iconView2.mas_left).offset(-5);
        make.height.mas_equalTo(@(35));
    }];
    
    // ************ View6 ************
    UIView *backView6 = [[UIView alloc] init];
    backView6.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView6];
    
    [backView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView5.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel6 = [[UILabel alloc] init];
    titleLabel6.text = @"聊天大厅";
    titleLabel6.font = [UIFont systemFontOfSize:15];
    titleLabel6.textColor = [UIColor colorWithHex:@"#343434"];
    [backView6 addSubview:titleLabel6];
    
    [titleLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView6.mas_centerY);
        make.left.equalTo(backView6.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *chatLabel6 = [[UILabel alloc] init];
    chatLabel6.text = @"玩家禁言";
    chatLabel6.font = [UIFont systemFontOfSize:15];
    chatLabel6.textColor = [UIColor colorWithHex:@"#343434"];
    [backView6 addSubview:chatLabel6];
    
    [chatLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView6.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(nSWidht);
    }];
    
    UISwitch *noSpeakSwitch = [UISwitch new];
    [noSpeakSwitch addTarget:self action:@selector(onNoSpeakSwitch:) forControlEvents:UIControlEventValueChanged];
    [backView6 addSubview:noSpeakSwitch];
    _noSpeakSwitch = noSpeakSwitch;

    [noSpeakSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView6.mas_right).offset(-15);
        make.centerY.equalTo(backView6.mas_centerY);
    }];
    
    // ************ View7 ************
    UIView *backView7 = [[UIView alloc] init];
    backView7.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView7];
    
    [backView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView6.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel7 = [[UILabel alloc] init];
    titleLabel7.text = @"大联盟开关";
    titleLabel7.font = [UIFont systemFontOfSize:15];
    titleLabel7.textColor = [UIColor colorWithHex:@"#343434"];
    [backView7 addSubview:titleLabel7];
    
    [titleLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView7.mas_centerY);
        make.left.equalTo(backView7.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UISwitch *chatHallShow = [UISwitch new];
    [chatHallShow addTarget:self action:@selector(onChatHallShow:) forControlEvents:UIControlEventValueChanged];
    [backView7 addSubview:chatHallShow];
    _chatHallShow = chatHallShow;
    
    [chatHallShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView7.mas_right).offset(-15);
        make.centerY.equalTo(backView7.mas_centerY);
    }];
    
}



@end
