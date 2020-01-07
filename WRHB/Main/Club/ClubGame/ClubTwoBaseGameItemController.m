//
//  TwoBaseGameGroupItemController.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubTwoBaseGameItemController.h"
#import "GamesTypeModel.h"
#import "ChatsModel.h"
#import "GameTypeController.h"
#import "GameItemSelectedCollViewCell.h"

#import "ChatViewController.h"
#import "SessionSingle.h"

static NSString * const kGameItemCollectionViewCellId = @"kGameItemCollectionViewCell";
static NSString * const kGameItemSelectedCollViewCellId = @"kGameItemSelectedCollViewCell";


@interface ClubTwoBaseGameItemController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

/// 退群使用
@property (nonatomic, strong) GamesTypeModel *gamesTypeModel;
///
@property (nonatomic, strong) ChatsModel *chatsModel;

@end

@implementation ClubTwoBaseGameItemController


- (void)dealloc {
    NSLog(@"1");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    
    [self setFootView];
    [self gamesChatsClear];
}

- (void)setTopImgSelectedIndex:(NSInteger)topImgSelectedIndex {
    _topImgSelectedIndex = topImgSelectedIndex;
    [self.collectionView reloadData];
}


- (void)setFootView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 300)];
//        backView.backgroundColor = [UIColor greenColor];
    backView.hidden = NO;
    [self.view addSubview:backView];
    self.backImgView = backView;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"bill_nodata_bg"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(188.5, 172.5));
    }];
}


#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GamesTypeModel *model = self.dataArray[self.topImgSelectedIndex];
    if (model.items.count > 0) {
        self.backImgView.hidden = YES;
    } else {
       self.backImgView.hidden = NO;
    }
    return model.items.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GameItemSelectedCollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGameItemSelectedCollViewCellId forIndexPath:indexPath];
    
    GamesTypeModel *model = self.dataArray[self.topImgSelectedIndex];
    if ([model.items[indexPath.row] isKindOfClass:[ChatsModel class]]) {
        ChatsModel *cmodel = model.items[indexPath.row];
        cell.titleLabel.text = model.title;
        if (cmodel.play_type == RedPacketType_CowCowDouble || cmodel.play_type == RedPacketType_CowCowNoDouble) {
            cell.imgType.image = cmodel.play_type == RedPacketType_CowCowDouble?[UIImage imageNamed:@"club_doubleNiuNiu"]:[UIImage imageNamed:@"club_singleNiuNiu"];
        }else{
            cell.imgType.image = nil;
        }
        
        cell.contentLabel.text = [cmodel.number_limit stringByReplacingOccurrencesOfString:@"," withString:@"-"];   //替换字符串
        cell.scorllTextLable.text = cmodel.name;
    }
    
    return cell;
    
}


#pragma mark --UICollectionViewDelegateFlowLayout  视图布局

#pragma mark --UICollectionViewDelegate 代理
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GamesTypeModel *model = self.dataArray[self.topImgSelectedIndex];
    ChatsModel *cmodel = model.items[indexPath.row];
    
    self.gamesTypeModel = model;
    self.chatsModel = cmodel;
    
    [self joinGroup:cmodel gamesTypeModel:model password:nil];
}


#pragma mark -   加入游戏群组
/**
 加入群组
 */
- (void)joinGroup:(ChatsModel *)chatModel
   gamesTypeModel:(GamesTypeModel *)gamesTypeModel
         password:(NSString *)password {
    
    NSDictionary *parameters = @{
                                 @"session":@(chatModel.sessionId)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/join/sessions"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [SessionSingle sharedInstance].myJoinGameGroupSessionId = chatModel.sessionId;
            [strongSelf goto_groupChat:chatModel gamesTypeModel:gamesTypeModel];
        } else if ([[response objectForKey:@"status"] integerValue] == 2) {
            // 退群
            [self exitGroupRequest:[response[@"data"][@"session"] integerValue]];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response[@"mesage"]];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)goto_groupChat:(ChatsModel *)model gamesTypeModel:(GamesTypeModel *)gamesTypeModel {
    
    
    NSDictionary *dict = @{@"model": model,
                           @"gamesTypeModel": gamesTypeModel,
                           };
    [self routerEventWithName:@"ClubTwoBaseGameItemControllerGoToChat" user_info:dict];
    
}

#pragma mark -  退出群组请求  退群
/**
 退出群组请求  退群
 */
- (void)exitGroupRequest:(NSInteger)sessionId {
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/leaveSession"];
    NSDictionary *parameters = @{
                                 @"session":@(sessionId)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [SessionSingle sharedInstance].myJoinGameGroupSessionId = 0;
            [strongSelf joinGroup:strongSelf.chatsModel gamesTypeModel:self.gamesTypeModel password:nil];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)gamesChatsClear {
    [[SessionSingle sharedInstance] gamesChatsClearSuccessBlock:^(NSDictionary *success) {
        NSLog(@"1");
    } failureBlock:^(NSError *error) {
        NSLog(@"1");
    }];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    CGFloat height = height = kSCREEN_HEIGHT-Height_NavBar-kGameTopHeight;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, 187);
    
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
    
    [_collectionView registerClass:[GameItemSelectedCollViewCell class] forCellWithReuseIdentifier:kGameItemSelectedCollViewCellId];
    
    [self.view addSubview:self.collectionView];
}
@end

