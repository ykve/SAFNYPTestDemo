//
//  QRCodeViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+GraphicBtn.h"
#import "WXManage.h"
#import "WXShareModel.h"

@interface QRCodeViewController ()

@property (nonatomic, strong) UIView *contentView;
@property(nonatomic,strong) UIImage *shareImage;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.title = @"个人名片";
   
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = YES;
//    doneButton.layer.cornerRadius = 3;
//    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
//    doneButton.frame = CGRectMake(0, 0, 56, 30);
    [doneButton setTitle:@"保存" forState:UIControlStateNormal];
//    [doneButton setTintColor:[UIColor colorWithHex:@"#333333"]];
    [doneButton setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(onSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15,Height_NavBar + 50, kSCREEN_WIDTH - 15*2, 393)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    self.contentView = view;
    [self showView];
}


/**
 保存
 */
- (void)onSaveBtn {
     self.shareImage = [self imageWithUIView:self.contentView];
    
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数)
    UIImageWriteToSavedPhotosAlbum(self.shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    [MBProgressHUD showSuccessMessage:msg];
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


-(void)showView {
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:headImageView];
//    [headImageView sd_setImageWithURL:[NSURL URLWithString:[AppModel sharedInstance].user_info.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 5;
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(20);
        make.width.height.equalTo(@50);
    }];
    
    
    if ([AppModel sharedInstance].user_info.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", [AppModel sharedInstance].user_info.avatar]];
        if (image) {
            headImageView.image = image;
        } else {
            headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [headImageView cd_setImageWithURL:[NSURL URLWithString:[AppModel sharedInstance].user_info.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [AppModel sharedInstance].user_info.name == nil ? @"-" : [AppModel sharedInstance].user_info.name;
    nameLabel.textColor = [UIColor colorWithHex:@"#404040"];
    nameLabel.font = [UIFont systemFontOfSize2:25];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_right).offset(15);
        make.centerY.equalTo(headImageView.mas_centerY);
    }];
    
    UIImageView *sexView = [[UIImageView alloc] init];
    sexView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sexView];
    NSInteger sex = [AppModel sharedInstance].user_info.sex;
    if(sex == 2) {
        sexView.image = [UIImage imageNamed:@"me_male"];
    } else {
        sexView.image = [UIImage imageNamed:@"me_female"];
    }
    
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.centerY.equalTo(headImageView.mas_centerY);
        make.width.height.equalTo(@18);
    }];
    
    UIImage *img = CD_QrImg(self.qrCodeUrl, 800);
    UIImageView *qrView = [[UIImageView alloc] init];
    [self.contentView addSubview:qrView];
    [qrView setImage:img];
    NSInteger width = self.contentView.frame.size.height - 110*2;
    [qrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.backgroundColor = [UIColor clearColor];
    codeLabel.textColor = [UIColor colorWithHex:@"#666666"];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.font = [UIFont systemFontOfSize2:15];
    [self.contentView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(qrView.mas_bottom).offset(30);
    }];
    
    NSString *ss = [NSString stringWithFormat:@"邀请码：%ld",[AppModel sharedInstance].user_info.userId];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:ss];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#343434"] range:NSMakeRange(4, ss.length - 4)];
    codeLabel.attributedText = attributedStr;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"扫一扫上面的二维码，快来一起领红包";
    tipLabel.textColor = [UIColor colorWithHex:@"#343434"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize2:15];
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(codeLabel.mas_bottom).offset(10);
    }];
    
    
    UIButton *qqBtn = [[UIButton alloc] init];
    [self.view addSubview:qqBtn];
    qqBtn.titleLabel.font = [UIFont systemFontOfSize2:12];
    [qqBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [qqBtn setTitle:@"微信" forState:UIControlStateNormal];
    [qqBtn setTitleColor:[UIColor colorWithHex:@"#444444"] forState:UIControlStateNormal];
    [qqBtn setImagePosition:WPGraphicBtnTypeTop spacing:6];
//    qqBtn.layer.cornerRadius = 5.0f;
//    qqBtn.layer.masksToBounds = YES;
    [qqBtn addTarget:self action:@selector(onWechatBtn) forControlEvents:UIControlEventTouchUpInside];
    [qqBtn delayEnable];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-40);
        make.top.equalTo(self.contentView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(46, 70));
    }];
    
    
    UIButton *wechatBtn = [[UIButton alloc] init];
    [self.view addSubview:wechatBtn];
    wechatBtn.titleLabel.font = [UIFont systemFontOfSize2:12];
    [wechatBtn setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
    [wechatBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
    [wechatBtn setTitleColor:[UIColor colorWithHex:@"#444444"] forState:UIControlStateNormal];
    [wechatBtn setImagePosition:WPGraphicBtnTypeTop spacing:6];
    //    qqBtn.layer.cornerRadius = 5.0f;
    //    qqBtn.layer.masksToBounds = YES;
    [wechatBtn addTarget:self action:@selector(onWechatBtn) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn delayEnable];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(40);
        make.top.equalTo(self.contentView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(46, 70));
    }];
    
//    wechatBtn.backgroundColor = [UIColor greenColor];
}

- (void)onQQBtn {
    
}

- (void)onWechatBtn {
    NSInteger scene = WXSceneSession;
    MediaType mediaType = MediaType_image;//图片

    mediaType = MediaType_url;//链接
    [self shareWithMediaType:mediaType scene:scene];
}


//contentType 1图片 2链接
- (void)shareWithMediaType:(MediaType)mediaType scene:(NSInteger)scene{
    WXShareModel *model = [[WXShareModel alloc]init];
    model.WXShareType = scene;//WXSceneTimeline;
    model.title = self.qrCodeUrl;
    model.imageIcon = [UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]];
    model.content = WXShareDescription;
    //CGSize size = self.shareImage.size;
    if(mediaType == MediaType_url){
        NSString *shareUrl = [NSString stringWithFormat:@"%@%zd",[AppModel sharedInstance].commonInfo[@"share.url"],[AppModel sharedInstance].user_info.userId];
        model.link = self.qrCodeUrl;
        NSLog(@"url= %@",model.link);
        model.imageData = UIImageJPEGRepresentation([UIImage imageNamed:[[FunctionManager sharedInstance] getAppIconName]],1.0);
    }
    else{
        model.imageData = UIImageJPEGRepresentation(self.shareImage, 1.0);
    }
    //    if([WXManage isWXAppInstalled] == NO){
    //        [MBProgressHUD showErrorMessage:(@"请先安装微信");
    //        return;
    //    }
    WEAK_OBJ(weakSelf, self);
    [[WXManage sharedInstance] wxShareObj:model mediaType:mediaType Success:^{
        //SVP_SUCCESS_STATUS(@"分享成功");
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    } Failure:^(NSError *error) {
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf];
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:2.0];
}

-(void)showAlert{
    [MBProgressHUD showErrorMessage:@"请先安装微信"];
}

@end






