//
//  CopyViewController.m
//  ProjectXZHB
//
//  Created by fangyuan on 2019/4/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PopCopyViewController.h"
#import "CopyCell.h"
#import "PopCopyModel.h"

@interface PopCopyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PopCopyViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"推广文案";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 80;
    [self.view addSubview:tableView];
    _tableView = tableView;
    
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
    
    
    WEAK_OBJ(weakSelf, self);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    
   
    
    [self headView];
}





- (void)getData {
    NSArray *arr = @[@(6)];
    NSDictionary *parameters = @{
                                 @"type":arr
                                 };
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"app/copywriting"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
           [strongSelf getDataBack:response[@"data"]];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

-(void)getDataBack:(NSArray *)array {
    
     NSArray *modelArray = [PopCopyModel mj_objectArrayWithKeyValuesArray:array];
     self.dataArray = [modelArray copy];
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    CopyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CopyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell initView];
    }
    PopCopyModel *model = self.dataArray[indexPath.row];
    [cell setIndex:indexPath.row + 1];
    
    NSString *s = model.desc;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:s];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [s length])];
    [cell.tLabel setAttributedText:attributedString1];
    
    //cell.tLabel.text = dict[@"content"];
    return cell;
}

-(void)headView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 175)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"pop_top_bg"];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    self.tableView.tableHeaderView = view;
}
@end
