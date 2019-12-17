//
//  PayTopUpController.h
//  WRHB
//
//  Created by AFan on 2019/11/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayTopUpController : UIViewController <JXCategoryListContentViewDelegate>

/// 
@property (nonatomic, assign) NSInteger controllerIndex;
/// 是否隐藏TabBar  默认显示
@property (nonatomic, assign) BOOL isHidTabBar;

@end

NS_ASSUME_NONNULL_END
