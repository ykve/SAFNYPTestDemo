//
//  PayYSTopupController.h
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryListContainerView.h"


NS_ASSUME_NONNULL_BEGIN

@interface PayYSTopupController : UIViewController  <JXCategoryListContentViewDelegate>
/// 是否隐藏TabBar  默认显示
@property (nonatomic, assign) BOOL isHidTabBar;
@end

NS_ASSUME_NONNULL_END

