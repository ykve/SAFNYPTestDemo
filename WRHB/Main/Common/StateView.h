//
//  StateView.h
//  WRHB
//
//  Created by AFan on 2019/11/27.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CDStateHandleBlock)(void);

@interface StateView : UIView

+ (instancetype)StateViewWithHandle:(CDStateHandleBlock)handle;

- (void)hidState;
- (void)showNetError;
- (void)showEmpty;

@end
