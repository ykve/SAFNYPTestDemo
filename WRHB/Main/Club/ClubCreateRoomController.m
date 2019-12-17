//
//  ClubCreateRoomController.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubCreateRoomController.h"
#import "ClubManager.h"
#import "TFPopup.h"
#import "ClubListView.h"

@interface ClubCreateRoomController ()

/// 房间名称
@property (nonatomic, strong) UITextField *roomNameTextField;
/// 玩法类型
@property (nonatomic, strong)  UILabel *palyTypeLabel;
/// 红包金额 start
@property (nonatomic, strong) UITextField *startTextField;
/// 红包金额 end
@property (nonatomic, strong) UITextField *endTextField;
@property (nonatomic, strong) UIButton *createBtn;


/// // 玩法 1 单雷 2 禁雷场 3 牛牛不翻倍 4 牛牛翻倍
@property (nonatomic, assign)  NSInteger palyType;

@property(nonatomic,strong) TFPopupParam *param;
@property (strong, nonatomic) UIView *redPoint;
@property(nonatomic,assign)PopupDirection popupDirection;

@end

@implementation ClubCreateRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"房间管理";
    
    self.palyType = 1;
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    self.param = [TFPopupParam new];
//    self.redPoint.layer.cornerRadius = 5;
    self.popupDirection = PopupDirectionBottomLeft;
}

#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    if (self.roomNameTextField.text.length > 0 && self.startTextField.text.length > 0 && self.endTextField.text.length > 0) {
        self.createBtn.userInteractionEnabled = YES;
        [self.createBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    } else {
         [self.createBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
    }
    
}

- (void)onPalyTypeEvent:(UITapGestureRecognizer *)tgr {
    self.palyType = 2;
    
    self.param.popupSize = CGSizeMake(160, 200);
    //        self.param.duration = 2;
    UIView *popup = [self getListView];
    popup.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
    popup.layer.borderWidth = 1;
    [popup tf_showBubble:self.view
               basePoint:self.redPoint.center
         bubbleDirection:self.popupDirection
              popupParam:self.param];
}

-(UIView *)getListView {
    ClubListView *list = [[ClubListView alloc] initWithFrame:CGRectMake(0, 0, 160, 200)];
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"扫雷玩法",@"禁抢玩法",@"牛牛单倍",@"牛牛多倍", nil];
    list.dataSource = dataArray;
    
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(list) weakView = list;
    [list observerSelected:^(NSString *data) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        weakSelf.palyTypeLabel.text = data;
        [strongSelf typeFromStr:data];
        [weakView tf_hide];
    }];
    return list;
}
-(UIView *)getViewName:(NSString *)name{
    UIView *view = [[NSBundle mainBundle]loadNibNamed:name
                                                owner:nil
                                              options:nil].firstObject;
    return view;
}

- (void)typeFromStr:(NSString *)data {
    
    if ([data isEqualToString:@"扫雷玩法"]) {
        self.palyType = 1;
    } else if ([data isEqualToString:@"禁抢玩法"]) {
        self.palyType = 2;
    } else if ([data isEqualToString:@"牛牛单倍"]) {
        self.palyType = 3;
    } else if ([data isEqualToString:@"牛牛多倍"]) {
        self.palyType = 4;
    } else {
        self.palyType = 1;
    }
    
}


#pragma mark -  创建房间
/// 创建房间
- (void)onCreateBtn {   // 红包类型还没有OK
    
//    if (self.roomNameTextField.text.length == 0) {
//        [MBProgressHUD showTipMessageInWindow:@"房间名称不能为空"];
//        return;
//    }
    
    if ([self.startTextField.text integerValue] < 7 || [self.endTextField.text integerValue] > 1000 || [self.startTextField.text integerValue] > [self.endTextField.text integerValue]) {
        [MBProgressHUD showTipMessageInWindow:@"红包金额设置不能少于7大于1000"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubInfo.ID),   // 俱乐部ID
                                 @"name":self.roomNameTextField.text,   // 房间名称
                                  @"play_type":@(self.palyType),  // 玩法 1 单雷 2 禁雷场 3 牛牛不翻倍 4 牛牛翻倍
                                  @"number_limit":[NSString stringWithFormat:@"%@,%@", self.startTextField.text,self.endTextField.text]   // 红包限额区间
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/room/create"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}



- (void)setupUI {
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
    titleLabel1.text = @"房间名称";
    titleLabel1.font = [UIFont systemFontOfSize:15];
    titleLabel1.textColor = [UIColor colorWithHex:@"#343434"];
    [backView1 addSubview:titleLabel1];
    
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(backView1.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UITextField *roomNameTextField = [[UITextField alloc] init];
    roomNameTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    roomNameTextField.font = [UIFont systemFontOfSize:15];  // 字体
    roomNameTextField.placeholder = @"请输入房间名称";
    roomNameTextField.textColor = [UIColor colorWithHex:@"#666666"];  // 字体颜色
    //    clubNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    //    clubNameTextField.clearsOnBeginEditing = YES; // 当编辑时清空
    roomNameTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    roomNameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
    roomNameTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    roomNameTextField.tag = 3000;
    [backView1 addSubview:roomNameTextField];
    _roomNameTextField = roomNameTextField;
    [roomNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(90);
        make.right.equalTo(backView1.mas_right).offset(-10);
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
    
    
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPalyTypeEvent:)];
    //将手势添加到需要相应的view中去
    [backView2 addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UILabel *titleLabel2 = [[UILabel alloc] init];
    titleLabel2.text = @"玩法类型";
    titleLabel2.font = [UIFont systemFontOfSize:15];
    titleLabel2.textColor = [UIColor colorWithHex:@"#343434"];
    [backView2 addSubview:titleLabel2];
    
    [titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.left.equalTo(backView2.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *palyTypeLabel = [[UILabel alloc] init];
    palyTypeLabel.text = @"扫雷玩法";
    palyTypeLabel.font = [UIFont systemFontOfSize:15];
    palyTypeLabel.textColor = [UIColor colorWithHex:@"#343434"];
    palyTypeLabel.textAlignment = NSTextAlignmentCenter;
    [backView2 addSubview:palyTypeLabel];
    _palyTypeLabel = palyTypeLabel;
    
    [palyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.centerX.equalTo(backView2.mas_centerX).offset(10);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
//    backImageView.backgroundColor = [UIColor redColor];
    backImageView.image = [UIImage imageNamed:@"club_down"];
    [backView2 addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView2.mas_centerY);
        make.right.equalTo(backView2.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(19, 12));
    }];
    
    
    
    UIView *popV = [[UIView alloc] init];
    popV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:popV];
    
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView2.mas_bottom).offset(5);
        make.right.equalTo(backView2.mas_right).offset(-20);
        make.size.mas_equalTo(2);
    }];
    _redPoint = popV;
    
    
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
    titleLabel3.text = @"红包金额";
    titleLabel3.font = [UIFont systemFontOfSize:15];
    titleLabel3.textColor = [UIColor colorWithHex:@"#343434"];
    [backView3 addSubview:titleLabel3];
    
    [titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_left).offset(15);
        make.width.mas_equalTo(100);
    }];
    
    UITextField *startTextField = [[UITextField alloc] init];
//    startTextField.backgroundColor = [UIColor greenColor];
    startTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    startTextField.font = [UIFont systemFontOfSize:15];  // 字体
    startTextField.placeholder = @"7~1000";
    startTextField.textColor = [UIColor colorWithHex:@"#666666"];  // 字体颜色
    //    clubNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    //    clubNameTextField.clearsOnBeginEditing = YES; // 当编辑时清空
//    startTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    startTextField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
    startTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    startTextField.tag = 3001;
    [backView3 addSubview:startTextField];
    _startTextField = startTextField;
    [startTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(90);
        make.right.equalTo(backView3.mas_centerX).offset(-20);
        make.height.mas_equalTo(@(35));
    }];
    
    UILabel *titzhi = [[UILabel alloc] init];
    titzhi.text = @"至";
    titzhi.font = [UIFont systemFontOfSize:15];
    titzhi.textColor = [UIColor colorWithHex:@"#343434"];
    [backView3 addSubview:titzhi];
    
    [titzhi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(backView3.mas_centerX).offset(20);
    }];
    
    UITextField *endTextField = [[UITextField alloc] init];
//    endTextField.backgroundColor = [UIColor yellowColor];
    endTextField.borderStyle = UITextBorderStyleNone;  //边框类型
    endTextField.font = [UIFont systemFontOfSize:15];  // 字体
    endTextField.placeholder = @"7~1000";
    endTextField.textColor = [UIColor colorWithHex:@"#666666"];  // 字体颜色
    //    clubNameTextField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
    //    clubNameTextField.clearsOnBeginEditing = YES; // 当编辑时清空
//    endTextField.delegate = self;
    //textField.keyboardAppearance = UIKeyboardAppearanceAlert; // 键盘样式
    endTextField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
    endTextField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
    endTextField.tag = 3002;
    [backView3 addSubview:endTextField];
    _endTextField = endTextField;
    [endTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView3.mas_centerY);
        make.left.equalTo(titzhi.mas_right).offset(10);
        make.right.equalTo(backView3.mas_right).offset(-10);
        make.height.mas_equalTo(@(35));
    }];
    
    
    UIButton *createBtn = [UIButton new];
    createBtn.layer.cornerRadius = 50/2;
    createBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    createBtn.layer.masksToBounds = YES;
    createBtn.backgroundColor = [UIColor clearColor];
    [createBtn setTitle:@"创建房间" forState:UIControlStateNormal];
    [createBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
//    [createBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateHighlighted];
    
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(onCreateBtn) forControlEvents:UIControlEventTouchUpInside];
    createBtn.userInteractionEnabled = NO;
    [self.view addSubview:createBtn];
    [createBtn delayEnable];
    _createBtn = createBtn;
    
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.top.equalTo(backView3.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    
    
}


@end
