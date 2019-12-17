//
//  ReportFormsView.m
//  Project
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ReportFormsView.h"
#import "ReportCell.h"
#import "ReportHeaderView.h"
#import "SelectTimeView.h"
#import "CDAlertViewController.h"
#import "TeamReportModel.h"
#import "NSDate+DaboExtension.h"

@implementation ReportFormsItem

@end

@interface ReportFormsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)ReportHeaderView *headerView;

/// 
@property (nonatomic, strong) TeamReportModel *model;

@end

@implementation ReportFormsView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView {
    self.beginTime = dateString_date([NSDate date], CDDateDay);
    self.endTime = dateString_date([NSDate date], CDDateDay);
    self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
    self.tempEndTime = dateString_date([NSDate date], CDDateDay);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    NSInteger width = kSCREEN_WIDTH/2;
    layout.itemSize = CGSizeMake(width, width * 0.55);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:NSClassFromString(@"ReportCell") forCellWithReuseIdentifier:@"ReportCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    WEAK_OBJ(weakSelf, self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showActivityMessageInView:nil];
}


-(void)reloadDataView {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return CGSizeMake(self.frame.size.width, 38 + kSCREEN_WIDTH/2 * 0.55);
    else
        return CGSizeMake(self.frame.size.width, 38);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        reusableview.backgroundColor = [UIColor whiteColor];
        
        UIImageView *view = [[UIImageView alloc] init];
        view.tag = 96;
        view.backgroundColor = MBTNColor;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 2;
        [reusableview addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(4, 15));
            make.left.equalTo(reusableview).offset(12);
            make.bottom.equalTo(reusableview).offset(-7);
        }];
        UILabel *label = [reusableview viewWithTag:99];
        if(label == nil){
            label = [[UILabel alloc] init];
            label.textColor = HexColor(@"#48414f");
            label.font = [UIFont systemFontOfSize2:15];
            [reusableview addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(reusableview).offset(25);
                make.bottom.equalTo(reusableview);
                make.height.equalTo(@30);
            }];
            label.tag = 99;
        }
        UIView *lineView = [reusableview viewWithTag:100];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
            [reusableview addSubview:lineView];
            lineView.tag = 100;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0.5);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(reusableview);
            }];
        }
        lineView = [reusableview viewWithTag:98];
        if(lineView == nil){
            lineView = [[UIView alloc] init];
            lineView.backgroundColor = BaseColor;
            [reusableview addSubview:lineView];
            lineView.tag = 98;
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@8);
                make.width.equalTo(reusableview);
                make.bottom.equalTo(label.mas_top);
            }];
        }
        ReportHeaderView *pView = [reusableview viewWithTag:97];
        if(indexPath.section == 0){
            if(pView == nil){
                pView = [ReportHeaderView headView];
                self.headerView = pView;
                WEAK_OBJ(weakSelf, self);
                pView.beginChange = ^(id object) {
                    [weakSelf datePickerByType:0];
                };
                pView.endChange = ^(id object) {
                    [weakSelf datePickerByType:1];
                };
                pView.tag = 97;
                [reusableview addSubview:pView];
                NSInteger width = kSCREEN_WIDTH/2;
                [pView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.equalTo(reusableview);
                    make.height.equalTo(@(width * 0.55));
                }];
                [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(reusableview).offset(25);
                    make.bottom.equalTo(reusableview);
                    make.height.equalTo(@30);
                }];
            }
            pView.beginTime = self.beginTime;
            pView.endTime = self.endTime;
        }else {
            [pView removeFromSuperview];
        }
        NSDictionary *dic = self.dataArray[indexPath.section];
        label.text = dic[@"categoryName"];
    }
    return reusableview;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    NSArray *list = dic[@"list"];
    return list.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ReportCell";
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *list = dic[@"list"];
    ReportFormsItem *item = list[indexPath.row];
    ReportCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UIView *lineView0 = [cell.contentView viewWithTag:210];
    UIView *lineView1 = [cell.contentView viewWithTag:211];
    UIView *lineView2 = [cell.contentView viewWithTag:212];
    
    
    if(indexPath.row < 2 && lineView0 == nil){
        lineView0 = [[UIView alloc] init];
        lineView0.backgroundColor = [UIColor colorWithHex:@"#FFE6E6"];
        [cell.contentView addSubview:lineView0];
        lineView0.tag = 212;
        [lineView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.7);
            make.width.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView).offset(0.5);
        }];
    }
    
    if(lineView1 == nil){
        lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = [UIColor colorWithHex:@"#FFE6E6"];
        [cell.contentView addSubview:lineView1];
        lineView1.tag = 211;
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0.7);
            make.height.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
        }];
    }
    if(lineView2 == nil){
        lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = [UIColor colorWithHex:@"#FFE6E6"];
        [cell.contentView addSubview:lineView2];
        lineView2.tag = 212;
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.7);
            make.width.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView).offset(-0.5);
        }];
    }
    cell.titleLabel.text = item.title;
    cell.moneyLabel.text = item.desc;
    cell.desLabel.text = item.desc2;
    return cell;
}


-(void)showTimeSelectView{
    SelectTimeView *timeView = [SelectTimeView sharedInstance];
    WEAK_OBJ(weakSelf, self);
    timeView.selectBlock = ^(id object) {
        TimeRange range = (TimeRange)[object integerValue];
        [weakSelf selectTime:range];
    };
    [self addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


-(void)selectTime:(TimeRange)range{
    if(range == TimeRange_today){
        self.tempBeginTime = dateString_date([NSDate date], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"今天" forState:UIControlStateNormal];
    }else if(range == TimeRange_yesterday){
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:-24 * 3600], CDDateDay);
        [self.rightBtn setTitle:@"昨天" forState:UIControlStateNormal];
    }else if(range == TimeRange_thisWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"本周" forState:UIControlStateNormal];
    }else if(range == TimeRange_lastWeek){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday  fromDate:nowDate];
        // 获取今天是周几
        NSInteger weekDay = [comp weekday];
        weekDay -= 1;
        if(weekDay < 1)
            weekDay = 7;
        self.tempBeginTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow:- ((weekDay - 1 + 7) * 24 * 3600)], CDDateDay);
        self.tempEndTime = dateString_date([[NSDate alloc] initWithTimeIntervalSinceNow: ((7 - weekDay - 7) * 24 * 3600)], CDDateDay);
        [self.rightBtn setTitle:@"上周" forState:UIControlStateNormal];
    }else if(range == TimeRange_thisMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStrb], CDDateDay);
        
        //        month += 1;
        //        if(month > 12){
        //            month = 1;
        //            year += 1;
        //        }
        //        NSString *timeStre = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        //        NSDate *dd = [[formatter dateFromString:timeStre] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date([NSDate date], CDDateDay);
        [self.rightBtn setTitle:@"本月" forState:UIControlStateNormal];
    }else if(range == TimeRange_lastMonth){
        NSDate *nowDate = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:nowDate];
        NSInteger year = [comp year];
        NSInteger month = [comp month];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : @"yyyy-MM-dd hh:mm:ss"];
        
        NSString *timeStrb = [NSString stringWithFormat:@"%ld-%02ld-01 00:00:00",(long)year,(long)month];
        NSDate *dd = [[formatter dateFromString:timeStrb] dateByAddingTimeInterval:-24 * 3600];
        self.tempEndTime = dateString_date(dd, CDDateDay);
        
        month -= 1;
        if(month < 1){
            month = 12;
            year -= 1;
        }
        NSString *timeStre = [NSString stringWithFormat:@"%ld-%2ld-01 00:00:00",(long)year,(long)month];
        self.tempBeginTime = dateString_date([formatter dateFromString:timeStre], CDDateDay);
        [self.rightBtn setTitle:@"上月" forState:UIControlStateNormal];
    }
    
    [MBProgressHUD showActivityMessageInView:nil];
    [self getData];
}

- (void)datePickerByType:(NSInteger)type{
    __weak typeof(self) weakSelf = self;
    [CDAlertViewController showDatePikerDate:^(NSString *date) {
        [weakSelf updateType:type date:date];
    }];
}

- (void)updateType:(NSInteger)type date:(NSString *)date{
    if (type == 0) {
        if([self.beginTime isEqualToString:date])
            return;
        self.beginTime = date;
        self.tempBeginTime = self.beginTime;
        self.headerView.beginTime = self.beginTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }else{
        if([self.endTime isEqualToString:date])
            return;
        self.endTime = date;
        self.tempEndTime = self.endTime;
        self.headerView.endTime = self.endTime;
        [self.rightBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    if([self.beginTime compare:self.endTime] != NSOrderedDescending){
        [MBProgressHUD showActivityMessageInView:nil];
        [self getData];
    } 
}


-(void)requestDataBack {
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"APP活跃度" forKey:@"categoryName"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    ReportFormsItem *item = [[ReportFormsItem alloc] init];
    item.title = @"新注册人数";
    item.desc = [NSString stringWithFormat:@"%ld", self.model.new_register];
    [arr addObject:item];
    
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"总注册人数";
    item.desc = [NSString stringWithFormat:@"%ld", self.model.registerNum];
    [arr addObject:item];
    
    NSString *s1 = self.model.first_money;
    NSString *s2 =  [NSString stringWithFormat:@"%ld", self.model.first_num];
    item = [[ReportFormsItem alloc] init];
    item.title = @"首充金额/笔数";
    item.desc = [NSString stringWithFormat:@"%@/%@",s1,s2];
    [arr addObject:item];
    
    s1 = self.model.second_money;
    s2 =  [NSString stringWithFormat:@"%ld", self.model.second_num];
    item = [[ReportFormsItem alloc] init];
    item.title = @"二充金额/笔数";
    item.desc = [NSString stringWithFormat:@"%@/%@",s1,s2];
    [arr addObject:item];
    
//    if([self isSelf]){
        categoryDic = [[NSMutableDictionary alloc] init];
        [self.dataArray addObject:categoryDic];
        
        [categoryDic setObject:@"充值与提现" forKey:@"categoryName"];
        arr = [[NSMutableArray alloc] init];
        [categoryDic setObject:arr forKey:@"list"];
        
        item = [[ReportFormsItem alloc] init];
        item.title = @"充值总额";
        item.desc = self.model.recharge;
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.title = @"提现总额";
        item.desc = self.model.withdraw;
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.title = @"起始余额";
        item.desc = self.model.start_money;
        [arr addObject:item];
        
        item = [[ReportFormsItem alloc] init];
        item.title = @"截至余额";
        item.desc = self.model.end_money;
        [arr addObject:item];
//    }
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"发包与抢包" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    NSString *sb1 = self.model.send;
    NSString *sb2 =  [NSString stringWithFormat:@"%ld", self.model.send_num];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"发包金额/个数";
    item.desc = [NSString stringWithFormat:@"%@/%@",sb1,sb2];
    [arr addObject:item];
    
    NSString *gr1 = self.model.grab;
    NSString *gr2 =  [NSString stringWithFormat:@"%ld", self.model.grab_num];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"抢包金额/个数";
    item.desc = [NSString stringWithFormat:@"%@/%@",gr1,gr2];
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"发包人数";
    item.desc = [NSString stringWithFormat:@"%ld", self.model.send_count];
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"抢包人数";
    item.desc = [NSString stringWithFormat:@"%ld", self.model.grab_count];
    [arr addObject:item];
    
    categoryDic = [[NSMutableDictionary alloc] init];
    [self.dataArray addObject:categoryDic];
    
    [categoryDic setObject:@"奖金与佣金" forKey:@"categoryName"];
    arr = [[NSMutableArray alloc] init];
    [categoryDic setObject:arr forKey:@"list"];
    
    item = [[ReportFormsItem alloc] init];
    item.title =  @"流水佣金分成";
    item.desc = self.model.agent_fy;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"敬请期待";
    item.desc = @"";
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"首充用户奖金";
    item.desc = self.model.first_reward;
    [arr addObject:item];
    
    item = [[ReportFormsItem alloc] init];
    item.title = @"二充用户奖金";
    item.desc = self.model.first_reward;
    [arr addObject:item];
}
@end
