//
//  ShareDetailViewController.m
//  Project
//
//  Created AFan on 2019/9/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ShareDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WXManage.h"
#import "WXShareModel.h"
#import "ShareModel.h"
#import "ShareModels.h"
#import "ShareModel.h"


@interface ShareDetailViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong)UIImage *shareImage;
/// <#strong注释#>
@property (nonatomic, strong) ShareModels *shareModels;

@property (nonatomic, strong) UIImageView *qrImage;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *ccopyBtn;

@end

@implementation ShareDetailViewController

/// 导航栏透明功能
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#333333"],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:18]}];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分享赚钱";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getShareData];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.frame;
    imageView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"share_bg"];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(210, 100, 280, 100);
    image = [image resizableImageWithCapInsets:imageInsets resizingMode:UIImageResizingModeStretch];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imageView = imageView;
    
    [self.view addSubview:imageView];
    
    [self setTopView];
    [self setMidQRImage];
    [self createShareMenuView];

}

- (void)setTopView {
    UIImageView *titImgView = [[UIImageView alloc] init];
    titImgView.image = [UIImage imageNamed:@"share_tit"];
    [self.imageView addSubview:titImgView];
    
    [titImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top).offset(Height_NavBar);
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(283.5, 76));
    }];
    
    UIImageView *pdImgView = [[UIImageView alloc] init];
    pdImgView.image = [UIImage imageNamed:@"share_pd"];
    [self.imageView addSubview:pdImgView];
    
    [pdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_top).offset(Height_NavBar + 70);
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(375,  62.5));
    }];
}


-(void)createShareMenuView {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.imageView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.top.equalTo(self.qrImage.mas_bottom).offset(35);
        make.height.equalTo(@70);
    }];
    
    
    NSInteger startX = 10;
    NSInteger width = 70;
    NSInteger inv = (kSCREEN_WIDTH - width * 4 - startX * 2)/5;
    
    UIButton *tempBtn = nil;
    NSArray *arr = @[@{@"icon":@"share_wx",@"title":@"分享图片"},
                     @{@"icon":@"share_wx",@"title":@"分享链接"},
                     @{@"icon":@"share_pyq",@"title":@"分享图片"},
                     @{@"icon":@"share_pyq",@"title":@"分享链接"}
                     ];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        UIButton *btn = [self createBtn:dict[@"icon"] title:dict[@"title"]];
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [backView addSubview:btn];
        if(tempBtn){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(tempBtn.mas_right).offset(inv);
                make.centerY.equalTo(backView.mas_centerY);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(backView).offset(inv + startX);
                make.centerY.equalTo(backView.mas_centerY);
            }];
        }
        tempBtn = btn;
    }
}

-(void)setMidQRImage {

    float qrWith = 150;
    UIImageView *qrImage = [UIImageView new];
    qrImage.frame = CGRectMake(self.view.frame.size.width/2-qrWith/2, self.view.frame.size.height/2-qrWith/2 + 35,qrWith,qrWith),
    _qrImage = qrImage;
    qrImage.contentMode = UIViewContentModeScaleAspectFit;
    qrImage.image = CD_QrImg(self.shareModels.down_load_url, qrWith);
    qrImage.layer.masksToBounds = YES;
    qrImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    qrImage.layer.borderWidth = 2.0;
    [self.imageView addSubview:qrImage];
    
    
    NSInteger labelFontSize = 21;
    NSInteger labelX = 50;
    if(kSCREEN_WIDTH == 320) {
        labelX = 50;
    }
    
    UILabel *codeLabel = [[UILabel alloc] init];
//    codeLabel.frame = CGRectMake(self.view.frame.size.width/2-qrWith/2, self.view.frame.size.height/2-qrWith, qrWith, 180);
    codeLabel.textAlignment = NSTextAlignmentCenter;
    
    codeLabel.textColor = [UIColor colorWithHex:@"#343434"];
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.font = [UIFont boldSystemFontOfSize2:labelFontSize];
    [self.imageView addSubview:codeLabel];
    _codeLabel = codeLabel;
    
    codeLabel.text = [NSString stringWithFormat:@"邀请码: %zd",[AppModel sharedInstance].user_info.userId];
    codeLabel.shadowColor = [UIColor blackColor];
    codeLabel.shadowOffset = CGSizeMake(1, 1);
    
    self.shareImage = [self imageWithUIView:self.imageView];
    
    
    NSInteger btnWidth = 187.5;
    NSInteger btnHeight = 67.5;
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    copyBtn.layer.cornerRadius = 5;
    //    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    copyBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [copyBtn setTitle:@"复制我的邀请码" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(onCopyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:copyBtn];
     _ccopyBtn = copyBtn;
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.qrImage.mas_top).offset(-5);
        make.centerX.equalTo(self.imageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(btnWidth, btnHeight));
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copyBtn.mas_top).offset(1);
        make.centerX.equalTo(self.imageView.mas_centerX);
    }];
}




-(void)getShareData{
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/shares"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            ShareModels *models = [ShareModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.shareModels = models;
            
            if (models.items.count > 0) {
                strongSelf.shareModel = models.items[0];
                [strongSelf updateData];
                [strongSelf updateViewVV];
            }
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)updateViewVV {
    self.qrImage.image = CD_QrImg(self.shareModels.down_load_url, 150);
}

- (void)updateData {
    WEAK_OBJ(weakSelf, self);
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.shareModel.url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [weakSelf resetImageView];
//    }];
    
}



-(void)resetImageView{
    UIImage *img = self.imageView.image;
    if(img == nil) {
        return;
    }
    
    self.imageView.frame = CGRectMake(0, 0,img.size.width, img.size.height);
    float qrWith = img.size.width * 0.230;
    UIImageView *qrImage = [UIImageView new];
    _qrImage = qrImage;
    qrImage.contentMode = UIViewContentModeScaleAspectFit;
 
    qrImage.image = CD_QrImg(self.shareModels.down_load_url, qrWith);
    
    qrImage.layer.masksToBounds = YES;
    qrImage.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    qrImage.layer.borderWidth = 2.0;
    
    NSString *qrCodeFrame = self.shareModel.codeImageFrame;
    if(qrCodeFrame){
        NSArray *arr = [qrCodeFrame componentsSeparatedByString:@","];
        CGRect rect = CGRectMake([arr[0] integerValue], [arr[1] integerValue], [arr[2] integerValue], [arr[3] integerValue]);
        qrImage.frame = rect;
    } else {
        qrImage.frame = CGRectMake((self.imageView.frame.size.width - qrWith)/2.0, self.imageView.frame.size.height/2- qrWith/2, qrWith, qrWith);
    }
    
    [self.imageView addSubview:qrImage];
    
    NSInteger labelFontSize = 16;
    
    NSInteger labelX = 50;
    if(kSCREEN_WIDTH == 320) {
        labelX = 50;
    }
    
    UILabel *codeLabel = [[UILabel alloc] init];
    _codeLabel = codeLabel;
    codeLabel.textColor = [UIColor whiteColor];
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.font = [UIFont boldSystemFontOfSize2:labelFontSize];
    [self.imageView addSubview:codeLabel];
    codeLabel.text = [NSString stringWithFormat:@"邀请码   %zd",[AppModel sharedInstance].user_info.userId];
    codeLabel.shadowColor = [UIColor blackColor];
    codeLabel.shadowOffset = CGSizeMake(1, 1);
    NSString *codeFrame = self.shareModel.codeFrame;
    if(codeFrame){
        NSArray *arr = [qrCodeFrame componentsSeparatedByString:@","];
        CGRect rect = CGRectMake([arr[0] integerValue], [arr[1] integerValue], [arr[2] integerValue], [arr[3] integerValue]);
        codeLabel.frame = rect;
    } else {
       codeLabel.frame = CGRectMake(labelX, self.imageView.frame.size.height/2- qrWith/2 + qrWith + 20, 120, 30);
    }
    
    codeLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageView addSubview:qrImage];
    
    self.shareImage = [self imageWithUIView:self.imageView];
    float rate = img.size.width/img.size.height;
    float x = 15;
    float width = kSCREEN_WIDTH - x * 2;
    float height = width/rate;
    float xRate = width/self.shareImage.size.width;
    
    self.imageView.frame = CGRectMake(x, 15,width, height);
    
    qrImage.frame = CGRectMake(qrImage.frame.origin.x * xRate, qrImage.frame.origin.y * xRate, qrImage.frame.size.width * xRate, qrImage.frame.size.height * xRate);
    codeLabel.frame = CGRectMake(codeLabel.frame.origin.x * xRate, codeLabel.frame.origin.y * xRate, codeLabel.frame.size.width * xRate, codeLabel.frame.size.height * xRate);
    codeLabel.font = [UIFont boldSystemFontOfSize2:labelFontSize * xRate];
    CGPoint point = CGPointMake(codeLabel.frame.origin.x + self.imageView.frame.origin.x, (codeLabel.frame.origin.y + codeLabel.frame.size.height/2.0) + self.imageView.frame.origin.y);

    NSInteger mm = self.view.frame.size.height - height;
    NSInteger h = self.view.frame.size.height - mm + 150 + 30;
    if(h <= self.scrollView.frame.size.height) {
        h = self.scrollView.frame.size.height + 1;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, h);
    
//    [qrImage removeFromSuperview];
//    [label removeFromSuperview];
    codeLabel.textAlignment = NSTextAlignmentLeft;

    
    NSInteger btnWidth = 80;
    NSInteger btnHeight = 30;
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ccopyBtn = copyBtn;
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    copyBtn.layer.cornerRadius = 5;
    copyBtn.layer.cornerRadius = 5;
//    copyBtn.frame = CGRectMake(self.scrollView.frame.size.width - btnWidth - point.x, point.y - btnHeight/2.0, btnWidth, btnHeight);
    copyBtn.frame = CGRectMake(labelX + 200, self.imageView.frame.size.height/2- qrWith/2 + qrWith + 20, btnWidth, btnHeight);
//    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    copyBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [copyBtn setTitle:@"复制我的邀请码" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"copyBtn"] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(onCopyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:copyBtn];
}

-(void)createShareMenu {
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = Color_0;
    label.font = [UIFont boldSystemFontOfSize2:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"分享至";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@24);
        make.top.equalTo(view).offset(20);
    }];
    
    NSInteger startX = 10;
    NSInteger width = 70;
    NSInteger inv = (kSCREEN_WIDTH - width * 4 - startX * 2)/5;
    
    UIButton *tempBtn = nil;
    NSArray *arr = @[@{@"icon":@"share_wx",@"title":@"分享图片"},
                     @{@"icon":@"share_wx",@"title":@"分享链接"},
                     @{@"icon":@"share_pyq",@"title":@"分享图片"},
                     @{@"icon":@"share_pyq",@"title":@"分享链接"}
                     ];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = arr[i];
        UIButton *btn = [self createBtn:dict[@"icon"] title:dict[@"title"]];
        [btn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [view addSubview:btn];
        if(tempBtn){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(tempBtn.mas_right).offset(inv);
                make.top.equalTo(label.mas_bottom).offset(20);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.left.equalTo(view).offset(inv + startX);
                make.top.equalTo(label.mas_bottom).offset(20);
            }];
        }
        tempBtn = btn;
    }
}

-(UIButton *)createBtn:(NSString *)iconName title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [btn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize2:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [btn addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];
    return btn;
}

#pragma  mark - 分享方法
-(void)shareAction:(UIButton *)btn{
    NSInteger tag = btn.tag;
    NSInteger scene = WXSceneSession;
    MediaType mediaType = MediaType_image;//图片
    if(tag == 3 || tag == 4)
        scene = WXSceneTimeline;
    if(tag == 2 || tag == 4)
        mediaType = MediaType_url;//链接
    [self shareWithMediaType:mediaType scene:scene];
}

//contentType 1图片 2链接
- (void)shareWithMediaType:(MediaType)mediaType scene:(NSInteger)scene{
    WXShareModel *model = [[WXShareModel alloc]init];
    model.WXShareType = scene;//WXSceneTimeline;
    model.title = self.shareModel.name;
    model.imageIcon = [UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]];
    model.content = WXShareDescription;
    //CGSize size = self.shareImage.size;
    if(mediaType == MediaType_url){
        NSString *shareUrl = [NSString stringWithFormat:@"%@%zd",[AppModel sharedInstance].commonInfo[@"share.url"],[AppModel sharedInstance].user_info.userId];
        model.link = self.shareModels.down_load_url;
        NSLog(@"url= %@",model.link);
        model.imageData = UIImageJPEGRepresentation([UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]],1.0);
    }
    else{
        model.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
    }
//    if([WXManage isWXAppInstalled] == NO){
//        [MBProgressHUD showTipMessageInWindow:@"请先安装微信");
//        return;
//    }
    WEAK_OBJ(weakSelf, self);
    [[WXManage sharedInstance] wxShareObj:model mediaType:mediaType Success:^{
        //[MBProgressHUD showSuccessMessage:@"分享成功");
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    } Failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:2.0];
}

-(void)showAlert{
    [MBProgressHUD showTipMessageInWindow:@"请先安装微信"];
}

- (UIImage*) imageWithUIView:(UIView*) view{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

-(void)applicationWillResignActive:(NSNotification *)notification{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)onCopyBtn {
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = [NSString stringWithFormat:@"%zd", [AppModel sharedInstance].user_info.userId];
    [MBProgressHUD showSuccessMessage:@"复制成功"];
}
@end
