//
//  SystemNotificationModel.h
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemNotificationModel : NSObject

/// 公告ID
@property (nonatomic, assign) NSInteger ID;
/// 公告标题
@property (nonatomic, copy) NSString *desTitle;
/// 公告描述
@property (nonatomic, copy) NSString *detail;
/// 排序
@property (nonatomic, assign) NSInteger sort;

@end

NS_ASSUME_NONNULL_END
