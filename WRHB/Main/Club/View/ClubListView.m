//
//  ListView.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ClubListView.h"

@implementation ClubListView

-(void)dealloc{
    NSLog(@"已释放====:%@",NSStringFromClass([self class]));
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (void)initView {
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
}



#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
//        _tableView.rowHeight = 44;   // 行高
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
         _tableView.scrollEnabled = YES;
    }
    return _tableView;
}


-(void)reload:(NSArray <NSString *>*)data{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

-(void)observerSelected:(SelectBlock)block{
    self.block = block;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if (self.textColor) {
        cell.textLabel.textColor = self.textColor;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:self.fontSize ? self.fontSize : 15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight ? self.cellHeight : 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block([self.dataSource objectAtIndex:indexPath.row]);
    }
}


@end
