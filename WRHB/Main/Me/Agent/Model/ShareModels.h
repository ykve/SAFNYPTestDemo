//
//  ShareModels.h
//  WRHB
//
//  Created by AFan on 2019/10/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShareModel;

NS_ASSUME_NONNULL_BEGIN

@interface ShareModels : NSObject

/// 我的邀请玛
@property (nonatomic, copy) NSString *recommend;
/// copy注释
@property (nonatomic, copy) NSArray<ShareModel *> *items;
/// 下载链接
@property (nonatomic, copy) NSString *down_load_url;


@end

NS_ASSUME_NONNULL_END
