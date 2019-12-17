//
//  GameItemSelectedCollViewCell.h
//  WRHB
//
//  Created by AFan on 2019/11/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJScrollTextLable.h"


NS_ASSUME_NONNULL_BEGIN

@interface GameItemSelectedCollViewCell : UICollectionViewCell

/// <#strong注释#>
@property (nonatomic, strong) UILabel *titleLabel;
/// strong注释
@property (nonatomic, strong) UILabel *contentLabel;
/// strong注释
//@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) JJScorllTextLable *scorllTextLable;


@end

NS_ASSUME_NONNULL_END
