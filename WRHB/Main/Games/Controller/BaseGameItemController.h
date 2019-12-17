//
//  BaseViewController.h
//  SPPageMenu
//
//  Created by 乐升平 on 17/10/26.
//  Copyright © 2017年 iDress. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseGameItemController : UIViewController

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger index;

@end
