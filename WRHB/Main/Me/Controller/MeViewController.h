//
//  MeViewController.h
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,STControllerType) {
    STControllerTypeNormal,
    STControllerTypeHybrid,
    STControllerTypeDisableBarScroll,
    STControllerTypeHiddenNavBar,
};


NS_ASSUME_NONNULL_BEGIN

@interface MeViewController : UIViewController

@property (nonatomic, assign) STControllerType type;
@property (nonatomic, strong) UIImageView * headerImageView;

@end

NS_ASSUME_NONNULL_END
