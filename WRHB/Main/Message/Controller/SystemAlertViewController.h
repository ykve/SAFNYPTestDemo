//
//  VVAlertViewController.h
//  WRHB
//
//  Created by AFan on 2019/3/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SystemAlertViewController : UIViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray;

@end

