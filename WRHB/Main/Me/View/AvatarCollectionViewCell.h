//
//  AvatarCollectionViewCell.h
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarCollectionViewCell : UICollectionViewCell
///
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *selectedImageView;

//@property(nonatomic,copy)void(^saveBlock)(void);

@end

NS_ASSUME_NONNULL_END
