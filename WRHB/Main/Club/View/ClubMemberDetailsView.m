//
//  ClubMemberDetailsView.m
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberDetailsView.h"
#import "ClubMemberDetailsCollectionCell.h"

static NSString * const kClubMemberDetailsCollectionCellId = @"ClubMemberDetailsCollectionCell";

// 需要实现三个协议 UICollectionViewDelegateFlowLayout 继承自 UICollectionViewDelegate
@interface ClubMemberDetailsView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation ClubMemberDetailsView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}


- (void)setModel:(id)model {
    self.dataArray = (NSArray *)model;
    [self.collectionView reloadData];
}

#pragma mark - 首先创建一个collectionView
- (void)initSubviews {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 15*2 - 5*3) / 4 -1;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, 60);
    
    // 设置列间距
    layout.minimumInteritemSpacing = 5;
    
    // 设置行间距
    layout.minimumLineSpacing = 5;
    
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
  
    // 设置布局方向(滚动方向)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
    CGFloat height = self.frame.size.height;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, height) collectionViewLayout:layout];
    
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
    
    [_collectionView registerClass:[ClubMemberDetailsCollectionCell class] forCellWithReuseIdentifier:kClubMemberDetailsCollectionCellId];
    [self addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容  MeACollectionViewCell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClubMemberDetailsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClubMemberDetailsCollectionCellId forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[@"Text"];
    cell.titleLabel.text = dict[@"title"];
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout  视图布局

#pragma mark --UICollectionViewDelegate 代理

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.selectABlock) {
//        self.selectABlock(self.dataArray[indexPath.row]);
//    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end


