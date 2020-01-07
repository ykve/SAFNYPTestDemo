//
//  PayFinishedController.h
//  WRHB
//
//  Created by AFan on 2020/1/3.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayFinishedController : UIViewController
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, copy)void(^onFinishedBlock)(void);
@end

NS_ASSUME_NONNULL_END
