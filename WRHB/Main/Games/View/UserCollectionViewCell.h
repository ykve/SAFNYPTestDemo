//
//  UserCollectionViewCell.h
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseUserModel;

@interface UserCollectionViewCell : UICollectionViewCell

- (void)addOrDeleteIndex:(NSInteger)index;

- (void)update:(BaseUserModel *)model;
@end
