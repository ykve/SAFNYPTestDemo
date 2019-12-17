//
//  ClubInitiator.h
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubInitiator : NSObject
/// 玩法URL
@property (nonatomic, assign) NSInteger user_id;
/// 玩法 大类 名称
@property (nonatomic, copy) NSString *name;
/// 头像
@property (nonatomic, copy) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
