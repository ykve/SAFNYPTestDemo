//
//  CustomCollectionView.m
//  SwipeTableView
//
//  Created by Roy lee on 16/4/1.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "CustomCollectionView.h"
#import "UIView+STFrame.h"
//#import "STRefresh.h"
#import "MeCollectionViewCell.h"
#import "BillTypeModel.h"

#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CustomCollectionView ()<STCollectionViewDataSource,STCollectionViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *dataArray;
@property (nonatomic, assign) BOOL isWaterFlow;

@end
@implementation CustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)_layout {
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    STCollectionViewFlowLayout * layout = self.st_collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 5);
    self.stDelegate = self;
    self.stDataSource = self;
    [self registerClass:MeCollectionViewCell.class forCellWithReuseIdentifier:@"MeCollectionViewCell"];
    
//    self.header = [STRefreshHeader headerWithRefreshingBlock:^(STRefreshHeader *header) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [header endRefreshing];
//        });
//    }];
}

- (void)refreshWithData:(NSArray *)data atIndex:(NSInteger)index {
    self.dataArray = [data copy];
//    NSLog(@"data === %ld   index === %ld   isWaterFlow === %d",[dataDict integerValue],index,_isWaterFlow);
    
    [self reloadData];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

#pragma mark - STCollectionView M

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(STCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(0, 90);
}


// 返回 section 个数
- (NSInteger)numberOfSectionsInStCollectionView:(UICollectionView *)collectionView {
    return 1;
} 

// 返回对应 section 的 item 个数
- (NSInteger)stCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 返回对应 item 的 UIConllectionviewCell
- (UICollectionViewCell *)stCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeCollectionViewCell" forIndexPath:indexPath];
    BillTypeModel *model = (BillTypeModel *)self.dataArray[indexPath.row];
    cell.headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"me_b_redp_%zd", model.category]];
    cell.titleLabel.text = model.title;
//    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlock) {
        self.selectBlock(self.dataArray[indexPath.row]);
    }
}



@end
