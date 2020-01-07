//
//  EnvelopeListViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/13.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "RedPacketDetListController.h"
#import "EnvelopBackImg.h"
#import "EnvelopeNet.h"
#import "NSString+Size.h"

#import "RedPackedDetTableCell.h"
#import "RedPacketDetModel.h"
#import "GrabPackageInfoModel.h"
#import "SenderModel.h"
#import "ChatsModel.h"
#import "UIButton+GraphicBtn.h"
#import "PopSummaryModel.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


@interface RedPacketDetListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EnvelopBackImg *redView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mineLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *yuanLabel;
@property (nonatomic, strong) UIImageView *bankerPlayerImageView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *headBackView;
//
@property (nonatomic, assign) CGFloat redImgHeight;
// 未领取红包提示
@property (nonatomic, strong) UILabel *mesLabel;
// 红包详情模型
@property (nonatomic, strong) RedPacketDetModel *redEnDetModel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *bankerLabel;
@property (nonatomic, strong) UILabel *playerWinLabel;

/// 牛牛庄闲 赢 的视图高度
@property (nonatomic, assign) CGFloat bottomViewHeight;

// timeStr
@property (nonatomic, copy) NSString *oldTimeStr;
//
@property (nonatomic, assign) BOOL isClosed;
/// 重复请求定时器
@property (nonatomic, strong) NSTimer *repeatRequestTimer;

/// 显示的级别
@property (nonatomic, assign) NSInteger isShowLevel;
///
@property (nonatomic, strong) UIButton *maskBtn;
///
@property (nonatomic, strong) UIButton *popBtn;
/// 输赢
@property (nonatomic, strong) UILabel *shuyingLabel;
///
@property (nonatomic, strong) UIImageView *popImgView;

@property (nonatomic, strong) UILabel *popLabel1;
@property (nonatomic, strong) UILabel *popLabel2;
@property (nonatomic, strong) UILabel *popLabel3;
@property (nonatomic, strong) UILabel *popLabel4;

@end

@implementation RedPacketDetListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"红包详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getRedEnvelopDetData];
    
    self.bottomViewHeight = 0;
    self.oldTimeStr = @"99999";
    self.isClosed = NO;
   
    [self setNavUI];
    
    [self tableViewUI];
    [_tableView addSubview:self.headBackView];
    
    [self setHeadUI];
//    [self setPopView];
    
    //    [self setHeadData];
    //    [self setRefreshUserInfo];
    
    [_tableView registerClass:NSClassFromString(@"RedPackedDetTableCell") forCellReuseIdentifier:@"RedPackedDetTableCell"];

    
    UIButton *maskBtn = [[UIButton alloc] init];
    maskBtn.hidden = YES;
    [maskBtn addTarget:self action:@selector(onMaskBtn) forControlEvents:UIControlEventTouchUpInside];
    maskBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskBtn];
    _maskBtn = maskBtn;
    
    [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}




- (void)setNavUI {

    
    
//    CGSize size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 64);
//    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHex:@"FF3737"] size:size] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
//
//    if (self.isRightBarButton) {
//        // 右边文字
//        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"账单记录" style:UIBarButtonItemStylePlain target:self action:@selector(onGotoBill:)];
//        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
//    }
//
//    // 左边图片和文字
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, 30, 44);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
//    backButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
//    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)onBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}




/**
 拉伸背景图片

 @return View
 */
- (UIView *)headBackView {
    if (_headBackView == nil) {
        _headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -300, [UIScreen mainScreen].bounds.size.width, 300)];
        _headBackView.backgroundColor = [UIColor colorWithHex:@"#F43938"];
    }
    return _headBackView;
}

//- (UIImageView *)imgView {
//    if (_imgView == nil) {
//        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -260, [UIScreen mainScreen].bounds.size.width, 260)];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
//        _imgView.clipsToBounds = YES;
//    }
//    return _imgView;
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_redp_det"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}


/**
 设置颜色为背景图片
 
 @param color <#color description#>
 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)onGotoBill:(id)sender {
    CDPush(self.navigationController, CDPVC(@"BillTypeViewController", nil), YES);
}



- (void)tableViewUI {
    
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-Height_NavBar-kiPhoneX_Bottom_Height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    _tableView.rowHeight = 58; // 行高
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0 );
    __weak __typeof(self)weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getRedEnvelopDetData];
    }];

}

-(void)dealloc {
    [self destoryrepeatRequestTimer];
}



- (void)setHeadUI {
    
    CGFloat redImgHeight = CD_Scal(70, 667)/0.9;
    _redImgHeight = redImgHeight;
    
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.headHeight)];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 180)];
    headView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"]; 
    _headView = headView;
    _tableView.tableHeaderView = headView;
    
    
//    UIImageView *backImageView = [[UIImageView alloc] init];
//    backImageView.image = [UIImage imageNamed:@"redp_det_head_bg"];
//    [headView addSubview:backImageView];
//
//    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.equalTo(@(69));
//    }];
    
    _redView = [[EnvelopBackImg alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, redImgHeight) r:300 x:0 y:-(300-redImgHeight)];
    _redView.backgroundColor = [UIColor clearColor];
    [headView addSubview:_redView];
    
    
    _headImageView = [UIImageView new];
    
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 1.5;
    _headImageView.layer.borderColor = [UIColor colorWithRed:0.914 green:0.804 blue:0.631 alpha:1.000].CGColor;
    _headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
    [headView addSubview:_headImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.centerY.equalTo(self ->_redView.mas_bottom);
        make.height.width.equalTo(@(50));
    }];
    
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize2:15];
    _nameLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [headView addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.equalTo(self ->_headImageView.mas_bottom).offset(8);
    }];
    
    
    
    _mineLabel = [UILabel new];
    _mineLabel.font = [UIFont boldSystemFontOfSize2:15];
    _mineLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [headView addSubview:_mineLabel];
    
    [_mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.top.equalTo(self ->_nameLabel.mas_bottom).offset(5);
    }];
    
    _moneyLabel = [UILabel new];
    [headView addSubview:_moneyLabel];
    _moneyLabel.textColor = [UIColor colorWithHex:@"#343434"];
//    _moneyLabel.backgroundColor = [UIColor redColor];
    _moneyLabel.font = [UIFont boldSystemFontOfSize2:26];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self ->_mineLabel.mas_bottom).offset(5);
        make.centerX.equalTo(headView);
    }];
    
    
    _bankerPlayerImageView = [UIImageView new];
    [headView addSubview:_bankerPlayerImageView];
    
    [_bankerPlayerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyLabel.mas_centerY);
        make.right.equalTo(self.moneyLabel.mas_left).offset(-50);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    // 元
    _yuanLabel = [UILabel new];
    [headView addSubview:_yuanLabel];
    _yuanLabel.textColor = Color_3;
    _yuanLabel.font = [UIFont boldSystemFontOfSize2:15];
    
    [_yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.moneyLabel.mas_bottom).offset(-2);
        make.right.equalTo(self.moneyLabel.mas_left).offset(0);
    }];
    
//    _timeLabel = [UILabel new];
//    [headView addSubview:_timeLabel];
//    _timeLabel.textColor = [UIColor redColor];
//    _timeLabel.font = [UIFont systemFontOfSize:18];
//
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
//        make.centerX.equalTo(headView.mas_centerX);
//    }];
    
    
    if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
        // ****** 庄、闲视图 ******
        [self headBottomView];
    }
    
}

#pragma mark -  popImage

- (void)onMaskBtn {
    self.popImgView.hidden = YES;
//    self.popImgView = nil;
    self.maskBtn.hidden = YES;
}

- (void)on_popBtn {
    self.popImgView.hidden = NO;
    self.maskBtn.hidden = NO;
}

- (void)setPopView {
    CGFloat beHeight = 10;
    
    UIButton *popBtn = [UIButton new];
    [popBtn setTitle:@"实际输赢" forState:UIControlStateNormal];
    popBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [popBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"redp_pop_btn"] forState:UIControlStateNormal];
    [popBtn addTarget:self action:@selector(on_popBtn) forControlEvents:UIControlEventTouchUpInside];
    [popBtn setImagePosition:WPGraphicBtnTypeRight spacing:5];
    popBtn.hidden = YES;
    [self.headView addSubview:popBtn];
    _popBtn = popBtn;
    
    [popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView.mas_right).offset(-20);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-beHeight);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *shuyingLabel = [[UILabel alloc] init];
//    shuyingLabel.text = @"-";
    shuyingLabel.font = [UIFont systemFontOfSize:12];
    shuyingLabel.textColor = [UIColor colorWithHex:@"#343434"];
    shuyingLabel.textAlignment = NSTextAlignmentRight;
    shuyingLabel.hidden = YES;
    [self.view addSubview:shuyingLabel];
    _shuyingLabel = shuyingLabel;
    
    [shuyingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView.mas_right).offset(-20);
        make.bottom.equalTo(self.headView.mas_bottom).offset(-beHeight);
    }];
    
    
    UIImageView *popImgView = [[UIImageView alloc] init];
    popImgView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(8, 8, 12, 8);
    UIImage *image = [UIImage imageNamed:@"redp_pop"];
    image = [image resizableImageWithCapInsets:imageInsets resizingMode:UIImageResizingModeStretch];
    popImgView.image = image;
    popImgView.hidden = YES;
    [self.headView addSubview:popImgView];
    _popImgView = popImgView;
    
    [popImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.popBtn.mas_right).offset(5);
        make.bottom.equalTo(self.popBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(90, 105));
    }];
    
    
    CGFloat topSH = 5;
    
    UILabel *popLabel1 = [[UILabel alloc] init];
//    popLabel1.text = @"-";
    popLabel1.font = [UIFont systemFontOfSize:12];
    popLabel1.textColor = [UIColor colorWithHex:@"#343434"];
    [popImgView addSubview:popLabel1];
    _popLabel1 = popLabel1;
    
    [popLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popImgView.mas_top).offset(10);
        make.left.equalTo(popImgView.mas_left).offset(10);
    }];
    
    
    UILabel *popLabel2 = [[UILabel alloc] init];
//    popLabel2.text = @"-";
    popLabel2.font = [UIFont systemFontOfSize:12];
    popLabel2.textColor = [UIColor colorWithHex:@"#343434"];
    [popImgView addSubview:popLabel2];
    _popLabel2 = popLabel2;
    
    [popLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popLabel1.mas_bottom).offset(topSH);
        make.left.equalTo(popImgView.mas_left).offset(10);
    }];
    
    UILabel *popLabel3 = [[UILabel alloc] init];
//    popLabel3.text = @"-";
    popLabel3.font = [UIFont systemFontOfSize:12];
    popLabel3.textColor = [UIColor colorWithHex:@"#343434"];
    [popImgView addSubview:popLabel3];
    _popLabel3 = popLabel3;
    
    [popLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popLabel2.mas_bottom).offset(topSH);
        make.left.equalTo(popImgView.mas_left).offset(10);
    }];
    
    UILabel *popLabel4 = [[UILabel alloc] init];
//    popLabel4.text = @"-";
    popLabel4.font = [UIFont systemFontOfSize:12];
    popLabel4.textColor = [UIColor colorWithHex:@"#343434"];
    [popImgView addSubview:popLabel4];
    _popLabel4 = popLabel4;
    
    [popLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(popLabel3.mas_bottom).offset(topSH);
        make.left.equalTo(popImgView.mas_left).offset(10);
    }];
}

/**
 VS 庄、闲统计视图
 */
- (void)headBottomView {
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    [self.headView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    [self.headView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headView.mas_bottom);
        make.left.equalTo(self.headView.mas_left);
        make.right.equalTo(self.headView).multipliedBy(0.5);
        make.height.equalTo(@(30));
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.equalTo(leftView.mas_top);
        make.size.mas_equalTo(leftView);
    }];
    
    UILabel *bankerTitleLabel = [UILabel new];
    bankerTitleLabel.text = @"庄赢";
    [leftView addSubview:bankerTitleLabel];
    bankerTitleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    bankerTitleLabel.font = [UIFont boldSystemFontOfSize2:15];
    
    [bankerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.centerX.equalTo(leftView.mas_centerX).offset(-10);
    }];
    
    _bankerLabel = [[UILabel alloc] init];
    [leftView addSubview:_bankerLabel];
    _bankerLabel.textColor = [UIColor redColor];
    _bankerLabel.font = [UIFont boldSystemFontOfSize2:15];
    
    [_bankerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bankerTitleLabel.mas_centerY);
        make.left.equalTo(bankerTitleLabel.mas_right).offset(5);
    }];
    
    
    UILabel *playerWinTitleLabel = [UILabel new];
    playerWinTitleLabel.text = @"闲赢";
    [rightView addSubview:playerWinTitleLabel];
    playerWinTitleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    playerWinTitleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [playerWinTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rightView.mas_centerY);
        make.centerX.equalTo(rightView.mas_centerX).offset(-10);;
    }];
    
    _playerWinLabel = [[UILabel alloc] init];
    [rightView addSubview:_playerWinLabel];
    _playerWinLabel.textColor = [UIColor redColor];
    _playerWinLabel.font = [UIFont boldSystemFontOfSize2:15];
    
    [_playerWinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playerWinTitleLabel.mas_centerY);
        make.left.equalTo(playerWinTitleLabel.mas_right).offset(5);
    }];
}







-(void)setRefreshUserInfo {
    
    if (self.redEnDetModel.sender.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", self.redEnDetModel.sender.avatar]];
        if (image) {
            _headImageView.image = image;
        } else {
            _headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [_headImageView cd_setImageWithURL:[NSURL URLWithString:self.redEnDetModel.sender.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    
    _nameLabel.text = self.redEnDetModel.sender.name;
    _mineLabel.text = self.redEnDetModel.title;
    _bankerPlayerImageView.hidden = YES;
    
    if (self.redEnDetModel.redpacketType == RedPacketType_CowCowNoDouble || self.redEnDetModel.redpacketType == RedPacketType_CowCowDouble) {
        
        if ([AppModel sharedInstance].user_info.userId == self.bankerId) {
            
            self.bankerLabel.text = [NSString stringWithFormat:@"%ld", self.redEnDetModel.banker_wins];
            self.playerWinLabel.text = [NSString stringWithFormat:@"%ld", self.redEnDetModel.player_wins];
        } else {
            // 自己抢的
            if (self.redEnDetModel.itselfMoney > 0) {
                _bankerPlayerImageView.hidden = NO;
                if (self.redEnDetModel.isItselfWin) {
                    _bankerPlayerImageView.image = [UIImage imageNamed:@"cow_win"];
                } else {
                    _bankerPlayerImageView.image = [UIImage imageNamed:@"cow_lose"];
                }
            }
            
            // AFan  待确认是否这样
            self.bankerLabel.text = [NSString stringWithFormat:@"%zd", self.redEnDetModel.banker_wins];
            self.playerWinLabel.text = [NSString stringWithFormat:@"%zd", self.redEnDetModel.player_wins];
        }
        
    }
    
    
    if (self.redEnDetModel.sender.ID == [AppModel sharedInstance].user_info.userId) {  // 自己
        
        if (self.redEnDetModel.sender.value.floatValue == 0) {  // 自己没抢的
            self.moneyLabel.hidden = YES;
            self.yuanLabel.hidden = YES;
            self.yuanLabel.text = @"";
            
        } else {
            
            if (self.redEnDetModel.redpacketType == RedPacketType_SingleMine) {
                NSRange startRange = [self.redEnDetModel.title rangeOfString:@"["];
                NSRange endRange = [self.redEnDetModel.title rangeOfString:@"]"];
                NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
                NSString *result = [self.redEnDetModel.title substringWithRange:range];
                NSString *curstring = [self.redEnDetModel.sender.value substringFromIndex:self.redEnDetModel.sender.value.length-1];
                
                if ([result isEqualToString:curstring]) {
                    /**
                     contentStr  为要被修改的字符串
                     redRange   为要被修改颜色的特定字符位置
                     */
                    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:self.redEnDetModel.sender.value];
                    //找出特定字符在整个字符串中的位置
                    NSRange redRange = NSMakeRange(self.redEnDetModel.sender.value.length -1, 1);
                    //修改特定字符的颜色
                    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
                    //修改特定字符的字体大小
                    [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28] range:redRange];
                    [self.moneyLabel setAttributedText:contentStr];
                } else {
                    self.moneyLabel.text = self.redEnDetModel.sender.value;
                }
                
            } else {
                self.moneyLabel.text = self.redEnDetModel.sender.value;
            }
            
            self.moneyLabel.hidden = NO;
            self.yuanLabel.hidden = NO;
            self.yuanLabel.text = @"￥";
        }
        
    } else if (self.redEnDetModel.sender.value.floatValue != 0) {
        
        if (self.redEnDetModel.redpacketType == RedPacketType_SingleMine) {
            NSRange startRange = [self.redEnDetModel.title rangeOfString:@"["];
            NSRange endRange = [self.redEnDetModel.title rangeOfString:@"]"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [self.redEnDetModel.title substringWithRange:range];
            NSString *curstring = [self.redEnDetModel.sender.value substringFromIndex:self.redEnDetModel.sender.value.length-1];
            
            if ([result isEqualToString:curstring]) {
                /**
                 contentStr  为要被修改的字符串
                 redRange   为要被修改颜色的特定字符位置
                 */
                NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:self.redEnDetModel.sender.value];
                //找出特定字符在整个字符串中的位置
                NSRange redRange = NSMakeRange(self.redEnDetModel.sender.value.length -1, 1);
                //修改特定字符的颜色
                [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
                //修改特定字符的字体大小
                [contentStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:28] range:redRange];
                [self.moneyLabel setAttributedText:contentStr];
            } else {
                self.moneyLabel.text = self.redEnDetModel.sender.value;
            }
            
        } else {
            self.moneyLabel.text = self.redEnDetModel.sender.value;
        }
        
        self.moneyLabel.hidden = NO;
        self.yuanLabel.hidden = NO;
    } else {
        self.moneyLabel.hidden = YES;
        self.yuanLabel.hidden = YES;
    }
    
    
    
    
    // 未领取红包提示Label
    if (self.redEnDetModel.remain_piece == 0) {
        self.mesLabel.hidden = YES;
    } else {
        self.mesLabel.hidden = NO;
    }
    
    CGRect headFrame = self.headView.frame;
    headFrame.size.height = self.headHeight;
    self.headView.frame = headFrame;
    
}

- (void)popViewShow {
    /// 0 不显示 1 只显示 输赢 不显示按钮  2 显示 抢包金额，发包金额   3 显示 抢包、发包、中雷、输赢
    NSInteger isShowLevel = 1;   // 显示级别
    if (!self.redEnDetModel.summary) {
        isShowLevel = 0;
    } else if (self.redEnDetModel.summary.grabDesc.length > 0 && self.redEnDetModel.summary.sendDesc.length > 0 && self.redEnDetModel.summary.mimeDesc.length > 0 && self.redEnDetModel.summary.resultDesc.length > 0) {
        isShowLevel = 3;
    } else if ((self.redEnDetModel.summary.grabDesc.length > 0 && self.redEnDetModel.summary.sendDesc.length > 0 ) && (self.redEnDetModel.summary.mimeDesc.length == 0 && self.redEnDetModel.summary.resultDesc.length == 0)) {   // 抢包金额，发包金额
        isShowLevel = 2;
    }
    
    
    if (isShowLevel == 0) {
        self.popBtn.hidden = YES;
        self.shuyingLabel.hidden = YES;
    } else if (isShowLevel == 3) {
        self.popBtn.hidden = NO;
        self.shuyingLabel.hidden = YES;
        
        self.popLabel1.text = self.redEnDetModel.summary.grabDesc;
        self.popLabel2.text = self.redEnDetModel.summary.sendDesc;
        self.popLabel3.text = self.redEnDetModel.summary.mimeDesc;
        self.popLabel4.text = self.redEnDetModel.summary.resultDesc;
        
        [self.popImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 105));
        }];
        
    } else if (isShowLevel == 2) {
        self.popBtn.hidden = NO;
        self.shuyingLabel.hidden = YES;
        
        self.popLabel1.text = self.redEnDetModel.summary.grabDesc;
        self.popLabel2.text = self.redEnDetModel.summary.sendDesc;
        
        [self.popImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 65));
        }];
    } else {
        self.popBtn.hidden = YES;
        self.shuyingLabel.hidden = NO;
        
        self.shuyingLabel.text = self.redEnDetModel.summary.resultDesc;
    }
    
}



#pragma mark -  计算HeadView高度
/**
 计算HeadView高度
 
 @return 高度值
 */
- (CGFloat)headHeight {
    
        CGFloat nameHeihgt = [self.redEnDetModel.sender.name heightWithFont:[UIFont boldSystemFontOfSize2:15] constrainedToWidth:kSCREEN_WIDTH];
    
        NSString *titleStr = [NSString stringWithFormat:@"%@", self.redEnDetModel.title];
        CGFloat titleHeihgt = 0;
        if (![titleStr isEqualToString:@"(null)"] && titleStr.length > 0) {
            titleHeihgt = [titleStr heightWithFont:[UIFont boldSystemFontOfSize2:15] constrainedToWidth:kSCREEN_WIDTH];
        }
    
    
        NSString *moneyStr = [NSString stringWithFormat:@"%@",self.redEnDetModel.sender.value];
        CGFloat moneyHeihgt = 0;
        if (![moneyStr isEqualToString:@"(null)"] && moneyStr.length > 0) {
            moneyHeihgt = [moneyStr heightWithFont:[UIFont boldSystemFontOfSize2:26] constrainedToWidth:kSCREEN_WIDTH];
        }
    
        NSString *timeStr = @"";
        CGFloat timeHeihgt = 0;
        if (![timeStr isEqualToString:@"(null)"] && timeStr.length > 0) {
            timeHeihgt = [timeStr heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kSCREEN_WIDTH];
        }
    
        if (self.redEnDetModel.redpacketType == RedPacketType_SingleMine) {  // 扫雷 单雷
            self.bottomViewHeight = 0;
        } else if ((self.redEnDetModel.redpacketType == RedPacketType_CowCowNoDouble || self.redEnDetModel.redpacketType == RedPacketType_CowCowDouble) && [AppModel sharedInstance].user_info.userId == self.bankerId) {
            self.bottomViewHeight = 30;
        } else if (self.redEnDetModel.redpacketType == RedPacketType_CowCowNoDouble || self.redEnDetModel.redpacketType == RedPacketType_CowCowDouble) {
            self.bottomViewHeight = 30;
        }  else {
            self.bottomViewHeight = 0;
        }
    
        CGFloat totalHeight = self.redImgHeight + nameHeihgt + titleHeihgt + moneyHeihgt + timeHeihgt + self.bottomViewHeight + 50;
    
        return totalHeight;
}


//
- (void)destoryrepeatRequestTimer {
    dispatch_main_async_safe(^{
        if (self.repeatRequestTimer) {
            if ([self.repeatRequestTimer respondsToSelector:@selector(isValid)]){
                if ([self.repeatRequestTimer isValid]){
                    [self.repeatRequestTimer invalidate];
                    self.repeatRequestTimer = nil;
                }
            }
        }
    })
}

//
- (void)initTimer {
    dispatch_main_async_safe(^{
        [self destoryrepeatRequestTimer];
        self.repeatRequestTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentRequestData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.repeatRequestTimer forMode:NSRunLoopCommonModes];
    })
}

#pragma mark - 获取红包详情
- (void)getRedEnvelopDetData {
    
    NSDictionary *parameters = @{
                                 @"redpacket":self.redPackedId
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"redpacket/detail"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && ([[response objectForKey:@"status"] integerValue] == 1)) {
            [strongSelf analysisData:response];
            [strongSelf setReLoadData];
        } else {
            [strongSelf setReLoadData];
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (void)analysisData:(NSDictionary *)response {
    NSDictionary *data = [response objectForKey:@"data"];
    if (data != NULL) {
        
        RedPacketDetModel *redPacketDesModel = [RedPacketDetModel mj_objectWithKeyValues:data];
        
        //            [self.dataList removeAllObjects];
        if (redPacketDesModel.redpacketType == RedPacketType_Private) {
            redPacketDesModel.remain_piece = redPacketDesModel.sender.remain_count.integerValue;
            redPacketDesModel.grab_piece = redPacketDesModel.sender.packet_count - redPacketDesModel.sender.remain_count.integerValue;
            redPacketDesModel.total = redPacketDesModel.sender.amount;
            redPacketDesModel.title = redPacketDesModel.sender.title;
        }
        _redEnDetModel = redPacketDesModel;
        NSInteger luckMaxIndex = 0;
        CGFloat moneyMax = 0.0;
        
        if (redPacketDesModel.remain_piece == 0) {
            
            for (NSInteger i = 0; i < redPacketDesModel.grab_logs.count; i++) {
                // 计算手气最佳
                GrabPackageInfoModel *grabInfo = redPacketDesModel.grab_logs[i];
                NSString *strMoney = [grabInfo.value stringByReplacingOccurrencesOfString:@"*" withString:@"0"];
                CGFloat money = [strMoney floatValue];
                if (money > moneyMax) {
                    moneyMax = money;
                    luckMaxIndex = i;
                }
                
            }
            
        }
        
        for (NSInteger i = 0; i < redPacketDesModel.grab_logs.count; i++) {
            
            GrabPackageInfoModel *grabInfo = redPacketDesModel.grab_logs[i];
            
            BOOL isItself = NO;
            //                SenderModel
            NSInteger userId = redPacketDesModel.sender.ID;
            if (userId == [AppModel sharedInstance].user_info.userId) {
                redPacketDesModel.is_sender = YES;
                isItself = YES;
            } else {
                isItself = NO;
            }
            
            
            if (redPacketDesModel.remain_piece == 0) {
                // 手气最佳
                if (luckMaxIndex == i) {
                    grabInfo.isLuck = self.redEnDetModel.redpacketType == RedPacketType_Private?NO:YES;
                } else {
                    grabInfo.isLuck = NO;
                }
            }
            
            if (self.redEnDetModel.redpacketType == RedPacketType_Private) {
                grabInfo.value = redPacketDesModel.sender.amount;
            }
            
            if (redPacketDesModel.redpacketType == 2) {  // 庄 闲
                // 是
                NSInteger sendUserId = redPacketDesModel.sender.ID;
                NSInteger userId =  redPacketDesModel.sender.ID;
                if (sendUserId == userId) {
                    grabInfo.is_banker = YES;
                } else {
                    grabInfo.is_banker = NO;
                }
                
                // 判断庄闲 输-赢
                if (redPacketDesModel.bankerPointsNum > grabInfo.nn_type) {
                    if (isItself) {
                        redPacketDesModel.isItselfWin = NO;
                    }
                } else if (redPacketDesModel.bankerPointsNum == grabInfo.nn_type) {
                    
                    if (redPacketDesModel.bankerMoney >= grabInfo.value.floatValue) {
                        if (isItself) {
                            redPacketDesModel.isItselfWin = NO;
                        }
                    } else {
                        if (isItself) {
                            redPacketDesModel.isItselfWin = YES;
                        }
                    }
                } else {
                    if (isItself) {
                        redPacketDesModel.isItselfWin = YES;
                    }
                }
            }
        }
    }
    
}


- (void)setReLoadData {
    
    if (self.redEnDetModel.redpacketType == RedPacketType_CowCowNoDouble || self.redEnDetModel.redpacketType == RedPacketType_CowCowDouble) {
        // ****** 庄、闲视图 ******
        [self headBottomView];
    }

    [self setRefreshUserInfo];
    [self popViewShow];
    
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshing];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSString *str = [NSString stringWithFormat:@"已领取%ld/%ld个，共%@元/%@元",self.redEnDetModel.grab_piece,(self.redEnDetModel.grab_piece + self.redEnDetModel.remain_piece),self.redEnDetModel?self.redEnDetModel.grab_value?self.redEnDetModel.grab_value:@"":@"0", self.redEnDetModel?self.redEnDetModel.total?self.redEnDetModel.total:@"0":@"0"];
    
    
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    sectionHeaderView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    //sectionHeaderView.layer.shadowColor = [UIColor blackColor].CGColor;
//    sectionHeaderView.layer.shadowOffset = CGSizeMake(0, 0);
//    sectionHeaderView.layer.shadowOpacity = 0.1;
    
    // 单边阴影 顶边
//    float shadowPathWidth = sectionHeaderView.layer.shadowRadius;
//    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, sectionHeaderView.bounds.size.width, shadowPathWidth);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
//    sectionHeaderView.layer.shadowPath = path.CGPath;
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [sectionHeaderView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionHeaderView.mas_top);
        make.left.equalTo(sectionHeaderView.mas_left).offset(15);
        make.right.equalTo(sectionHeaderView.mas_right).offset(-15);
        make.bottom.equalTo(sectionHeaderView.mas_bottom);
    }];
    
    UILabel *label = [UILabel new];
    [backView addSubview:label];
    label.font = [UIFont systemFontOfSize2:13];
    label.textColor = [UIColor colorWithHex:@"#666666"];
    label.text = str;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    UILabel *settlLabel = [UILabel new];
    [backView addSubview:settlLabel];
    settlLabel.font = [UIFont systemFontOfSize2:13];
    settlLabel.textColor = [UIColor colorWithHex:@"#666666"];
    
    if (self.redEnDetModel.sender.result) {
        settlLabel.text = [NSString stringWithFormat:@"输赢:%@", self.redEnDetModel.sender.result];
    }
    
    [settlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1.000];
    [backView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(backView);
        make.height.mas_equalTo(0.5);
    }];
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.redEnDetModel.grab_logs.count;
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RedPackedDetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedPackedDetTableCell"];
    if(cell == nil) {
        cell = [RedPackedDetTableCell cellWithTableView:tableView reusableId:@"RedPackedDetTableCell"];
    }
    cell.redpacketType = self.redEnDetModel.redpacketType;
    // 倒序
    cell.model = self.redEnDetModel.grab_logs[indexPath.row];
    return cell;
    
    //    return [tableView CDdequeueReusableCellWithIdentifier:_model.dataList[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -  倒计时按钮
/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    
    __weak __typeof(self)weakSelf = self;
    
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (timeOut <= 0) {
            //            NSLog(@"🔴=1==%@", [NSThread currentThread]);
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                self.timeLabel.backgroundColor = mColor;
                strongSelf.timeLabel.textColor = [UIColor redColor];
                
                if (![strongSelf.timeLabel.text isEqualToString:@"本包游戏已截止"]) {
                    strongSelf.timeLabel.text = title;
                } else {
                    NSLog(@"1");
                }
                //                self.timeLabel.userInteractionEnabled = YES;
            });
            //            [strongSelf getData];
        } else {
            
            NSString *timeStr = [NSString stringWithFormat:@"%0.2ld", (long)timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                //                self.timeLabel.backgroundColor = color;
                if ([timeStr integerValue] <= [self.oldTimeStr integerValue] && !self.isClosed) {
                    strongSelf.timeLabel.textColor = [UIColor redColor];
                    strongSelf.timeLabel.text = [NSString stringWithFormat:@"剩余%@%@",timeStr,subTitle];
                    //                    self.timeLabel.userInteractionEnabled = NO;
                    strongSelf.oldTimeStr = timeStr;
                }
                
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
@end
