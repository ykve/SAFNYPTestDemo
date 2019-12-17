//
//  PopSummaryModel.h
//  WRHB
//
//  Created by AFan on 2019/11/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopSummaryModel : NSObject

/// 发包
@property (nonatomic, copy) NSString *sendDesc;
/// 抢包
@property (nonatomic, copy) NSString *grabDesc;
/// 中雷
@property (nonatomic, copy) NSString *mimeDesc;
/// 输赢结果
@property (nonatomic, copy) NSString *resultDesc;

@end

NS_ASSUME_NONNULL_END
