//
//  LMRedPacketItemController.m
//  WRHB
//
//  Created by AFan on 2019/12/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "LMRedPacketItemController.h"
#import "GamesTypeModel.h"
#import "ClubModel.h"
#import "ClubManager.h"

@interface LMRedPacketItemController ()
///
@property (nonatomic, strong) NSMutableArray *subDataArray;

@end

@implementation LMRedPacketItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getGroupGameData];
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGroupGameData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -  获取游戏群组数据
- (void)getGroupGameData {
    
    NSDictionary *parameters = nil;
    parameters = @{
                   @"alliance": @(1)
                   };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/repacket/groups/v2"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:entity.parameters];
    if (cacheJson) {
        NSArray *array = [GamesTypeModel mj_objectArrayWithKeyValuesArray:cacheJson];
        self.dataArray = [array mutableCopy];
        [self.collectionView reloadData];
    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [GamesTypeModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [array mutableCopy];
            [strongSelf.collectionView reloadData];
            
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:entity.parameters completed:^(BOOL result) {
                NSLog(@"1");
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


- (UIView *)setFootView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    //    backView.backgroundColor = [UIColor greenColor];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"club_nodata"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(188.5, 172.5));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"此玩法暂未创建房间，请联系群主";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(20);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    return backView;
}




@end


