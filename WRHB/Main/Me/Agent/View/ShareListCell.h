//
//  ShareListCell.h
//  WRHB
//
//  Created AFan on 2019/9/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareListCell : UICollectionViewCell
@property (nonatomic, strong) UIView *conView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pageViewLabel;
@property (nonatomic, strong) UIImageView *iconView;
/// 
@property (nonatomic, strong) NSMutableArray *starArray;

@end

NS_ASSUME_NONNULL_END
