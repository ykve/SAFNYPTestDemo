//
//  ShareViewController.m
//  WRHB
//
//  Created AFan on 2019/9/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareListCell.h"
#import "ShareDetailViewController.h"
#import "ShareModels.h"
#import "ShareModel.h"

@interface ShareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSDictionary *tempDic;

/// <#strong注释#>
@property (nonatomic, strong) ShareModels *shareModels;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享赚钱";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    NSInteger width = (kSCREEN_WIDTH - 24)/2;
    layout.itemSize = CGSizeMake(width, 215);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(6, 8, 8, 8);
    [self.collectionView registerClass:NSClassFromString(@"ShareListCell") forCellWithReuseIdentifier:@"ShareListCell"];
    WEAK_OBJ(weakSelf, self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getShareData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [MBProgressHUD showActivityMessageInView:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.shareUrl = [ud objectForKey:@"shareUrl"];
    [self getShareData];
}

-(void)getShareData{

    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/shares"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            ShareModels *models = [ShareModels mj_objectWithKeyValues:response[@"data"]];
            strongSelf.shareModels = models;
            
            [strongSelf.collectionView reloadData];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shareModels.items.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ShareListCell";
    ShareListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    ShareModel *model = self.shareModels.items[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.pageViewLabel.text = [NSString stringWithFormat:@"%@",model.views];
    [cell.iconView cd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
    
    for (NSInteger index= 0; index < model.score; index++) {
        UIImageView *image = cell.starArray[index];
        image.hidden = NO;
    }
    
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(96, 100);
//}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_OBJ(weakSelf, self);
    ShareModel *model = self.shareModels.items[indexPath.row];
//    [MBProgressHUD showActivityMessageInView:nil];

    [weakSelf requestUrlBack:model];
}

-(void)requestUrlBack:(ShareModel *)model {
    ShareDetailViewController *vc = [[ShareDetailViewController alloc] init];
    vc.title = model.name;
    vc.shareModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
