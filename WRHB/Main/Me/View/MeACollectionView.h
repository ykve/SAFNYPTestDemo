//
//  MeACollectionView.h
//  WRHB
//
//  Created by AFan on 2019/11/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SelectABlock)(NSDictionary *dict);

NS_ASSUME_NONNULL_BEGIN

@interface MeACollectionView : UIView

/// <#strong注释#>
@property (nonatomic, strong) id model;

@property (nonatomic ,copy) SelectABlock selectABlock;

@end

NS_ASSUME_NONNULL_END
