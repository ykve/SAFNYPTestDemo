//
//  PayTransferLookController.h
//  WRHB
//
//  Created by AFan on 2020/1/5.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransferModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayTransferLookController : UIViewController

///
@property (nonatomic, strong) TransferModel *model;
@property (nonatomic, copy)void(^onFinishedBlock)(void);
@end

NS_ASSUME_NONNULL_END
