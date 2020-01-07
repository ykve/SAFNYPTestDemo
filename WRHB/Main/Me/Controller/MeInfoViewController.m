//
//  MeInfoViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MeInfoViewController.h"
#import "QRCodeViewController.h"
#import "LCActionSheet.h"
//#import "UIDevice+LCActionSheet.h"

#import "UploadFileModel.h"
#import "LocalAvatarController.h"


#define KEY_WINDOW  [UIApplication sharedApplication].keyWindow

@interface MeInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIImageView *_headIcon;
    UILabel *_nickName;
    UILabel *_sexLabel;
    NSInteger _sexType;
    NSString *_headUrl;
}

@property(atomic,strong) UIImageView *qrCodeImageView;
@property (nonatomic, assign) NSInteger rowNum;
@property (atomic, strong) UITableView *tableView;



@property (atomic, strong) UIButton *headerBtn;
@property (atomic, strong) UIImageView *headImageView;

@property (atomic, strong) UIButton *maleBtn;
@property (atomic, strong) UIButton *femaleBtn;
/// 性别
@property (nonatomic, assign) UserGender gender;

@property (atomic, strong) UploadFileModel *upUrlModel;

@property (atomic, strong) UITextField *nameTextField;
/// 是否修改头像
@property (nonatomic, assign) BOOL isModifyAvatar;

///
@property (nonatomic, copy) NSString *localImg;

@end

@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupSubViews];
    [self initLayout];
    [self addObserver];
    
    //    [self requestShareInfo];
    
    //    if (self.shareUrl) {
    //        self.rowNum = 4;
    //    }else{
    //        self.rowNum = 3;
    //    }
    self.rowNum = 4;
    
    [self getUploadURL];
    
    [self setupViewData];
}

- (void)getUploadURL {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"system/getUploadUrl"];
    entity.needCache = NO;
    
//    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            UploadFileModel *model = [UploadFileModel mj_objectWithKeyValues:response[@"data"]];
            strongSelf.upUrlModel = model;
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)setupViewData {
    
    if ([AppModel sharedInstance].user_info.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", [AppModel sharedInstance].user_info.avatar]];
        if (image) {
            self.headImageView.image = image;
        } else {
            self.headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImageView cd_setImageWithURL:[NSURL URLWithString:[AppModel sharedInstance].user_info.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
}


#pragma mark ----- Data
- (void)initData{
    _sexType = [AppModel sharedInstance].user_info.sex;
    _headUrl = [AppModel sharedInstance].user_info.avatar;
}

- (void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(action_nick:) name:@"UPDATENAME" object:nil];
}

#pragma mark ----- Layout
- (void)initLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark ----- subView
- (void)setupSubViews{
    self.navigationItem.title = @"个人信息";
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    _tableView.tableHeaderView = [self headrView];
    _tableView.tableFooterView = [self footView];
}

#pragma mark - 更换头像
- (void)action_headerBtn {
    [self showBlockActionSheet];
}

-(UIView *)headrView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 115)];
    headView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action_headerBtn)];
    //将手势添加到需要相应的view中去
    [headView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
    headImageView.layer.cornerRadius = 8;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.borderWidth = 1.5;
    headImageView.layer.borderColor = [UIColor colorWithRed:0.914 green:0.804 blue:0.631 alpha:1.000].CGColor;
    headImageView.userInteractionEnabled = YES;
    [headView addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(15);
        make.centerX.equalTo(headView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"点击更换头像";
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).offset(10);
        make.centerX.equalTo(headView.mas_centerX);
    }];
    return headView;
    
}

-(UIView *)footView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *saveBtn = [[UIButton alloc] init];
    [footView addSubview:saveBtn];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 5.0f;
    saveBtn.layer.masksToBounds = YES;
    saveBtn.backgroundColor = [UIColor redColor];
    [saveBtn addTarget:self action:@selector(action_save) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn delayEnable];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(16);
        make.right.equalTo(footView.mas_right).offset(-16);
        make.top.equalTo(footView.mas_top).offset(100);
        make.height.equalTo(@(44));
    }];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize2:15];
        cell.textLabel.textColor = Color_0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0){
            cell.textLabel.text = @"昵称";
//            _nickName = [UILabel new];
//            [cell.contentView addSubview:_nickName];
//            _nickName.font = [UIFont systemFontOfSize2:15];
//            _nickName.text = [AppModel sharedInstance].user_info.name;
//            _nickName.textColor = Color_6;
//
//            [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(cell.contentView.mas_right).offset(-12);
//                make.centerY.equalTo(cell.contentView);
//            }];
            
            
            self.nameTextField = [UITextField new];
            self.nameTextField.font = [UIFont systemFontOfSize2:14];
//            self.nameTextField.delegate = self;
           self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            self.nameTextField.returnKeyType = UIReturnKeyNext;
            self.nameTextField.backgroundColor = [UIColor whiteColor];
            self.nameTextField.text = [AppModel sharedInstance].user_info.name;
            self.nameTextField.keyboardType = UIKeyboardTypeDefault; // 键盘类型
            self.nameTextField.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:self.nameTextField];
            
            [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-12);
                make.centerY.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView.mas_left).offset(100);
                make.height.mas_equalTo(40);
            }];
            
        } else if(indexPath.row == 1){
            
            cell.textLabel.text = @"性别";
            
            
            UIButton *femaleBtn = [[UIButton alloc] init];
            [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
            [femaleBtn addTarget:self action:@selector(on_GenderAction:) forControlEvents:UIControlEventTouchUpInside];
            femaleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [femaleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            femaleBtn.backgroundColor = [UIColor whiteColor];
            femaleBtn.layer.borderWidth = 1.0;
            femaleBtn.layer.borderColor = [UIColor redColor].CGColor;
            femaleBtn.layer.cornerRadius = 20/2;
            femaleBtn.tag = 1003;
            [cell.contentView addSubview:femaleBtn];
            _femaleBtn = femaleBtn;
            
            [femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(cell.contentView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(33, 20));
            }];
            
            UIButton *maleBtn = [[UIButton alloc] init];
            [maleBtn setTitle:@"男" forState:UIControlStateNormal];
            [maleBtn addTarget:self action:@selector(on_GenderAction:) forControlEvents:UIControlEventTouchUpInside];
            maleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [maleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            maleBtn.backgroundColor = [UIColor whiteColor];
            maleBtn.layer.borderWidth = 1.0;
            maleBtn.layer.borderColor = [UIColor redColor].CGColor;
            maleBtn.layer.cornerRadius = 20/2;
            maleBtn.tag = 1002;
            [cell.contentView addSubview:maleBtn];
            _maleBtn = maleBtn;
            
            [maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView.mas_centerY);
                make.right.equalTo(femaleBtn.mas_left).offset(-20);
                make.size.mas_equalTo(CGSizeMake(33, 20));
            }];
            
            if ([AppModel sharedInstance].user_info.sex == UserGender_Male) {
                maleBtn.backgroundColor = [UIColor redColor];
                [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.gender = UserGender_Male;
            } else {
                femaleBtn.backgroundColor = [UIColor redColor];
                [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.gender = UserGender_Female;
            }
            
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"手机号";
            UILabel *label = [UILabel new];
            [cell.contentView addSubview:label];
            label.font = [UIFont systemFontOfSize2:15];
            label.textColor = Color_6;
            label.text = [[AppModel sharedInstance].user_info.mobile isEqualToString: @""] ? @"-" : [AppModel sharedInstance].user_info.mobile;
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-12);
                make.centerY.equalTo(cell.contentView);
            }];
        }
        else if(indexPath.row == 3){
            cell.textLabel.text = @"个人名片";
            UIImageView *img = [[UIImageView alloc] init];
            [cell.contentView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-12);
                make.centerY.equalTo(cell.contentView);
                make.width.height.equalTo(@30);
            }];
            if(self.shareUrl){
                img.image = CD_QrImg(self.shareUrl, 120);
            }
            self.qrCodeImageView = img;
        }
    }
    return cell;
}

#pragma mark -  性别 男 女 选择
- (void)on_GenderAction:(UIButton *)sender {
    [self.maleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.femaleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.maleBtn.backgroundColor = [UIColor whiteColor];
    self.femaleBtn.backgroundColor = [UIColor whiteColor];
    
    sender.backgroundColor = [UIColor redColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (sender.tag == 1002) {
        self.gender = UserGender_Male;
    } else if (sender.tag == 1003) {
        self.gender = UserGender_Female;
    } else {
        self.gender = UserGender_Unknown;  // 未知
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.row >0)?50:60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        //        ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[@"图片库",@"相机",@"相册"]];
        //        sheet.titleLabel.text = @"请选择来源";
        //        sheet.tag = 1;
        //        sheet.delegate = self;
        //        [sheet showWithAnimationWithAni:YES];
        
        
    }
    if (indexPath.row == 1) {
        CDPush(self.navigationController, CDVC(@"UpdateNicknameViewController"), YES);
    }
    
    if (indexPath.row == 1) {
        //        ActionSheetCus *sheet = [[ActionSheetCus alloc] initWithArray:@[@"男",@"女"]];
        //        sheet.titleLabel.text = @"请选择性别";
        //        sheet.tag = 2;
        //        sheet.delegate = self;
        //        [sheet showWithAnimationWithAni:YES];
        //        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        //        sheet.tag = 2;
        //        [sheet showInView:self.view];
    }else if(indexPath.row == 3){
        QRCodeViewController *vc = [[QRCodeViewController alloc] init];
        vc.qrCodeUrl = [NSString stringWithFormat:@"%@%zd",self.shareUrl,[AppModel sharedInstance].user_info.userId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)showBlockActionSheet {
    //  LCActionSheetConfig *config = LCActionSheetConfig.config;
    //  config.buttonColor = [UIColor orangeColor];
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        
        NSLog(@"clickedButtonAtIndex: %d, keyWindow: %p", (int)buttonIndex, KEY_WINDOW);
        
    } otherButtonTitles:@"相册", @"拍照",@"本地头像", nil];
    
    //  actionSheet.blurEffectStyle = UIBlurEffectStyleLight;
    
    actionSheet.scrolling          = YES;
    actionSheet.visibleButtonCount = 3.6f;
    
    actionSheet.willPresentHandler = ^(LCActionSheet *actionSheet) {
        NSLog(@"willPresentActionSheet, keyWindow: %p", KEY_WINDOW);
    };
    
    actionSheet.didPresentHandler = ^(LCActionSheet *actionSheet) {
        NSLog(@"didPresentActionSheet, keyWindow: %p", KEY_WINDOW);
    };
    
    actionSheet.willDismissHandler = ^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"willDismissWithButtonIndex: %d, keyWindow: %p", (int)buttonIndex, KEY_WINDOW);
        [self showImagePickerController:buttonIndex];
    };
    
    actionSheet.didDismissHandler = ^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        NSLog(@"didDismissWithButtonIndex: %d, keyWindow: %p", (int)buttonIndex, KEY_WINDOW);
//        [self showImagePickerController:buttonIndex];
    };
    
    [actionSheet show];
    
    
    // Append buttons methods
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        //    [actionSheet appendButtonWithTitle:@"WoW" atIndex:7];
//
//        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
//        [set addIndex:1];
//        [set addIndex:2];
//        [actionSheet appendButtonsWithTitles:@[@"Hello", @"World"] atIndexes:set];
//
//        //    [actionSheet setButtonTitle:@"New Title" atIndex:1];
//    });
}

- (void)showImagePickerController:(NSInteger)index {
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
    
    
#endif
    
    NSInteger indexxx  = 0;
    if (index == 1) {
        indexxx = 2;
    } else if (index == 2) {
        indexxx = 1;
    } else if (index == 3) {
        LocalAvatarController *vc = [[LocalAvatarController alloc] init];
        
        vc.target = self;
        vc.action = @selector(changeImg:);
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.sourceType = indexxx;
    pick.delegate = self;
    pick.allowsEditing = YES;
    [self presentViewController:pick animated:YES completion:nil];
    
}

- (void)changeImg:(NSString *)imgStr
{
    self.isModifyAvatar = YES;
    self.headImageView.image = [UIImage imageNamed:imgStr];
    
    NSString *imgNum = [imgStr substringFromIndex:imgStr.length-3];
    self.upUrlModel.img = imgNum;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *key = nil;
    if (picker.allowsEditing) {
        key = UIImagePickerControllerEditedImage;
    } else {
        key = UIImagePickerControllerOriginalImage;
    }
    UIImage *image = [info objectForKey:key];
    
    UIImage *img = CD_TailorImg(image, CGSizeMake(50, 50));
    [self upload:img];
    self.headImageView.image = img;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存
- (void)action_save {
    if(self.nameTextField.text.length <= 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入昵称"];
        return;
    } else if(self.nameTextField.text.length > 6){
        [MBProgressHUD showTipMessageInWindow:@"昵称不能大于6个字符"];
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"name":self.nameTextField.text,
                                 @"avatar":self.isModifyAvatar ? self.upUrlModel.img : @"",   // 没修改就不传
                                 @"sex":@(self.gender)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"user/info/modify"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf updateInfo];
            [MBProgressHUD showSuccessMessage:@"保存成功"];
            // 刷新用户信息
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUserInfoNotification object:nil];
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

- (void)updateInfo{
    [AppModel sharedInstance].user_info.avatar = _headUrl;
    [AppModel sharedInstance].user_info.name = _nickName.text;
    [AppModel sharedInstance].user_info.sex = _sexType;
    [[AppModel sharedInstance] saveAppModel];
}

- (void)upload:(UIImage *)image {

    [self uploadFile:image];
    self.isModifyAvatar = YES;

    // AFan  以后再试 PUT通过AFN来请求
//    BAImageDataEntity *imageEntity1 = [BAImageDataEntity new];
//    imageEntity1.urlString = self.model.url;
//    imageEntity1.imageArray = @[image];
//    imageEntity1.fileNames = @[@"111"];
//
////    [MBProgressHUD showActivityMessageInView:nil];
////    __weak __typeof(self)weakSelf = self;
//    [BANetManager ba_request_PUTWithEntity:imageEntity1 successBlock:^(id response) {
//        NSLog(@"*********00000 : %@", response);
//    } failureBlock:^(NSError *error) {
//        NSLog(@"1");
//    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//        NSLog(@"1");
//    }];
    
}


/*
 文件上传(put方式)
 */
- (void)uploadFile:(UIImage *)image {
    //1.创建url对象
    NSURL *url = [NSURL URLWithString:self.upUrlModel.url];
    //2.创建request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
    //设置为put方式
    request.HTTPMethod = @"PUT";
    
    //4.设置授权
    //创建账号NSData
//    NSData *accountData = [@"yyh:123456" dataUsingEncoding:NSUTF8StringEncoding];
//    //对NSData进行base64编码
//    NSString *accountStr = [accountData base64EncodedStringWithOptions:0];

    NSString *authStr = [NSString stringWithFormat:@"Bearer %@", [AppModel sharedInstance].token];
    //增加授权头字段
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];
    [request setValue:@"" forHTTPHeaderField:@"Content-Type"];
    //获取图片的路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
  
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    //6.创建上传任务f
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4 task
    /*
     Request:请求对象
     fromData:请求体
     */
//    __weak __typeof(self)weakSelf = self;
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (!error) {
            /*! 回到主线程刷新UI */
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showSuccessMessage:@"上传成功"];
//            });
        }
        //打印出响应体，查看是否发送成功
        NSLog(@"response = %@",response);
        
    }];
    
    //7.执行上传
    [uploadTask resume];

}

- (void)action_nick:(NSNotification *)notif{
    _nickName.text = notif.object[@"text"];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestShareInfo{
    WEAK_OBJ(weakSelf, self);
    self.shareUrl = @"www.baidu.com";
//    [NET_REQUEST_MANAGER getShareUrlWithCode:@"1" success:^(id object) {
//        weakSelf.shareUrl = object[@"data"];
//        if(weakSelf.shareUrl == nil){
//            [MBProgressHUD showTipMessageInWindow:@"获取分享地址失败"];
//            return;
//        }
//        [MBProgressHUD hideHUD];
//        weakSelf.rowNum = 5;
//        [weakSelf.tableView reloadData];
//    } fail:^(id object) {
//        
//    }];
}
@end

