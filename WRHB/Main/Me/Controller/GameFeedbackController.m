//
//  GameFeedbackController.m
//  WRHB
//
//  Created by AFan on 2019/12/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "GameFeedbackController.h"
#import "FSTextView.h"
#import "UIView+AZGradient.h"   // 渐变色
#import "NSString+RegexCategory.h"
#import "CSAskFormController.h"
#import "ChatsModel.h"
#import "GameFeedBackedController.h"

@interface GameFeedbackController ()

@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UITextField *groupNameTextField;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GameFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"问题反馈";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self initUI];
    
    [self.groupNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -  提交
- (void)submitBtnActive {
    
    
    if (self.groupNameTextField.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入联系方式"];
        return;
    }
    if (![self.groupNameTextField.text isMobileNumberLoose]) {
        [MBProgressHUD showTipMessageInWindow:@"手机号请输入正确的格式"];
        return;
    }
    
    if (self.textView.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入您需要反馈的内容"];
        return;
    }
    
    
    NSDictionary *parameters = @{
                                 @"mobile":self.groupNameTextField.text,   // 联系方式
                                 @"content":self.textView.text   // 内容
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/feedback"];
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
    
    self.submitBtn.enabled = NO;
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            PUSH_C(self, GameFeedBackedController, true);
            
           
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        strongSelf.submitBtn.enabled = YES;
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submitBtn.enabled = YES;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void) textFieldDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 20;
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


- (void)goto_CustomerService {
    ChatsModel *model = [[ChatsModel alloc] init];
    model.sessionType = ChatSessionType_CustomerService;
    model.sessionId = kCustomerServiceID;
    model.name = @"在线客服";
    model.avatar = @"105";
    model.isJoinChatsList = YES;
    
    CSAskFormController *vc = [[CSAskFormController alloc] init];
    vc.chatsModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)initUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kiPhoneX_Bottom_Height)];
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc]init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor clearColor];
    _contentView = contentView;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.offset(self.view.bounds.size.width);
        make.height.mas_equalTo(self.view.bounds.size.height);
    }];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(100);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.height.mas_equalTo(323);
    }];
    
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"me_fb_sz"];
    [contentView addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_top).offset(35);
        make.right.equalTo(backView.mas_right);
        make.size.mas_equalTo(CGSizeMake(116.5, 104.5));
    }];
    
    UIImageView *ssImgView = [[UIImageView alloc] init];
    ssImgView.image = [UIImage imageNamed:@"me_fb_ss"];
    [contentView addSubview:ssImgView];
    
    [ssImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_top).offset(7);
        make.right.equalTo(backView.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(100, 16));
    }];
    
    [contentView bringSubviewToFront:ssImgView];
    [contentView sendSubviewToBack:imgView];
    
    UIView *textBgView = [[UIView alloc] init];
    textBgView.layer.cornerRadius = 60/2;
    textBgView.layer.masksToBounds = YES;
    textBgView.backgroundColor = [UIColor colorWithHex:@"#CCCDD3"];
    [contentView addSubview:textBgView];
    
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(25);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(220, 60));
    }];
    
    UILabel *tsLabel = [[UILabel alloc] init];
    tsLabel.text = @"您的问题在这里可能无法及时回复，如需尽快解决请";
    tsLabel.numberOfLines = 0;
    tsLabel.font = [UIFont systemFontOfSize:13];
    tsLabel.textColor = [UIColor whiteColor];
    [textBgView addSubview:tsLabel];
    
    [tsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView.mas_left).offset(15);
        make.right.equalTo(textBgView.mas_right).offset(-10);
        make.centerY.equalTo(textBgView.mas_centerY).offset(0);
    }];
    
    UIButton *kefuBtn = [[UIButton alloc] init];
//    kefuBtn.backgroundColor = [UIColor greenColor];
    [kefuBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    kefuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [kefuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [kefuBtn addTarget:self action:@selector(goto_CustomerService) forControlEvents:UIControlEventTouchUpInside];
    kefuBtn.tag = 6010;
    [textBgView addSubview:kefuBtn];
    
    [kefuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tsLabel.mas_bottom);
        make.left.equalTo(tsLabel.mas_right).offset(-75);
        make.size.mas_equalTo(CGSizeMake(65, 16));
    }];
    
    UILabel *groupNameLabel = [[UILabel alloc] init];
    groupNameLabel.text = @"联系方式";
    groupNameLabel.font = [UIFont systemFontOfSize:14];
    groupNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    groupNameLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:groupNameLabel];
    
    [groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(20);
        make.left.equalTo(backView.mas_left).offset(20);
    }];
    
    UILabel *tdaLabel = [[UILabel alloc] init];
    tdaLabel.text = @"(必填)";
    tdaLabel.font = [UIFont systemFontOfSize:12];
    tdaLabel.textColor = [UIColor redColor];
    tdaLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:tdaLabel];
    
    [tdaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(groupNameLabel.mas_bottom);
        make.left.equalTo(groupNameLabel.mas_right).offset(5);
    }];
    
    UITextField *groupNameTextField = [[UITextField alloc] init];
    groupNameTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    groupNameTextField.font = [UIFont systemFontOfSize:13.0];  // 字体
    groupNameTextField.textColor = [UIColor blackColor];  // 字体颜色
    groupNameTextField.placeholder = @"请输入您的手机号码以便于我们及时反馈";  // 占位文字
    groupNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    groupNameTextField.delegate = self;
    groupNameTextField.keyboardType = UIKeyboardTypeEmailAddress; // 键盘类型
    groupNameTextField.returnKeyType = UIReturnKeyGo;
    groupNameTextField.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    groupNameTextField.layer.cornerRadius = 5;
    groupNameTextField.layer.masksToBounds = YES;
    [backView addSubview:groupNameTextField];
    _groupNameTextField = groupNameTextField;
    [groupNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupNameLabel.mas_bottom).offset(15);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(@(44));
    }];
    
    
    UILabel *groupGgLabel = [[UILabel alloc] init];
    groupGgLabel.text = @"反馈内容";
    groupGgLabel.font = [UIFont systemFontOfSize:14];
    groupGgLabel.textColor = [UIColor colorWithHex:@"#333333"];
    groupGgLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:groupGgLabel];
    
    [groupGgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupNameTextField.mas_bottom).offset(30);
        make.left.equalTo(groupNameLabel.mas_left);
    }];
    
    UILabel *tdeLabel = [[UILabel alloc] init];
    tdeLabel.text = @"(必填)";
    tdeLabel.font = [UIFont systemFontOfSize:12];
    tdeLabel.textColor = [UIColor redColor];
    tdeLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:tdeLabel];
    
    [tdeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(groupGgLabel.mas_bottom);
        make.left.equalTo(groupGgLabel.mas_right).offset(5);
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
    [backView addSubview:noticeLabel];
    
    
    // FSTextView
    FSTextView *textView = [FSTextView textView];
    textView.placeholder = @"请详细说明，以便于我们解决问题， 限制300个字符";
    textView.borderWidth = 1.f;
    textView.borderColor = UIColor.clearColor;
    textView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    textView.cornerRadius = 5.f;
    textView.canPerformAction = NO;
    textView.font = [UIFont systemFontOfSize:13.0];
    [backView addSubview:textView];
    _textView = textView;
    // 限制输入最大字符数.
    textView.maxLength = 300;
    
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
        make.top.equalTo(groupGgLabel.mas_bottom).offset(15);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(124);
    }];
    
    
    UIButton *submitBtn = [UIButton new];
//    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 40/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];// 渐变色
    [submitBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF8888"],[UIColor colorWithHex:@"#FF4444"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnActive) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(backView.mas_bottom).offset(35);
        make.left.equalTo(contentView.mas_left).offset(15);
        make.right.equalTo(contentView.mas_right).offset(-15);
    }];
}



@end

