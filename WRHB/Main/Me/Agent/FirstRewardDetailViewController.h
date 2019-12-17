//
//  ImageDetailWithTitleViewController.h
//  Project
//
//  Created AFan on 2019/9/31.
//  Copyright © 2019 AFan. All rights reserved.
//需要在图片上写字

#import "ImageDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstRewardDetailViewController : ImageDetailViewController
@property (nonatomic, strong) NSString *text;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger rewardType;

@end

NS_ASSUME_NONNULL_END
