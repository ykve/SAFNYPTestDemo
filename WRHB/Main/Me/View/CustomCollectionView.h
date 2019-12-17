//
//  CustomCollectionView.h
//  SwipeTableView
//
//  Created by Roy lee on 16/4/1.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollectionView.h"

@class BillTypeModel;


#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

typedef void(^SelectBlock)(BillTypeModel *model);


@interface CustomCollectionView : STCollectionView

- (void)refreshWithData:(NSArray *)data atIndex:(NSInteger)index;
@property (nonatomic ,copy) SelectBlock selectBlock;

@end
