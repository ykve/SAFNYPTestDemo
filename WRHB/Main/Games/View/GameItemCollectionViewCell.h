//
//  GameItemCollectionViewCell.h
//  WRHB
//
//  Created by AFan on 2019/11/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLAnimatedImageView;

NS_ASSUME_NONNULL_BEGIN

@interface GameItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FLAnimatedImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end 

NS_ASSUME_NONNULL_END
