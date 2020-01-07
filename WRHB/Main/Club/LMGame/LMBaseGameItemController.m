//
//  LMBaseGameItemController.m
//  WRHB
//
//  Created by AFan on 2019/12/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "LMBaseGameItemController.h"
#import "GameItemCollectionViewCell.h"
#import "GamesTypeModel.h"
#import "ChatsModel.h"
#import "GameTypeController.h"

#import "ChatViewController.h"
#import "ClubTwoGameTypeController.h"
#import "SPAlertController.h"

#import "TFPopup.h"
#import "AlertEntClubView.h"
#import "ClubModel.h"
#import "ClubTabBarController.h"
#import "ClubCreateRoomController.h"
#import "ClubManager.h"
#import "FLAnimatedImage.h"

static NSString * const kGameItemCollectionViewCellId = @"kGameItemCollectionViewCell";
static NSString * const kGameItemSelectedCollViewCellId = @"kGameItemSelectedCollViewCell";


@interface LMBaseGameItemController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

/// 退群使用
///
@property (nonatomic, strong) GamesTypeModel *gamesTypeModel;
///
@property (nonatomic, strong) ChatsModel *chatsModel;

@property(nonatomic, strong) TFPopupParam *popupParam;

///
@property (nonatomic, strong) AlertEntClubView *popupAlert;
/// 无数据
@property (nonatomic, strong) UIView *noDataBackView;

@end

@implementation LMBaseGameItemController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 刷新
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    
    self.popupParam = [TFPopupParam new];
    
    [self setNoDataShowView];
}

#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([ClubManager sharedInstance].clubInfo.show_alliance == 1) {
        self.noDataBackView.hidden = YES;
        return self.dataArray.count;
    }
    self.noDataBackView.hidden = NO;
    return 0;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GameItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemCollectionViewCellId forIndexPath:indexPath];
    
    NSString *avatar = nil;
    NSString *title = nil;
    GamesTypeModel *model = self.dataArray[indexPath.row];
    avatar = model.avatar;
    title = model.title;
    
    if ([model.title isEqualToString:@"创建房间"]) {
        cell.headImageView.image =  [UIImage imageNamed:avatar];
    } else {
        
        cell.headImageView.animatedImage =  [[FunctionManager sharedInstance] gifFLAnimatedImageStr:[NSString stringWithFormat:@"chats_gif_%@", avatar]];
    }
    
    cell.titleLabel.text = title;
    return cell;
    
}


#pragma mark --UICollectionViewDelegateFlowLayout  视图布局

#pragma mark --UICollectionViewDelegate 代理
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GamesTypeModel *model = self.dataArray[indexPath.row];
    ClubTwoGameTypeController *vc = [[ClubTwoGameTypeController alloc] init];
    vc.navigationItem.title = @"选择房间";
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectedItemIndex = indexPath.row;
    vc.dataArray = self.dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark -  弹框
-(TFPopupParam *)popupParam{
    if (_popupParam == nil) {
        _popupParam = [TFPopupParam new];
    }
    return _popupParam;
}


/**
 goto_create room
 */
- (void)goto_CreateRoom {
    
    ClubCreateRoomController *vc = [[ClubCreateRoomController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - 首先创建一个collectionView
- (void)initSubviews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 15*2 -15)/ 2-1;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, 116);
    
    // 设置列间距
    layout.minimumInteritemSpacing = 10;
    
    // 设置行间距
    layout.minimumLineSpacing = 10;
    
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 10, 15);

    // 设置布局方向(滚动方向)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    CGFloat height = kSCREEN_HEIGHT-Height_NavBar-kBannerHeight-kTopItemHeight-JJScorllTextLableHeight-Height_TabBar;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height) collectionViewLayout:layout];
    
    /** mainCollectionView 的布局(必须实现的) */
    _collectionView.collectionViewLayout = layout;
    
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //禁止滚动
    //_collectionView.scrollEnabled = NO;
    
    //设置代理协议
    _collectionView.delegate = self;
    
    //设置数据源协议
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[GameItemCollectionViewCell class] forCellWithReuseIdentifier:kGameItemCollectionViewCellId];
    
    [self.view addSubview:self.collectionView];
}


- (void)setNoDataShowView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
    backView.hidden = YES;
    //    backView.backgroundColor = [UIColor greenColor];
    _noDataBackView = backView;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"club_nodata"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(188.5, 172.5));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    if ([ClubManager sharedInstance].clubInfo.role == 2 || [ClubManager sharedInstance].clubInfo.role == 3) {
        nameLabel.text = @"大联盟尚未开放，请到俱乐部属性设置";
    } else {
        nameLabel.text = @"大联盟尚未开放，请联系群主";
    }
    
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(20);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    [self.view addSubview:backView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end

