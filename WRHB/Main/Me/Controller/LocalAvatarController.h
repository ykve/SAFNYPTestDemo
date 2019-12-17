//
//  LocalAvatarController.h
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalAvatarController : UIViewController

@property (assign,readwrite,nonatomic)id target;
@property (assign,readwrite,nonatomic)SEL action;

@end

NS_ASSUME_NONNULL_END
