//
//  UpdateGroupNameController.m
//  WRHB
//
//  Created by AFan on 2019/11/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "UpdateGroupNameController.h"
#import "SessionInfoModel.h"
#import "ChatsModel.h"


@interface UpdateGroupNameController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *doneButton;
///
@property (nonatomic, strong) UITextField *groupNameTextField;
@property (nonatomic, strong) UIButton *updateBtn;


@end

@implementation UpdateGroupNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改群名称";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = NO;
    _doneButton = doneButton;
    doneButton.layer.cornerRadius = 3;
    self.doneButton.backgroundColor = [UIColor lightGrayColor];
    //    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    doneButton.frame = CGRectMake(0, 0, 56, 32);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(onDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    [self initUI];
    
    [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark -   修改群名称
- (void)onDoneBtn {
    self.updateBtn.enabled = NO;
    
    if (self.groupNameTextField.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入群昵称"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"session":@(self.model.sessionId),   // 会话id
                                 @"title":self.groupNameTextField.text,   // 会话名称
                                 @"notice":self.sessionModel.notice   // 会话公告
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/session/modify"];
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:@"正在保存"];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.model.name = strongSelf.groupNameTextField.text;
            [MBProgressHUD showTipMessageInWindow:@"更新群信息成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        strongSelf.updateBtn.enabled = YES;
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.updateBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 0) {
        self.doneButton.userInteractionEnabled = YES;
        self.doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    } else {
        self.doneButton.userInteractionEnabled = NO;
        self.doneButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    NSInteger kMaxLength = 12;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                //                [ToastUtils showHud:@"超过字数限制"];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
        
        // 3月19日更新为
        //        textField.text=  [[self class] subStringWith:toBeString ToIndex:maxNumber];
    }
}


- (void)initUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT -Height_NavBar - kiPhoneX_Bottom_Height)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor clearColor];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.mas_equalTo(self.view.bounds.size.height-Height_NavBar);
    }];
    
    
    UILabel *groupNameLabel = [[UILabel alloc] init];
    groupNameLabel.text = @"群昵称";
    groupNameLabel.font = [UIFont systemFontOfSize:15];
    groupNameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    groupNameLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:groupNameLabel];
    
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(20);
        make.left.equalTo(contentView.mas_left).offset(15);
    }];
    
    
    UITextField *groupNameTextField = [[UITextField alloc] init];
    groupNameTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    groupNameTextField.font = [UIFont systemFontOfSize:15.0];  // 字体
    groupNameTextField.textColor = [UIColor blackColor];  // 字体颜色
    groupNameTextField.placeholder = @"限制1-12个字符"; // 占位文字
    groupNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    groupNameTextField.delegate = self;
    groupNameTextField.keyboardType = UIKeyboardTypeEmailAddress; // 键盘类型
    groupNameTextField.returnKeyType = UIReturnKeyGo;
    groupNameTextField.backgroundColor = [UIColor whiteColor];
    groupNameTextField.layer.cornerRadius = 5;
    groupNameTextField.layer.masksToBounds = YES;
    [contentView addSubview:groupNameTextField];
    _groupNameTextField = groupNameTextField;
    [groupNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupNameLabel.mas_bottom).offset(10);
        make.left.equalTo(groupNameLabel.mas_left);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(55));
    }];

    self.groupNameTextField.text = self.model.name;
    
}



@end

