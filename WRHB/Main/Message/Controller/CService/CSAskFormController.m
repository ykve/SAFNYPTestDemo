//
//  CSAskFormController.m
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CSAskFormController.h"
#import "CSAskFormCell.h"
#import "ChatsModel.h"
#import "CServiceChatController.h"
#import "CSAskFormModel.h"

@interface CSAskFormController ()<UITableViewDataSource, UITableViewDelegate>
/// 表单
@property (nonatomic, strong) UITableView *tableView;
/// 数据源
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CSAskFormController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    self.navigationItem.title = @"询前表单";
    
    [self getDataList];
    
    [self.view addSubview:self.tableView];
    [self setHeaderTableView];
    
    [self.tableView registerClass:[CSAskFormCell class] forCellReuseIdentifier:kCSAskFormCellIdentifier];
}

#pragma mark - 获取数据
- (void)getDataList {
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/askReply"];
    entity.needCache = NO;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSArray *array = [CSAskFormModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
            strongSelf.dataArray = [array copy];
            [strongSelf.tableView reloadData];
        } else {
           [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}









#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CSAskFormCell *cell = [tableView dequeueReusableCellWithIdentifier:kCSAskFormCellIdentifier];
    if(cell == nil) {
        cell = [CSAskFormCell cellWithTableView:tableView reusableId:kCSAskFormCellIdentifier];
    }
    CSAskFormModel *model = self.dataArray[indexPath.row];
    cell.indexLabel.text = [NSString stringWithFormat:@"%zd.",indexPath.row+1];
    cell.titleLabel.text = model.title;
    return cell;
}
#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CSAskFormModel *model = self.dataArray[indexPath.row];
    [self createServiceSession:model];
    
}


#pragma mark -  客服会话创建
/**
 客服会话创建
 */
- (void)createServiceSession:(CSAskFormModel *)model {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/createServiceSession"];
    entity.needCache = NO;
    //    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.sessionId = [response[@"data"][@"session"] integerValue];
//            strongSelf.chatsModel.sessionId = kCustomerServiceID;
            
            strongSelf.chatsModel.sessionId = [response[@"data"][@"session"] integerValue];;
            strongSelf.chatsModel.name = response[@"data"][@"title"];
            strongSelf.chatsModel.avatar = response[@"data"][@"avatar"];
            strongSelf.chatsModel.sessionType = ChatSessionType_CustomerService;
            
            [strongSelf goto_CServiceChat:model];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

- (void)goto_CServiceChat:(CSAskFormModel *)askModel {
    CServiceChatController *vc = [CServiceChatController chatsFromModel:self.chatsModel];
    vc.askModel = askModel;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT- Height_NavBar -kiPhoneX_Bottom_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            // 这句代码会影响 UICollectionView 嵌套使用
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        //        _tableView.rowHeight = 44;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (void)setHeaderTableView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 130)];
    headView.backgroundColor = [UIColor greenColor];
    
    UIView *topBackView = [[UIView alloc] init];
    topBackView.backgroundColor = [UIColor colorWithHex:@"#FA7B7B"];
    [headView addSubview:topBackView];
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(headView);
        make.height.mas_equalTo(75);
    }];
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"询前表单";
    titLabel.font = [UIFont systemFontOfSize:18];
    titLabel.textColor = [UIColor whiteColor];
    [topBackView addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView.mas_top).offset(16);
        make.left.equalTo(topBackView.mas_left).offset(26);
    }];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"全球客服团队，竭诚为您提供24小时优质服务!";
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor whiteColor];
    [topBackView addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topBackView.mas_bottom).offset(-16);
        make.left.equalTo(titLabel.mas_left);
    }];
    
    UIView *linegView = [[UIView alloc] init];
    linegView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    [headView addSubview:linegView];
    
    [linegView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBackView.mas_bottom);
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(10);
    }];
    
    UIView *titBgView = [[UIView alloc] init];
    titBgView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:titBgView];
    
    [titBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(linegView.mas_bottom);
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(45);
    }];
    
    UIImageView *icoView = [[UIImageView alloc] init];
    icoView.image = [UIImage imageNamed:@"mes_cs_ask"];
    [titBgView addSubview:icoView];
    
    [icoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titBgView.mas_centerY);
        make.left.equalTo(titBgView.mas_left).offset(20);
        make.size.mas_equalTo(24);
    }];
    
    UILabel *icTitLabel = [[UILabel alloc] init];
    icTitLabel.text = @"猜你想问";
    icTitLabel.font = [UIFont boldSystemFontOfSize:16];
    icTitLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [titBgView addSubview:icTitLabel];
    
    [icTitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titBgView.mas_centerY);
        make.left.equalTo(icoView.mas_right).offset(8);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [titBgView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titBgView.mas_bottom);
        make.left.equalTo(titBgView.mas_left).offset(20);
        make.right.equalTo(titBgView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.tableView.tableHeaderView = headView;
}

@end
