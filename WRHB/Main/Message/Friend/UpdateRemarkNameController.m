//
//  UpdateRemarkNameController.m
//  WRHB
//
//  Created by AFan on 2019/12/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "UpdateRemarkNameController.h"
#import "YPContacts.h"

@interface UpdateRemarkNameController ()
///
@property (nonatomic, strong) UITextField *textField;

@end

@implementation UpdateRemarkNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置备注";
    self.view.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
    
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = YES;
    doneButton.layer.cornerRadius = 3;
    //    self.doneButton.backgroundColor = [UIColor lightGrayColor];
    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    doneButton.frame = CGRectMake(0, 0, 56, 32);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(onDoneBtn_Save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [self setupUI];
    
    self.textField.text = self.contact.nickName;
}

- (void)onDoneBtn {
    
}

#pragma mark - 保存
- (void)onDoneBtn_Save {
    
    if(self.textField.text.length > 6){
        [MBProgressHUD showTipMessageInWindow:@"昵称不能大于6个字符"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"friend":@(self.contact.user_id),
                                 @"mark":self.textField.text
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends/modify"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {

            strongSelf.contact.nickName = strongSelf.textField.text;
//            [MBProgressHUD showSuccessMessage:@"保存成功"];
            // 刷新用户信息
//            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoNotification object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
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
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"备注名";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor colorWithHex:@"#666666"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 10);
        make.left.equalTo(self.view.mas_left).offset(15);
    }];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(@(40));
    }];
    
    
    UITextField *textField = [[UITextField alloc] init];
    //    textField.tag = 100;
     textField.backgroundColor = [UIColor whiteColor];  // 更改背景颜色
    textField.borderStyle = UITextBorderStyleNone;  //边框类型
    textField.font = [UIFont systemFontOfSize:15.0];  // 字体
    textField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    textField.placeholder = @"添加备注名"; // 占位文字
    textField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    //textField.clearsOnBeginEditing = YES; // 当编辑时清空
    //textField.autocapitalizationType =
    //textField.background
    textField.delegate = self;
    // 在左边设置一张view，充当光标左边的间距，否则光标紧贴textField不美观
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    textField.keyboardType = UIKeyboardTypeEmailAddress; // 键盘类型
    textField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    [backView addSubview:textField];
    _textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.top.bottom.equalTo(backView);
        make.right.equalTo(backView.mas_right).offset(-5);
    }];
}



@end
