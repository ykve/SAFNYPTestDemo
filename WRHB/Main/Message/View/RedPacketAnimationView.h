//
//  EnvelopAnimationView.h
//  Project
//
//  Created by AFan on 2019/11/13.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnimationBlock)(void);
typedef void (^DetailBlock)(void);
typedef void (^OpenBtnBlock)(void);
typedef void (^AnimationEndBlock)(void);
typedef void (^DisMissRedBlock)(void);


@class RedPacketDetModel;

@interface RedPacketAnimationView : UIView



- (void)showInView:(UIView *)view;
@property (nonatomic ,copy) AnimationBlock animationBlock;
@property (nonatomic ,copy) DetailBlock detailBlock;
@property (nonatomic ,copy) OpenBtnBlock openBtnBlock;
@property (nonatomic ,copy) AnimationEndBlock animationEndBlock;
@property (nonatomic ,copy) DisMissRedBlock disMissRedBlock;

@property (nonatomic, assign) BOOL isClickedDisappear;

- (void)updateView:(YPMessage *)message redEnDetModel:(RedPacketDetModel *)redEnDetModel mesg:(NSString *)mesg;

- (void)updateMesgString:(NSString *)mesg;


-(void)disMissRedView;

@end
