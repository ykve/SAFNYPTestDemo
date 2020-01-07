//
//  LoginForgetPasswordController.h
//  WRHB
//
//  Created by AFan on 2019/10/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginForgetPsdController : UIViewController

/// 0 默认 找回密码    1  设置登录密码   2 交易密码
@property (nonatomic, assign) NSInteger updateType;

@end

NS_ASSUME_NONNULL_END
