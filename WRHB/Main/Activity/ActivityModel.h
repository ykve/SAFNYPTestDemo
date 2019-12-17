//
//  ActivityModel.h
//  WRHB
//
//  Created by AFan on 2019/10/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityModel : NSObject

/// 图片抵制
@property (nonatomic, copy) NSString *img;
/// 跳转链接
@property (nonatomic, copy) NSString *url;
/// title
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
