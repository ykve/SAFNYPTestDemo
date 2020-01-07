//
//  ReportFormsViewController.h
//  WRHB
//
//  Created AFan on 2019/9/9.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportFormsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportFormsViewController : UIViewController
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) ReportFormsView *reportFormsView;
@property (nonatomic, assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
