//
//  BaseViewController.h
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClubModel;

@interface ClubBaseGameItemController : UIViewController

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;
/// 俱乐部
@property (nonatomic, strong) ClubModel *clubModel;


@end
