//
//  UpdateGroupInfoController.m
//  WRHB
//
//  Created by AFan on 2019/11/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "UpdateGroupInfoController.h"
#import "FSTextView.h"
#import "SessionInfoModel.h"
#import "ChatsModel.h"



@interface UpdateGroupInfoController ()

@property (nonatomic, strong) UIView *contentView;
///
@property (nonatomic, strong) UITextField *groupNameTextField;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) UIButton *createBtn;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation UpdateGroupInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改群公告";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = YES;
    _doneButton = doneButton;
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
    [doneButton addTarget:self action:@selector(onDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    [self initUI];
}


#pragma mark -  创建群
- (void)onDoneBtn {
    self.createBtn.enabled = NO;

    if (self.textView.text.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入群公告"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"session":@(self.model.sessionId),   // 会话id
                                 @"title":self.model.name,   // 会话名称
                                 @"notice":self.textView.text   // 会话公告
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
            [MBProgressHUD showTipMessageInWindow:@"更新群信息成功"];
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
    
    
    UILabel *groupGgLabel = [[UILabel alloc] init];
    groupGgLabel.text = @"群公告";
    groupGgLabel.font = [UIFont systemFontOfSize:15];
    groupGgLabel.textColor = [UIColor colorWithHex:@"#343434"];
    groupGgLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:groupGgLabel];
    
    [groupGgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(20);
        make.left.equalTo(contentView.mas_left).offset(15);
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

    self.textView.text = self.sessionModel.notice;
}

- (void)setSessionModel:(SessionInfoModel *)sessionModel {
    _sessionModel = sessionModel;
}



@end

