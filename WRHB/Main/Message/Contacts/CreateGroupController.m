//
//  CreateGroupController.m
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CreateGroupController.h"
#import "FSTextView.h"



@interface CreateGroupController ()

@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UITextField *groupNameTextField;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) UIButton *createBtn;

@end

@implementation CreateGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"创建群";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self initUI];
    
    [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark -  创建群
- (void)action_submit {
     self.createBtn.enabled = NO;
    
    if (self.groupNameTextField.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入群昵称"];
        return;
    }
    if (self.textView.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入群公告"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"name":self.groupNameTextField.text,   // 会话名称
                                 @"notice":self.textView.text   // 会话公告
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/createGroup"];
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
        [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInWindow:@"创建群成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        strongSelf.createBtn.enabled = YES;
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.createBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void) textFieldDidChange:(UITextField *)textField
{
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


//防止原生emoji表情被截断
//- (NSString *)subStringWith:(NSString *)string index:(NSInteger)index{
//
//    NSString *result = string;
//    if (result.length > index) {
//        NSRange rangeIndex = [result rangeOfComposedCharacterSequenceAtIndex:index];
//        result = [result substringToIndex:(rangeIndex.location)];
//    }
//
//    return result;
//}

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
    groupNameTextField.delegate = self;
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
    
    
    UILabel *groupGgLabel = [[UILabel alloc] init];
    groupGgLabel.text = @"群公告";
    groupGgLabel.font = [UIFont systemFontOfSize:15];
    groupGgLabel.textColor = [UIColor colorWithHex:@"#343434"];
    groupGgLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:groupGgLabel];
    
    [groupGgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupNameTextField.mas_bottom).offset(20);
        make.left.equalTo(groupNameLabel.mas_left);
    }];
    
    
    //文本
//    textView.text = @"限制1-75个字符";
//
//    textView.layer.cornerRadius = 5;
//    textView.layer.masksToBounds = YES;
    // 达到最大限制时提示的Label
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.font = [UIFont systemFontOfSize:14.f];
    noticeLabel.textColor = UIColor.redColor;
    [self.view addSubview:noticeLabel];
   
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"限制1-75个字符";
    textView.borderWidth = 1.f;
    textView.borderColor = UIColor.clearColor;
    textView.cornerRadius = 5.f;
    textView.canPerformAction = NO;
    [contentView addSubview:textView];
     _textView = textView;
    // 限制输入最大字符数.
    textView.maxLength = 75;
    
    // 弱化引用, 以免造成内存泄露.
    __weak __typeof(&*noticeLabel)weakNoticeLabel = noticeLabel;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        (textView.text.length < textView.maxLength) ? weakNoticeLabel.text = @"":NULL;
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:@"最多限制输入%zi个字符", textView.maxLength]];
    }];
    
    
    
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupGgLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.mas_equalTo(150);
    }];
    
    
    
    UILabel *ttLabel = [[UILabel alloc] init];
    ttLabel.text = @"每个用户只能创建一个群";
    ttLabel.font = [UIFont systemFontOfSize:12];
    ttLabel.textColor = [UIColor colorWithHex:@"#999999"];
    ttLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:ttLabel];
    
    [ttLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(20);
    }];
    
    
    UIButton *btn = [UIButton new];
    [contentView addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [btn setTitle:@"创建" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.masksToBounds = YES;
//    btn.backgroundColor = [UIColor redColor];
    [btn delayEnable];
    _createBtn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(88);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.equalTo(@(45));
        
    }];
}





@end
