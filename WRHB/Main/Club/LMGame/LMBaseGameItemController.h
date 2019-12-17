//
//  LMBaseGameItemController.h
//  WRHB
//
//  Created by AFan on 2019/12/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClubModel;

NS_ASSUME_NONNULL_BEGIN

@interface LMBaseGameItemController : UIViewController
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
/// 俱乐部
@property (nonatomic, strong) ClubModel *clubModel;
@end

NS_ASSUME_NONNULL_END
