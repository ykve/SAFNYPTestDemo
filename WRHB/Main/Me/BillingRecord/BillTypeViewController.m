//
//  BillTypeViewController.m
//  WRHB
//
//  Created by AFan on 2019/10/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BillTypeViewController.h"
#import "BillViewController.h"
#import "BillTypeModel.h"
#import "BillItemModel.h"
#import "MeTopViewTowLabel.h"
#import "PayTopupRecordController.h"

@interface BillTypeViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIScrollView *scrollView;

/// 今日充值
@property (nonatomic, strong) MeTopViewTowLabel *topView1;
/// 今日提现
@property (nonatomic, strong) MeTopViewTowLabel *topView2;
/// 今日盈利
@property (nonatomic, strong) MeTopViewTowLabel *topView3;

@end

@implementation BillTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"资金明细";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
//    [self initData];
    
    [self setupViewUI];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, Height_NavBar +10, self.view.bounds.size.width, 100*5)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    [self getGamesRecordType];
}

- (void)setupViewUI {
    
    NSInteger width = (kSCREEN_WIDTH-20*2)/3;
    CGFloat kMarginWidth = 20;

}



- (void)setItemView {
    
    NSInteger rows = 3;
    
    NSInteger width = kSCREEN_WIDTH - (20+50/2);
    NSInteger height = 50;
    
    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
        BillTypeModel *model = self.dataArray[i];
        NSInteger a = i%rows;
        NSInteger b = i/rows;
        if (i == 0 || i == 5 || i == 6) {
            [self setupOneLevelCellViewModel:model frame:CGRectMake(0, i * height, kSCREEN_WIDTH, height) index:i];
        } else {
            [self setupTwoCellViewModel:model frame:CGRectMake(20+50/2+1, i * height, width, height) index:i];
        }
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

- (void)setupOneLevelCellViewModel:(BillTypeModel* )model frame:(CGRect)frame index:(NSInteger)index {
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = frame;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    backView.tag = index;
    
    //添加手势事件 UITapGestureRecognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapGRView:)];
    //将手势添加到需要相应的view中去
    [backView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UIImageView *titleImgView = [[UIImageView alloc] init];
    [backView addSubview:titleImgView];
    
    [titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(20);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    if (index == 0) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [backView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleImgView.mas_bottom);
            make.centerX.equalTo(titleImgView.mas_centerX);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(50*4-50/2);
        }];
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleImgView.mas_centerY);
        make.left.equalTo(titleImgView.mas_right).offset(10);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"bill_right"];
    [backView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-20);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    
    titleImgView.image = [UIImage imageNamed:model.icon];
    titleLabel.text = model.title;
    
    [self.scrollView addSubview:backView];
}


- (void)setupTwoCellViewModel:(BillTypeModel* )model frame:(CGRect)frame index:(NSInteger)index {
    
    CGFloat line1 = 27;
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = frame;
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    backView.tag = index;
    
    //添加手势事件 UITapGestureRecognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickTapGRView:)];
    //将手势添加到需要相应的view中去
    [backView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
    
    UIImageView *titleImgView = [[UIImageView alloc] init];
    [backView addSubview:titleImgView];
    
    [titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(line1);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left);
        make.right.equalTo(titleImgView.mas_left);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [backView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleImgView.mas_centerY);
        make.left.equalTo(titleImgView.mas_right).offset(10);
    }];
    
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"bill_right"];
    [backView addSubview:iconView];
//    iconView.backgroundColor = [UIColor redColor];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-20);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(8, 14));
    }];
    
    
    
    titleImgView.image = [UIImage imageNamed:model.icon];
    titleLabel.text = model.title;
    
    [self.scrollView addSubview:backView];
}

#pragma mark -   获取记录中心类型ITEM
- (void)getGamesRecordType {  // 没有 icon
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/billFinanceDesc"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        [self billItemAnalysisData:cacheJson];
    } else {
        [MBProgressHUD showActivityMessageInView:nil];
    }
    
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf billItemAnalysisData:response[@"data"]];
            //
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)billItemAnalysisData:(NSArray *)array {
    
    [self.dataArray removeAllObjects];
    NSArray *icons = @[@"me_bill_all",@"me_bill_jiangli",@"me_bill_cz",@"me_bill_tx",@"me_bill_yongjin",@"me_bill_zijin",@"me_bill_club",@"me_bill_dalianm"];
    NSArray *billArray = [BillTypeModel mj_objectArrayWithKeyValuesArray:array];
    for (NSInteger index = 0; index < billArray.count; index++) {
        BillTypeModel *model;
//        if (index == 0) {
//            model = [[BillTypeModel alloc] init];
//            model.icon = @"me_bill_all";
//            model.title = @"盈亏记录";
//            model.category = 0;
//            model.tag = index;
//        } else {
//            model =  (BillTypeModel *)billArray[index];
//            model.icon = icons[index];
//            model.tag = index;
//        }
        
        model = (BillTypeModel *)billArray[index];
        model.icon = icons[index];
        model.tag = index;
        [self.dataArray addObject:model];
    }
    
    [self setItemView];
}





//- (void)setItemView {
//
//    NSInteger rows = 3;
//
//    NSInteger width = (kSCREEN_WIDTH-20*2)/rows;
//    NSInteger height = 98;
//
//    NSInteger bottom = 0;
//    for (NSInteger i = 0; i < self.dataArray.count; i ++) {
//        BillTypeModel *model = self.dataArray[i];
//        NSInteger a = i%rows;
//        NSInteger b = i/rows;
//        UIButton *btn = [self itemWithDic:model frame:CGRectMake(a *width, b * height, width, height)];
//        btn.backgroundColor = [UIColor whiteColor];
//        [self.scrollView addSubview:btn];
//        bottom = btn.frame.origin.y + btn.frame.size.height;
//    }
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
//}




- (UIButton *)itemWithDic:(BillTypeModel *)model frame:(CGRect)rect{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = model.tag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgView = [UIImageView new];
    [btn addSubview:imgView];
    imgView.image = [UIImage imageNamed:model.icon];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.centerY.equalTo(btn.mas_centerY).offset(-11);
    }];
    
    UILabel *label = [UILabel new];
    [btn addSubview:label];
    label.textColor = [UIColor colorWithHex:@"#666666"];
    label.font = [UIFont systemFontOfSize2:15];
    label.numberOfLines = 0;
    label.text = model.title;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.centerY.equalTo(btn.mas_centerY).offset(25);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =  [UIColor colorWithHex:@"#FFE6E6"];
    [btn addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn);
        make.height.equalTo(@0.7);
        make.bottom.equalTo(btn);
    }];
    
    line = [[UIView alloc] init];
    line.backgroundColor =  [UIColor colorWithHex:@"#FFE6E6"];
    [btn addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(btn);
        make.width.equalTo(@0.5);
        make.right.equalTo(btn);
    }];
    
    return btn;
}

-(void)btnAction:(UIButton *)btn {
    NSInteger tag = btn.tag;
    BillTypeModel *model = self.dataArray[tag];
    if(tag == 9){
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
        return;
    }
    BillViewController *vc = [[BillViewController alloc] init];
    vc.title = model.title;
    vc.sourceType = 2;
    vc.billTypeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)onClickTapGRView:(UITapGestureRecognizer *)tgr {
    NSInteger tag = tgr.view.tag;
    BillTypeModel *model = self.dataArray[tag];
    if(tag == 9){
        AlertViewCus *view = [AlertViewCus createInstanceWithView:nil];
        [view showWithText:@"等待更新，敬请期待" button:@"好的" callBack:nil];
        return;
    }
    
    if ([model.title isEqualToString:@"充值记录"]) {
        PayTopupRecordController *vc = [[PayTopupRecordController alloc] init];
        vc.title = model.title;
        vc.sourceType = 2;
        vc.billTypeModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    BillViewController *vc = [[BillViewController alloc] init];
    vc.title = model.title;
    vc.sourceType = 2;
    vc.billTypeModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
