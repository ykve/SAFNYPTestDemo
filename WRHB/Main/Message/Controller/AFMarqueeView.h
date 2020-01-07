//
//  AFMarqueeView.h
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectNumBlock)(NSArray *items);

@class AFMarqueeModel;
@interface AFMarqueeView : UIView

-(void)setItems:(NSArray <AFMarqueeModel *>*)items;

-(void)addMarueeViewItemClickBlock:(void(^)(AFMarqueeModel *model))block;
@property (nonatomic, copy) void(^scrollEndBlock)(void);

-(void)stopAnimation;

-(void)startAnimation;
/// 停止定时器
-(void)stopTimer;

@end
