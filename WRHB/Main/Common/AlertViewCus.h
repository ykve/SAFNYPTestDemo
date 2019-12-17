//
//  AlertViewCus.h
//  Project
//
//  Created AFan on 2019/9/21.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewCus : UIView
@property (nonatomic ,strong) UILabel *textLabel;
+ (AlertViewCus *)createInstanceWithView:(UIView *)superView;
-(void)showWithText:(NSString *)text button:(NSString *)buttonTitle callBack:(CallbackBlock)block;
-(void)showWithText:(NSString *)text button1:(NSString *)buttonTitle1 button2:(NSString *)buttonTitle2 callBack:(CallbackBlock)block;
@end
