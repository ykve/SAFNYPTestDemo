//
//  BannerModels.h
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface BannerModels : NSObject

/// <#strong注释#>
@property (nonatomic ,strong) NSArray<BannerModel *> *banners;




// ****** 代理中心接口专有 ******
/// 网站地址
@property (nonatomic, copy) NSString *webSite;
/// 下载地址
@property (nonatomic, copy) NSString *downLoadUrl;
/// 推广信息
@property (nonatomic, copy) NSString *recommend;

@end

NS_ASSUME_NONNULL_END
