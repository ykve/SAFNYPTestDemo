//
//  NSString+AFString.h
//  WRHB
//
//  Created by AFan on 2019/12/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (AFString)

/// 处理字符串null
+ (NSString *)noNullStringWith:(id)dataString;

@end

NS_ASSUME_NONNULL_END
