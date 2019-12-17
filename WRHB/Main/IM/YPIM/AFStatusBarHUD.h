//
//  AFStatusBarHUD.h
//  Project
//
//  Created by AFan on 2019/5/26.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFStatusBarHUD : NSObject

+ (void)showMessage:(NSString *)msg image:(UIImage *)image;
+ (void)showMessage:(NSString *)msg;
+ (void)showSuccess:(NSString *)msg;
+ (void)showError:(NSString *)msg;
+ (void)showLoading:(NSString *)msg;
+ (void)hide;

@end
