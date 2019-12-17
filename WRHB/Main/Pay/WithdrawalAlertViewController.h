//
//  WithdrawalAlertViewController.h
//  WRHB
//
//  Created by AFan on 2019/11/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawalAlertViewController : UIViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
