//
//  LoginForgetPasswordController.m
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "LoginForgetPsdController.h"
#import "WKWebViewController.h"
#import "UIButton+GraphicBtn.h"
#import "CaptchaModel.h"
#import "UIImage+ZMAdd.h"
#import <SDWebImage/SDWebImage.h>
@interface LoginForgetPsdController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    UITableView *_tableView;
    NSArray *_dataList;
    UITextField *_textField[4];
    UILabel *_sexLabel;
    NSInteger _sexType;
}
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIButton *imgCodeBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) CaptchaModel *captchaModel;

@end

@implementation LoginForgetPsdController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self setupSubViews];
    [self getImgCode];
    [self initNotif];
}

#pragma mark ----- Data
- (void)initData{
    _dataList = @[@[
                      @{@"title":@"请输入手机号",@"img":@"reg_phone"},
                      @{@"title":@"请输入验证码",@"img":@"reg_ver"},
                      @{@"title":@"请输入图形验证码",@"img":@"reg_imgcode"},
                      @{@"title":@"请输入密码",@"img":@"reg_possword"},
                      @{@"title":@"请确认密码",@"img":@"reg_possword"}]];
    _sexType = 1;
}

#pragma mark ----- UI
- (void)setupSubViews {
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"login_forgetpassword_bg"];
    [self.view addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(310));
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20,Height_NavBar +30, kSCREEN_WIDTH-20*2, kSCREEN_HEIGHT -Height_NavBar -kiPhoneX_Bottom_Height -30) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 53;
    _tableView.sectionFooterHeight = 8.0f;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 230)];
    _tableView.tableFooterView = fotView;
    
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_submit) forControlEvents:UIControlEventTouchUpInside];
    [fotView addSubview:submitBtn];
    [submitBtn delayEnable];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fotView.mas_left);
        make.right.equalTo(fotView.mas_right);
        make.height.equalTo(@(50));
        make.top.equalTo(fotView.mas_top).offset(50);
    }];

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
//限制手机号11位
- (void)textFieldDidChangeValue:(NSNotification *)text {
    UITextField *textField = (UITextField *)text.object;
    if (textField.text.length > 11 && [textField isEqual:_textField[0]]) {
        textField.text = [textField.text substringToIndex:11];
        return;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)viewDidAppear:(BOOL)animated{
    if(_textField[0].text.length == 0)
        [_textField[0] becomeFirstResponder];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *list = _dataList[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *list = _dataList[indexPath.section];
        if (indexPath.section == 0) {
            
            _textField[indexPath.row] = [UITextField new];
            _textField[indexPath.row].userInteractionEnabled = YES;
            _textField[indexPath.row].placeholder = list[indexPath.row][@"title"];
            _textField[indexPath.row].secureTextEntry = (indexPath.row == 3 || indexPath.row == 4)?YES:NO;
            _textField[indexPath.row].font = [UIFont systemFontOfSize2:14];
            _textField[indexPath.row].delegate = self;
            _textField[indexPath.row].clearButtonMode = UITextFieldViewModeWhileEditing;
            _textField[indexPath.row].returnKeyType = UIReturnKeyNext;
            _textField[indexPath.row].backgroundColor = [UIColor colorWithHex:@"#FFE1E1"];
            _textField[indexPath.row].layer.cornerRadius = 5;
            _textField[indexPath.row].layer.masksToBounds = YES;
            _textField[indexPath.row].leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 20)];
            _textField[indexPath.row].leftViewMode=UITextFieldViewModeAlways;
            
            if(indexPath.row == 0 && (self.updateType == 1 || self.updateType == 2)){
                _textField[indexPath.row].keyboardType = UIKeyboardTypePhonePad;
                _textField[indexPath.row].backgroundColor = [UIColor clearColor];
                _textField[indexPath.row].text = [AppModel sharedInstance].user_info.mobile;
                _textField[indexPath.row].userInteractionEnabled = NO;
            }
            [cell.contentView addSubview:_textField[indexPath.row]];
            
            
            CGFloat rightWidth = 15;
            [_textField[indexPath.row] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(50);
                make.height.mas_equalTo(40);
                make.right.equalTo(cell.contentView.mas_right).offset(-rightWidth);
                make.centerY.equalTo(cell.contentView.mas_centerY);
            }];
            
            
            if (indexPath.row == 1) {
                
                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = [UIColor colorWithHex:@"#FFA2A2"];
                [_textField[indexPath.row] addSubview:lineView];
                
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self->_textField[indexPath.row].mas_centerY);
                    make.right.equalTo(self->_textField[indexPath.row].mas_right).offset(-60);
                    make.size.mas_equalTo(CGSizeMake(1, 25));
                }];
                
                _codeBtn = [UIButton new];
                _codeBtn.backgroundColor = [UIColor clearColor];
                [_codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
                [_codeBtn setTitleColor:[UIColor colorWithHex:@"#FF4444"] forState:UIControlStateNormal];
                [_codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                //                _codeBtn.layer.cornerRadius = 6;
                //                _codeBtn.layer.masksToBounds = YES;
                //                _codeBtn.backgroundColor = COLOR_X(244, 112, 35);
                [_codeBtn addTarget:self action:@selector(action_getCode) forControlEvents:UIControlEventTouchUpInside];
                [_textField[indexPath.row] addSubview:_codeBtn];
                
                [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.contentView.mas_right).offset(-15);
                    make.centerY.equalTo(self->_textField[indexPath.row].mas_centerY);
                    make.height.equalTo(@(30));
                    make.width.equalTo(@(66));
                }];
                
                [_textField[indexPath.row] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left).offset(50);
                    make.height.mas_equalTo(40);
                    make.right.equalTo(_codeBtn.mas_right).offset(-4);
                    make.centerY.equalTo(cell.contentView.mas_centerY);
                }];
            }else if (indexPath.row == 2){
                _textField[indexPath.row].autocapitalizationType = UITextAutocapitalizationTypeNone;
                _imgCodeBtn =  [UIButton new];
                [_imgCodeBtn addTarget:self action:@selector(updateImgCode) forControlEvents:UIControlEventTouchUpInside];
                _imgCodeBtn.backgroundColor = BgColor;
                [cell.contentView addSubview:_imgCodeBtn];
                [_imgCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                                   make.right.equalTo(cell.contentView.mas_right).offset(-20);
                                   make.centerY.equalTo(cell.contentView.mas_centerY);
                                   make.height.equalTo(@(30));
                                   make.width.equalTo(@(86));
                               }];
                
                _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [_imgCodeBtn addSubview:_activityIndicator];
                [_activityIndicator startAnimating];
                [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(_imgCodeBtn);
                }];

            }
        }
        else if (indexPath.section == 1){
            if (indexPath.row == 0) {
//                _textField[4] = [UITextField new];
//                [cell.contentView addSubview:_textField[4]];
//                _textField[4].placeholder = list[indexPath.row][@"title"];
//                _textField[4].font = [UIFont systemFontOfSize2:15];
//                _textField[4].delegate = self;
//                _textField[4].clearButtonMode = UITextFieldViewModeWhileEditing;
//                _textField[4].returnKeyType = UIReturnKeyDone;
//                [_textField[4] mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(cell.contentView.mas_left).offset(50);
//                    make.top.bottom.equalTo(cell.contentView);
//                    make.right.equalTo(cell.contentView.mas_right).offset(-12);
//                }];
            }
        }
    }
    cell.imageView.image = [UIImage imageNamed:_dataList[indexPath.section][indexPath.row][@"img"]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
//            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
//            [sheet showInView:self.view];
        }
    }
}

//#pragma mark UIActionSheetDelegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex != 2) {
//        _sexType = buttonIndex;
//        _sexLabel.text = (_sexType == 1)?@"男":@"女";
//    }
//}

#pragma mark action
- (void)action_submit{
    if (_textField[0].text.length < 11) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的手机号"];
        return;
    }
    if (_textField[1].text.length < 3) {
        [MBProgressHUD showTipMessageInWindow:@"请入正确的验证码"];
        return;
    }
    if (_textField[2].text.length < 5) {
           [MBProgressHUD showTipMessageInWindow:@"请入正确的图形验证码"];
           return;
       }
    
    if (self.updateType == 2) {
        if (_textField[3].text.length != 6) {
            [MBProgressHUD showTipMessageInWindow:@"请输入6位交易密码"];
            return;
        }
        if (_textField[4].text.length != 6) {
            [MBProgressHUD showTipMessageInWindow:@"请输入6位交易确认密码"];
            return;
        }
        
    }else{
        if (_textField[3].text.length > 16 || _textField[3].text.length < 6) {
            [MBProgressHUD showTipMessageInWindow:@"请输入6-16位密码"];
            return;
        }
        if (_textField[4].text.length > 16 || _textField[4].text.length < 6) {
            [MBProgressHUD showTipMessageInWindow:@"请输入6-16位确认密码"];
            return;
        }
    }
    
    
    if (![_textField[3].text isEqualToString:_textField[4].text]) {
        [MBProgressHUD showTipMessageInWindow:@"密码不一致"];
        return;
    }

    NSDictionary *parameters = @{
                                 @"code":_textField[1].text,
                                 @"mobile":_textField[0].text,
                                 @"password":_textField[3].text
                                 };
    BADataEntity *entity = [BADataEntity new];
    
    
    if (self.updateType == 1) {  /// 充值登录密码
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"reset/password"];
    } else if (self.updateType == 2) {   /// 资金密码
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"reset/tradePassword"];
    } else {  /// 找回密码
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"findPassword"];
    }
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            if (self.updateType == 2) {
                [AppModel sharedInstance].set_trade_password = YES;
                [[AppModel sharedInstance] saveAppModel];
            }
            [MBProgressHUD showSuccessMessage:response[@"message"]];
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

#pragma mark -  获取验证码
- (void)action_getCode {
    if (_textField[0].text.length < 8) {
        [MBProgressHUD showTipMessageInWindow:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *parameters = @{
                                 @"mobile":_textField[0].text
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"sendCode"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccessMessage:@"发送成功，请注意查收短信"];
            [strongSelf.codeBtn beginTime:60];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  刷新图形验证码
-(void)updateImgCode {
    
    [_textField[2] becomeFirstResponder];
    [self getImgCode];
}

-(void)getImgCode {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"captcha"];
    entity.needCache = NO;
    entity.parameters = nil;
    [_activityIndicator startAnimating];
     __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_GETWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.activityIndicator stopAnimating];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.captchaModel = [CaptchaModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            UIImage *photo = [UIImage zm_decodingBase64ToImageWithString:strongSelf.captchaModel.img];
            [strongSelf.imgCodeBtn setImage:photo forState:UIControlStateNormal];
        
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.activityIndicator stopAnimating];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}
-(void)feedback{
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:[AppModel sharedInstance].commonInfo[@"pop"]];
    vc.title = @"联系客服";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _textField[0])
        [_textField[1] becomeFirstResponder];
    else if(textField == _textField[1])
        [_textField[2] becomeFirstResponder];
    else if(textField == _textField[2])
        [_textField[3] becomeFirstResponder];
    else if(textField == _textField[3])
        [_textField[4] becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

@end


