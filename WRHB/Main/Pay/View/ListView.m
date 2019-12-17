//
//  ListView.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ListView.h"
#import "ListViewCell.h"
#import "BankModel.h"

@interface ListView ()

@end

@implementation ListView

-(void)dealloc{
    NSLog(@"已释放====:%@",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    self.tableView.tableHeaderView = self.headView;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    _tableView.rowHeight = 50;   // 行高
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    
    
    [self headView];
}

- (void)headView {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
//    backView.backgroundColor = [UIColor greenColor];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"nav_bg"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(backView);
    }];
    
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backImageView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.left.equalTo(backImageView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"选择到账银行卡";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.centerX.equalTo(backImageView.mas_centerX);
    }];
    
    
    UIButton *okBtn = [[UIButton alloc] init];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtn:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backImageView addSubview:okBtn];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backImageView.mas_centerY);
        make.right.equalTo(backImageView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    self.tableView.tableHeaderView = backView;
}

- (void)cancelBtn:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
- (void)okBtn:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    self.tableView.scrollEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self reload:@[@"我只是一个普通的列表",
                   @"我可以随便弹出来",
                   @"下拉列表框",
                   @"或者是气泡",
                   @"可以是直接弹出来",
                   @"或者滑动",
                   @"或者是你想要的任何方式",
                   @"我只是一个普通的列表",
                   @"我可以随便弹出来",
                   @"下拉列表框",
                   @"或者是气泡",
                   @"可以是直接弹出来",
                   @"或者滑动",
                   @"或者是你想要的任何方式"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
}

-(void)reload:(NSArray <NSString *>*)data{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

-(void)observerSelected:(ClubSelectBlock)block{
    self.selectBlock = block;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ListViewCell";
    
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [ListViewCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    BankModel *model = (BankModel *)[self.dataSource objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock([self.dataSource objectAtIndex:indexPath.row]);
    }
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

@end
