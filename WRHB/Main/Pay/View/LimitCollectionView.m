//
//  LimitCollectionView.m
//  LotteryProduct
//
//  Created by pt c on 2019/7/19.
//  Copyright © 2019 vsskyblue. All rights reserved.
//

#import "LimitCollectionView.h"
#import "PayAmountCell.h"

static NSString * const kPriceCellId = @"PriceCell";
@interface LimitCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
//
@property (nonatomic, strong) NSMutableArray *resultDataArray;
@property (nonatomic, strong) NSIndexPath *selectItemIndexPath;


@end

@implementation LimitCollectionView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self initData];
        [self initSubviews];
        //        [self initLayout];
    }
    return self;
}


- (void)setModel:(id)model {
    self.selectItemIndexPath = nil;
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    [self.collectionView reloadData];
}



#pragma mark - collectionView
- (void)initSubviews {
    
    CGFloat spsp = 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidht = 75;
    CGFloat sep = (self.frame.size.width -spsp*2 - 3*itemWidht) / 2.0;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidht, 40);
    layout.minimumInteritemSpacing = sep;
    
    //    layout.minimumLineSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(5, spsp, 5, spsp);
    
    // 设置布局方向(滚动方向)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    
    /** mainCollectionView 的布局(必须实现的) */
    _collectionView.collectionViewLayout = layout;
    
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    //禁止滚动
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[PayAmountCell class] forCellWithReuseIdentifier:kPriceCellId];
    [self addSubview:self.collectionView];
}


#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.resultDataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PayAmountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPriceCellId forIndexPath:indexPath];
    CGFloat money = [[self.resultDataArray objectAtIndex:indexPath.row] floatValue];
    
    cell.pricelab.textColor = [UIColor colorWithHex:@"#FF4444"];
    cell.pricelab.text = [NSString stringWithFormat:@"%0.lf",money];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout  视图布局
#pragma mark --UICollectionViewDelegate 代理
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.selectItemIndexPath = indexPath;
    CGFloat money = [[self.resultDataArray objectAtIndex:indexPath.item] floatValue];
    NSDictionary *dict = @{@"money": @(money)};
    [self routerEventWithName:@"PayAmountCellSelected" user_info:dict];
    
}

/// 取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    if (self.selectNumCollectionViewBlock) {
    //        self.selectNumCollectionViewBlock();
    //    }
}


//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
