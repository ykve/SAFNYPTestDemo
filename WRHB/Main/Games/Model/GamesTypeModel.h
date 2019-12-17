//
//  GamesTypeModel.h
//  WRHB
//
//  Created by AFan on 2019/11/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GamesTypeModel : NSObject

/// 玩法 大类 名称
@property (nonatomic, copy) NSString *title;
/// 玩法URL
@property (nonatomic, copy) NSString *url;
/// 群规URL
@property (nonatomic, copy) NSString *role;
///
@property (nonatomic, copy) NSString *avatar;
/// 玩法 小类
@property (nonatomic, strong) NSArray *items;


@end

NS_ASSUME_NONNULL_END
