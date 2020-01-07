//
//  MyReportFormsView.m
//  WRHB
//
//  Created by AFan on 2019/4/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MyDesReportTableView.h"
#import "ReportCell.h"
#import "Sub_Users.h"

@interface MyDesReportTableView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
///
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MyDesReportTableView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    NSDictionary *dic = self.dataArray.firstObject;
    NSString *title = dic[@"categoryName"];
    self.titleLabel.text = title;
    
    [self.collectionView reloadData];
}

- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
//    bgImgView.image = [UIImage imageNamed:@"sub_des_bg"];
    [backView addSubview:bgImgView];
    _bgImgView = bgImgView;
    
    UIImage *image = [UIImage imageNamed:@"sub_des_bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(50, 10, 20, 20) resizingMode:UIImageResizingModeStretch];
    bgImgView.image = image;

    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(backView);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.textColor = [UIColor colorWithHex:@"#FF4444"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgImgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_top).offset(5);
        make.centerX.equalTo(bgImgView.mas_centerX).offset(-2);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 16;
    layout.minimumInteritemSpacing = 0;
    
    
    NSInteger width = 133;
    layout.itemSize = CGSizeMake(width, 110);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:bgImgView.bounds collectionViewLayout:layout];
    [bgImgView addSubview:_collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(60, 20, 20, 25);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:NSClassFromString(@"ReportCell") forCellWithReuseIdentifier:@"ReportCell"];
    WEAK_OBJ(weakSelf, self);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgImgView);
    }];
}


-(void)getDataBack:(NSDictionary *)dict{
    [self.dataArray removeAllObjects];
    
   
}


-(void)reloadData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView reloadData];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
////    if(section == 0)
////        return CGSizeMake(self.frame.size.width, 38 + kSCREEN_WIDTH/2 * 0.55);
////    else
//        return CGSizeMake(self.frame.size.width, 38);
//}


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
    cell.model = item;
    return cell;
}

@end
