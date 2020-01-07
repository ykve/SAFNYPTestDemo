//
//  ReportForms2ViewController.h
//  WRHB
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sub_Users;

NS_ASSUME_NONNULL_BEGIN

@interface ReportForms2ViewController : UIViewController
///
@property (nonatomic, strong) Sub_Users *sub_User;
@property (nonatomic, assign) BOOL isAgent;
@end

NS_ASSUME_NONNULL_END
