//
//  ClubRedPacketItemController.m
//  WRHB
//
//  Created by AFan on 2019/12/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubRedPacketItemController.h"
#import "GamesTypeModel.h"
#import "ClubModel.h"
#import "ClubManager.h"

@interface ClubRedPacketItemController ()
///
@property (nonatomic, strong) NSMutableArray *subDataArray;

@end

@implementation ClubRedPacketItemController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getGroupGameData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 因为之前移除了
    GamesTypeModel *model = self.dataArray.firstObject;
    if (![model.title isEqualToString:@"创建房间"]) {
        [self addData];
    }
    
    [self getGroupGameData];
}

#pragma mark -  获取游戏群组数据
- (void)getGroupGameData {
    
    NSDictionary *parameters = nil;
    parameters = @{
                   @"club": @(self.clubModel.club_id)
                   };
  
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/repacket/groups/v2"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:entity.parameters];
    if (cacheJson) {
        NSArray *array = [self sortDataWithArray:[GamesTypeModel mj_objectArrayWithKeyValuesArray:cacheJson]];
        self.dataArray = [array mutableCopy];
        [self addData];
        [self.collectionView reloadData];
    }else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 结束刷新
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [self sortDataWithArray:[GamesTypeModel mj_objectArrayWithKeyValuesArray:response[@"data"]]];
            strongSelf.dataArray = [array mutableCopy];
            [strongSelf addData];
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
-(NSArray*)sortDataWithArray:(NSArray*)array {
    //用这个方法
    if (array!=nil&&array.count>0) {
        return [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                GamesTypeModel *m1 = obj1;
                GamesTypeModel *m2 = obj2;
                if ([m1.items count] > [m2.items count]) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
        }];
    }else {
        return array;
    }
    
}
- (void)addData {
    
    if ([ClubManager sharedInstance].clubInfo.role == 2 || [ClubManager sharedInstance].clubInfo.role == 3 || [ClubManager sharedInstance].clubInfo.who_create_room == 1) {
        GamesTypeModel *model = [[GamesTypeModel alloc] init];
        model.title = @"创建房间";
        model.avatar = @"club_create_room";
        [self.dataArray insertObject:model atIndex:0];
    }
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

