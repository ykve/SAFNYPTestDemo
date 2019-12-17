//
//  AgentCenterViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AgentCenterViewController.h"
#import "BecomeAgentViewController.h"
#import "ReportFormsViewController.h"
#import "SubPlayerViewController.h"
#import "ShareDetailViewController.h"
#import "PopCopyViewController.h"

#import "TFPopup.h"
#import "AgentAlertView.h"
#import "BannerModels.h"
#import "BannerModel.h"

#import "WKWebViewController.h"

#define kBannerHeight 110


@implementation CellItemView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.tag = 1;
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(-11);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize2:15];
        label.textColor = COLOR_X(80, 80, 80);
        label.tag = 2;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).offset(24);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.equalTo(@0.5);
        }];
        
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = COLOR_X(220, 220, 220);
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btn];
        self.btn.backgroundColor = [UIColor clearColor];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)setIcon:(NSString *)icon{
    UIImageView *imageView = [self viewWithTag:1];
    imageView.image = [UIImage imageNamed:icon];
}

-(void)setTitle:(NSString *)title{
    UILabel *label = [self viewWithTag:2];
    label.text = title;
}

@end







@interface AgentCenterViewController () <TFPopupDelegate,TFPopupBackgroundDelegate>
/// Banner
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) BannerModels *bannerModels;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong)CellItemView *item1;

@property(nonatomic,  copy)NSString *selectedTitle;
@property(nonatomic,  strong) AgentAlertView *agentAlertView;
@end

@implementation AgentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"代理中心";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    [self getBannerData];
    
     [self setBannerUI];
    
    self.menuArray = [NSMutableArray array];
    NSDictionary *dic = nil;
    if([AppModel sharedInstance].user_info.is_agent)
        dic = @{@"icon":@"me_agent_sqdl",@"title":@"您已是代理",@"tag":@"1"};
    else
        dic = @{@"icon":@"me_agent_sqdl",@"title":@"申请代理",@"tag":@"1"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_dlgz",@"title":@"代理规则",@"tag":@"2"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_tgwa",@"title":@"推广文案",@"tag":@"3"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_xjwj",@"title":@"下级玩家",@"tag":@"4"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_wdbb",@"title":@"我的报表",@"tag":@"5"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_fxzq",@"title":@"分享赚钱",@"tag":@"6"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_bcxzgw",@"title":@"保存下载官网",@"tag":@"7"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_bcxzdz",@"title":@"复制下载地址",@"tag":@"8"};
    [self.menuArray addObject:dic];
    dic = @{@"icon":@"me_agent_bcxzwy",@"title":@"复制推广信息",@"tag":@"9"};
    [self.menuArray addObject:dic];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //    self.scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(20, Height_NavBar + 25, self.view.bounds.size.width -20*2, 100*3)];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar+ kBannerHeight, kSCREEN_WIDTH, kSCREEN_HEIGHT -Height_NavBar-kBannerHeight-kiPhoneX_Bottom_Height)];
//    self.scrollView.frame = self.view.bounds;
    self.scrollView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
    
//    UIView *headView = [self headView];
//    [self.scrollView addSubview:headView];
    
    
    
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.image = [UIImage imageNamed:@"me_agent_bg"];
    //    [self.view addSubview:backImageView];
    [self.scrollView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(10);
        make.left.equalTo(self.scrollView.mas_left).offset(15);
        make.right.equalTo(self.scrollView.mas_right).offset(-15);
        make.height.equalTo(@(100*3));
    }];
    
    
//    NSInteger h = headView.frame.size.height;
    NSInteger perNum = 3;
    NSInteger width = (kSCREEN_WIDTH- 15*2-3*2)/perNum;
    //    NSInteger height = width * 0.6666;
    NSInteger height = 98;
    for (NSInteger i = 0; i < self.menuArray.count; i ++) {
        NSInteger m = i%perNum;
        NSInteger n = i/perNum;
        CellItemView *item = [[CellItemView alloc] initWithFrame:CGRectMake(3 + m * width, 3 + n * height, width, height)];
        //        [self.scrollView addSubview:item];
        item.backgroundColor = [UIColor clearColor];
        [backImageView addSubview:item];
        NSDictionary *dic = self.menuArray[i];
        item.title = dic[@"title"];
        item.icon = dic[@"icon"];
        item.infoDic = self.menuArray[i];
        [item.btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
            self.item1 = item;
    }
    
    if([AppModel sharedInstance].user_info.is_agent == NO){
        [self performSelector:@selector(becomeAgent) withObject:nil afterDelay:0.5];
    }
}

- (void)setBannerUI {
    
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, Height_NavBar + 10, w-10*2, kBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [self.view addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerModel *model = self.bannerModels.banners[index];
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    [vc loadWebURLSring:model.jump_url];
    //                vc.navigationItem.title = item.name;
    vc.title = model.title;
    vc.hidesBottomBarWhenPushed = YES;
    //[vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)becomeAgent{
    AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
    WEAK_OBJ(weakSelf, self);
    [view showWithText:@"您还不是代理，是否申请代理？" button1:@"取消" button2:@"提交" callBack:^(id object) {
        NSInteger index = [object integerValue];
        if(index == 1){
            
        }
    }];
}


-(void)btnAction:(UIButton *)btn{
    CellItemView *item = (CellItemView *)btn.superview;
    NSDictionary *dic = item.infoDic;
    NSInteger tag = [[dic objectForKey:@"tag"] integerValue];
    if(tag == 1){
        //        if([AppModel sharedInstance].user_info.is_agent){
        ////            [MBProgressHUD showSuccessMessage:@"您已经是代理");
        //            AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //            [view showWithText:@"您已经是代理" button:@"好的" callBack:nil];
        //            return;
        //        }
        //        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        //        WEAK_OBJ(weakSelf, self);
        //        [view showWithText:@"是否提交申请？" button1:@"取消" button2:@"提交" callBack:^(id object) {
        //            NSInteger index = [object integerValue];
        //            if(index == 1){
        //                [weakSelf toBeAgent];
        //            }
        //        }];
        if(![AppModel sharedInstance].user_info.is_agent) {
            self.selectedTitle = @"自定义3";
            TFPopupParam *param = [TFPopupParam new];
            param.disuseBackgroundTouchHide = NO;
            param.offset = CGPointMake(0, -50);  // 停止的位置
            
            AgentAlertView *view = [[AgentAlertView alloc] initWithFrame:CGRectMake(25, 50, kSCREEN_WIDTH - 25*2, 293)];
            _agentAlertView = view;
            __weak __typeof(self)weakSelf = self;
            view.alertBlock = ^(NSInteger tag) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (tag == 0) {
                    [strongSelf tf_popupViewWillHide:strongSelf.agentAlertView];
                } else {
                    [strongSelf onSubmit];
                    [strongSelf.agentAlertView tf_remove];
                }
                
            };
            
            view.popupDelegate = self;
            [view tf_showNormal:self.view popupParam:param];
            
        }
        
    }else if(tag == 2){
//        BecomeAgentViewController *vc = [[BecomeAgentViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.hiddenNavBar = YES;
//        vc.imageUrl = [AppModel sharedInstance].commonInfo[@"agent_rule"];
//        [self.navigationController pushViewController:vc animated:YES];
        
        WKWebViewController *vc = [[WKWebViewController alloc] init];
        [vc loadWebURLSring:kAgentRuleURL];
        vc.title = @"代理规则";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(tag == 3){
        PopCopyViewController *vc = [[PopCopyViewController alloc] init];
        vc.title = dic[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(tag == 4){
        PUSH_C(self, SubPlayerViewController, YES);
    } else if(tag == 5){
        ReportFormsViewController *vc = [[ReportFormsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userId = [AppModel sharedInstance].user_info.userId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if(tag == 6){
        PUSH_C(self, ShareDetailViewController, YES);
    } else if(tag == 7){
        NSString *url = [NSString stringWithFormat:@"%@?code=%zd",self.bannerModels.webSite,[AppModel sharedInstance].user_info.userId];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else if(tag == 8){
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = self.bannerModels.downLoadUrl;
        [MBProgressHUD showSuccessMessage:[NSString stringWithFormat:@"复制成功:%@", self.bannerModels.downLoadUrl]];
    } else if(tag == 9){
        UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = self.bannerModels.webSite;
        [MBProgressHUD showSuccessMessage:[NSString stringWithFormat:@"复制成功:%@", self.bannerModels.recommend]];
    }
    
    
    
    
    
}

#pragma mark -  提交申请代理
- (void)onSubmit {

        BADataEntity *entity = [BADataEntity new];
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"agent/request"];
        entity.needCache = NO;
        
        __weak __typeof(self)weakSelf = self;
        [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [MBProgressHUD hideHUD];
            if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
                [MBProgressHUD showTipMessageInWindow:@"申请代理成功"];
//                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[AFHttpError sharedInstance] handleFailResponse:response];
            }
            
        } failureBlock:^(NSError *error) {
            [[AFHttpError sharedInstance] handleFailResponse:error];
        } progressBlock:nil];

}


#pragma mark -  获取Banner数据
- (void)getBannerData {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"agent/center"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            BannerModels* model = [BannerModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.bannerModels = model;
            [strongSelf analysisData:model];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)analysisData:(BannerModels *)models {
    NSMutableArray *bannerUrlArray = [NSMutableArray array];
    for (BannerModel *model in models.banners) {
        [bannerUrlArray addObject:model.img_url];
    }
    self.cycleScrollView.imageURLStringsGroup = bannerUrlArray;
}

-(void)requestUserinfo{
    WEAK_OBJ(weakSelf, self);
    //    [NET_REQUEST_MANAGER requestUserInfoWithSuccess:^(id object) {
    //        if([AppModel sharedInstance].user_info.is_agent)
    //            weakSelf.item1.title = @"您已是代理";
    //    } fail:^(id object) {
    //
    //    }];
}
-(UIView *)headView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
    view.backgroundColor = BaseColor;
    
    float rate = 980/320.0;
    NSInteger height = (kSCREEN_WIDTH - 30)/rate + 30;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height)];
    containView.backgroundColor = [UIColor whiteColor];
    [view addSubview:containView];
    
    CGRect rect = view.frame;
    rect.size.height = height + 10;
    view.frame = rect;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"me_agent_banner"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [containView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(containView).offset(15);
        make.right.bottom.equalTo(containView).offset(-15);
    }];
    return view;
}



#pragma mark -  弹框
-(UIView *)getViewName:(NSString *)name{
    UIView *view = [[NSBundle mainBundle]loadNibNamed:name
                                                owner:nil
                                              options:nil].firstObject;
    return view;
}

- (BOOL)tf_popupViewWillShow:(UIView *)popup{
    
    if([self.selectedTitle isEqualToString:@"自定义3"]){
        [popup showDefaultBackground];
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        spring.damping = 15;
        spring.stiffness = 100;
        spring.mass = 1.0;
        spring.initialVelocity = 0;
        spring.duration = spring.settlingDuration;
        spring.fromValue = @(-10);
        spring.toValue = @(self.view.bounds.size.height * 0.5-50);  // 运动的位置
        //        spring.toValue = @(200);
        spring.fillMode = kCAFillModeForwards;
        [popup.layer addAnimation:spring forKey:nil];
        
        __weak typeof(popup) weakPopup = popup;
        [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
            if (finished) {
                //                weakPopup.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
            }
        }];
    }
    return YES;
}
- (BOOL)tf_popupViewWillHide:(UIView *)popup{
    
    [popup hideDefaultBackground];
    
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
    spring.damping = 15;
    spring.stiffness = 100;
    spring.mass = 1.5;
    spring.initialVelocity = 0;
    spring.duration = spring.settlingDuration;
    spring.fromValue = @(self.view.center.y);
    spring.toValue = @(-200);
    spring.fillMode = kCAFillModeForwards;
    [popup.layer addAnimation:spring forKey:nil];
    __weak typeof(popup) weakPopup = popup;
    [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
        if (finished) {
            weakPopup.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, -200);
        }
    }];
    return YES;

}

@end
