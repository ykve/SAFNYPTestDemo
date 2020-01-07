//
//  BaseUserModel.h
//  WRHB
//
//  Created by AFan on 2019/10/8.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>





NS_ASSUME_NONNULL_BEGIN

@interface BaseUserModel : NSObject<NSCopying>

/// 用户ID
@property (nonatomic, assign) NSInteger userId;


/// 用户头像
@property (nonatomic, copy) NSString *avatar;
/// 名称
@property (nonatomic, copy) NSString *name;
/// 用户性别
@property (nonatomic, assign) UserGender sex;


@end

NS_ASSUME_NONNULL_END
