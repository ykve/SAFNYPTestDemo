//
//  SelectContactsController.h
//  WRHB
//
//  Created by AFan on 2019/11/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectContactsController : UIViewController
///
@property (nonatomic, assign) NSInteger sessionId;
/// 已添加数组
@property (nonatomic, strong) NSMutableArray *addedArray;

@end

NS_ASSUME_NONNULL_END
