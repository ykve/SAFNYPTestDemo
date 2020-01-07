//
//  WithdrawalTipsController.h
//  WRHB
//
//  Created by AFan on 2019/12/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawalTipsController : UIViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSTextAlignment messageAlignment;
@property (nonatomic, copy)void(^onSubmitBtnBlock)(void);


@end

NS_ASSUME_NONNULL_END
