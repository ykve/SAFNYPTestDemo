//
//  TwoBaseGameGroupItemController.h
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoBaseGameItemController : UIViewController
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger topImgSelectedIndex;
/// 是否加载数据
@property (nonatomic, assign) BOOL isDataLoaded;

@end

NS_ASSUME_NONNULL_END
