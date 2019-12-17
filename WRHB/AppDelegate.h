//
//  AppDelegate.h
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN UIColor *MainNavBarColor;
FOUNDATION_EXTERN UIColor *MainViewColor;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)shareInstance;

/**
 设置根控制器
 */
-(void)setRootViewController;
/**
 退出登录
 */
- (void)logOut;

@end

