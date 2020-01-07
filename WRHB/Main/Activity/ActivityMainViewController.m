//
//  ActivityMainViewController.m
//  WRHB
//
//  Created by AFan on 2019/3/29.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ActivityMainViewController.h"
#import "ActivityDetail1ViewController.h"
#import "ActivityDetail2ViewController.h"
#import "UIImageView+WebCache.h"
#import "ActivityModel.h"
#import "WKWebViewController.h"

@interface ActivityMainViewController ()<UITableViewDelegate,UITableViewDataSource>{
    /// // 暂停动画
    BOOL _pauseAni;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *aniObjArray;
@property (nonatomic, strong) NSArray<ActivityModel *> *dataArray;


@end

@implementation ActivityMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"活动奖励";
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = BaseColor;
    
    float rate = 357/1010.0;
    
    self.aniObjArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStylePlain];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 140;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-20);
    }];
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf getListData];
    }];
    
    [self getListData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(updateAni) userInfo:nil repeats:YES];
    
}

-(void)updateAni {
    if(_pauseAni) {
        return;
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (UIView *view in self.aniObjArray) {
        CGPoint point = [view.superview convertPoint:view.center toView:self.view];
        if(point.y < 0 || point.y > self.view.frame.size.height)
            continue;
        [newArray addObject:view];
    }
    if(newArray.count == 0) {
        return;
    }
    
    NSInteger random = arc4random()%newArray.count;
    if(random >= newArray.count) {
        random = newArray.count - 1;
    }
    
    UIView *view = newArray[random];
    if([view isKindOfClass:[UIImageView class]]){
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gaoGuang1"]];
        imgView.alpha = 0.9;
        [view addSubview:imgView];
        imgView.frame = CGRectMake(view.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        [UIView animateWithDuration:0.7 animations:^{
            imgView.frame = CGRectMake(-imgView.bounds.size.width, -10, imgView.image.size.width, view.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [imgView removeFromSuperview];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        [cell addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cell);
            make.top.equalTo(cell).offset(4);
            make.bottom.equalTo(cell).offset(-4);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [view addSubview:imgView];
        imgView.backgroundColor = COLOR_X(230, 230, 230);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(view);
            make.bottom.equalTo(cell).offset(-4);
        }];
        imgView.tag = 1;
        [self.aniObjArray addObject:imgView];
        
        //        UIView *dotView = [[UIView alloc] init];
        //        dotView.layer.masksToBounds = YES;
        //        dotView.layer.cornerRadius = 3;
        //        dotView.backgroundColor = COLOR_X(255, 80, 80);
        //        [view addSubview:dotView];
        //        [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(view).offset(10);
        //            make.bottom.equalTo(view.mas_bottom).offset(-20+3);
        //            make.width.height.equalTo(@6);
        //        }];
        //        UILabel *titleLabel = [[UILabel alloc] init];
        //        [view addSubview:titleLabel];
        //        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(dotView.mas_right).offset(10);
        //            make.bottom.equalTo(view);
        //            make.height.equalTo(@40);
        //        }];
        //        titleLabel.font = [UIFont systemFontOfSize2:15];
        //        titleLabel.textColor = COLOR_X(80, 80, 80);
        //        titleLabel.tag = 2;
    }
    ActivityModel *model = self.dataArray[indexPath.row];
    
    UIImageView *imgView = [cell viewWithTag:1];
    //    UILabel *titleLabel = [cell viewWithTag:2];
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    //    titleLabel.text = @"暂无数据";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ActivityModel *model = self.dataArray[indexPath.row];
    
    WKWebViewController *vc = [[WKWebViewController alloc] init];
    vc.isLoadWebTitle = NO;
    [vc loadWebURLSring:model.url];
    vc.navigationItem.title  = model.title;
//    vc.navigationItem.title = @"活动详情";
    vc.hidesBottomBarWhenPushed = YES;
    //[vc loadWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)getListData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"activity/lists"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        NSArray *activityModel = [ActivityModel mj_objectArrayWithKeyValuesArray:cacheJson];
        self.dataArray = activityModel;
        [self.tableView reloadData];
    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *activityModel = [ActivityModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = activityModel;
            [strongSelf.tableView reloadData];
            
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _pauseAni = NO;
    [MBProgressHUD hideHUD];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _pauseAni = YES;
}
@end
