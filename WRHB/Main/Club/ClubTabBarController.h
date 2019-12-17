//
//  ClubTabBarController.h
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMTabBar.h"
#import "ZMNavController.h"

@class ClubModel;

NS_ASSUME_NONNULL_BEGIN

@interface ClubTabBarController : UITabBarController

@property (nonatomic, assign) NSInteger upperIndex; //突出项的索引
@property (nonatomic, strong) ZMTabBar *zmTabBar;

@end

NS_ASSUME_NONNULL_END
