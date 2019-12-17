//
//  RedPacketItemSubVC.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "RedPacketItemSubVC.h"
#import "GamesTypeModel.h"

@interface RedPacketItemSubVC ()

@end

@implementation RedPacketItemSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isDataLoaded) {
        [self getGroupGameData];
    }
//    [self getGroupGameData];
    
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGroupGameData];
    }];
//    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark -  获取游戏群组数据
- (void)getGroupGameData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/repacket/groups/v2"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [GamesTypeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [array copy];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.collectionView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)setTopImgSelectedIndex:(NSInteger)topImgSelectedIndex {
    [super setTopImgSelectedIndex:topImgSelectedIndex];
    
    GamesTypeModel *model = self.dataArray[topImgSelectedIndex];
    
    if (model.items.count <= 0) {
        [self.view addSubview:[self setFootView]];
//        self.view.backgroundColor = [UIColor redColor];
    }
    [self.collectionView reloadData];
}


- (UIView *)setFootView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
//        backView.backgroundColor = [UIColor greenColor];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"bill_nodata_bg"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(188.5, 172.5));
    }];
    
    return backView;
}


@end

