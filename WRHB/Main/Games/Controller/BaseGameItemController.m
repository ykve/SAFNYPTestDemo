//
//  BaseViewController.m
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import "BaseGameItemController.h"
#import "GameItemCollectionViewCell.h"
#import "GamesTypeModel.h"
#import "ChatsModel.h"
#import "GameTypeController.h"

#import "ChatViewController.h"
#import "TwoGameTypeController.h"
#import "SPAlertController.h"

#import "TFPopup.h"
#import "AlertEntClubView.h"
#import "ClubModel.h"
#import "ClubTabBarController.h"
#import "ClubManager.h"
#import "FLAnimatedImage.h"

static NSString * const kGameItemCollectionViewCellId = @"kGameItemCollectionViewCell";
static NSString * const kGameItemSelectedCollViewCellId = @"kGameItemSelectedCollViewCell";


@interface BaseGameItemController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


/// 退群使用
///
@property (nonatomic, strong) GamesTypeModel *exitGamesTypeModel;
///
@property (nonatomic, strong) ChatsModel *exitChatsModel;

@property(nonatomic, strong) TFPopupParam *popupParam;

@property(nonatomic, strong) ClubModel *clubModel;

///
@property (nonatomic, strong) AlertEntClubView *popupAlert;

@end

@implementation BaseGameItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    
    self.popupParam = [TFPopupParam new];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}


#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    
    cell.headImageView.animatedImage =  [[FunctionManager sharedInstance] gifFLAnimatedImageStr:[NSString stringWithFormat:@"chats_gif_%@", avatar]];
    
    cell.titleLabel.text = title;
    return cell;
    
}



#pragma mark --UICollectionViewDelegateFlowLayout  视图布局

#pragma mark --UICollectionViewDelegate 代理
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 1) {
        [self getMyJoinClubData];
        return;
    }
    TwoGameTypeController *vc = [[TwoGameTypeController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.selectedItemIndex = indexPath.row;
    vc.navigationItem.title = @"选择房间";
    
    //        GamesTypeModel *model = self.dataArray[indexPath.row];
    vc.dataArray = self.dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (void)actionSheetArray:(NSArray *)array {
    SPAlertController *alertController = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet];
    alertController.needDialogBlur = YES;
    
    SPAlertAction *action1 = [SPAlertAction actionWithTitle:@"加入俱乐部" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        [self joinClub];
    }];
    SPAlertAction *action2 = [SPAlertAction actionWithTitle:@"创建俱乐部" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        [self createClub];
    }];
    
    SPAlertAction *action3 = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDestructive handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"点击了Cancel");
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3]; // 取消按钮一定排在最底部
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - 加入 | 创建俱乐部
- (void)joinClub {
    UIView *windowView = (UIView*)[UIApplication sharedApplication].delegate.window;
    
    AlertEntClubView *popupAlert =  [[AlertEntClubView alloc] initWithFrame:CGRectMake(55, 50, kSCREEN_WIDTH - 55*2, 230)];
    popupAlert.titleLabel.text = @"加入俱乐部";
    popupAlert.titLabel.text = @"俱乐部ID";
    popupAlert.textField.placeholder = @"请输入俱乐部ID";
    [popupAlert.submitBtn setTitle:@"申请加入" forState:UIControlStateNormal];
    _popupAlert = popupAlert;
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(popupAlert) weakView = popupAlert;
    [popupAlert observerSure:^{
        [weakView tf_hide];
    }];
    
    [popupAlert setSubmitBtnBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.popupAlert.textField.text.length == 0) {
            [MBProgressHUD showTipMessageInWindow:@"请输入俱乐部ID"];
            return;
        }
        [strongSelf requestData:YES];
        [weakView tf_hide];
    }];
    
    [popupAlert tf_showScale:windowView offset:CGPointZero popupParam:self.popupParam];
}


- (void)createClub {
    UIView *windowView = (UIView*)[UIApplication sharedApplication].delegate.window;
    
    AlertEntClubView *popupAlert =  [[AlertEntClubView alloc] initWithFrame:CGRectMake(55, 50, kSCREEN_WIDTH - 55*2, 230)];
    popupAlert.titleLabel.text = @"创建俱乐部";
    popupAlert.titLabel.text = @"俱乐部名称";
    popupAlert.textField.placeholder = @"请输入俱乐部名称";
    [popupAlert.submitBtn setTitle:@"确认创建" forState:UIControlStateNormal];
    _popupAlert = popupAlert;
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(popupAlert) weakView = popupAlert;
    [popupAlert observerSure:^{
        [weakView tf_hide];
    }];
    
    [popupAlert setSubmitBtnBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.popupAlert.textField.text.length == 0) {
            [MBProgressHUD showTipMessageInWindow:@"请输入俱乐部名称"];
            return;
        }
        [strongSelf requestData:NO];
        [weakView tf_hide];
    }];
    
    [popupAlert tf_showScale:windowView offset:CGPointZero popupParam:self.popupParam];
}



#pragma mark -  弹框
-(TFPopupParam *)popupParam{
    if (_popupParam == nil) {
        _popupParam = [TFPopupParam new];
    }
    return _popupParam;
}

- (void)requestData:(BOOL)isAdd {
    
    NSDictionary *parameters = nil;
    
    BADataEntity *entity = [BADataEntity new];
    if (isAdd) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/join"];  // 加入
        parameters = @{
                       @"club":self.popupAlert.textField.text
                       };
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/create"];  // 创建
        parameters = @{
                       @"name":self.popupAlert.textField.text
                       };
    }
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccessMessage:response[@"message"]];
            if (isAdd) {
                
            } else {
                ClubModel* model = [ClubModel mj_objectWithKeyValues:response[@"data"]];
                model.is_owner = YES;
                strongSelf.clubModel = model;
                [ClubManager sharedInstance].clubModel = model;
                
                [strongSelf getClubInfo];
            }
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


/**
 获取我 已加入的俱乐部
 */
- (void)getMyJoinClubData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/joined"];
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *modelArray = [ClubModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"clubs"]];
            ClubModel *clubModel = modelArray.firstObject;
            strongSelf.clubModel = clubModel;
            [ClubManager sharedInstance].clubModel = clubModel;
            if (!clubModel) {
                [strongSelf actionSheetArray:nil];
            } else {
                [strongSelf getClubInfo];
            }
        } else {
            [strongSelf actionSheetArray:nil];
//            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark -  获取 俱乐部信息
- (void)getClubInfo {
    
    NSDictionary *parameters = @{
                                 @"club":@([ClubManager sharedInstance].clubModel.club_id)
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"club/info"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            ClubInfo* model = [ClubInfo mj_objectWithKeyValues:response[@"data"]];
            [ClubManager sharedInstance].clubInfo = model;
            [strongSelf goto_Club];
            // 俱乐部公告
//            strongSelf.scorllTextLable.text = [ClubManager sharedInstance].clubInfo.notice;
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


#pragma mark -  俱乐部入口
- (void)goto_Club {
    //隐藏现在的tabbar和navi
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    ClubTabBarController *ccTab = [[ClubTabBarController alloc]init];
    [self.navigationController pushViewController:ccTab animated:YES];
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
@end
