//
//  PWView.h
//  WRHB
//
//  Created by AFan on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PWView;

@protocol  PWViewDelegate<NSObject>

@optional

- (void)passWordDidChange:(PWView *)passWord;
- (void)passWordCompleteInput:(PWView *)passWord;
- (void)passWordBeginInput:(PWView *)passWord;

@end

IB_DESIGNABLE

@interface PWView : UIView<UIKeyInput>

@property (strong, nonatomic) UIColor *pointColor;
@property (strong, nonatomic) UIColor *rectColor;
@property (assign, nonatomic) NSUInteger passWordNum;
@property (assign, nonatomic) CGFloat squareWidth;
@property (assign, nonatomic) CGFloat pointRadius;
@property (weak, nonatomic) id<PWViewDelegate> delegate;
@property (strong, nonatomic, readonly) NSMutableString *textStore;

@end

