//
//  BannerModel.h
//  WRHB
//
//  Created by AFan on 2019/10/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 图片地址
@property (nonatomic, copy) NSString *img_url;
/// 广告跳转类型:1不跳,2跳app内部,3跳app外网页
@property (nonatomic, copy) NSString *type_url;
/// 广告跳转地址
@property (nonatomic, copy) NSString *jump_url;

@end

NS_ASSUME_NONNULL_END
