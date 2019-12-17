//
//  ClubMemberModel.h
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberModel : NSObject
/// ID
@property (nonatomic, assign) NSInteger ID;
/// 昵称
@property (nonatomic, copy) NSString *name;
/// 余额
@property (nonatomic, copy) NSString *over_num;
/// 流水
@property (nonatomic, copy) NSString *capital;
/// 角色 1 会员 2 管理 3 群主
@property (nonatomic, assign) NSInteger role;
/// 禁言 1 不禁言 2 禁言
@property (nonatomic, assign) NSInteger can_speak;


/// 本地添加
/// 踢人 1 踢
@property (nonatomic, assign) NSInteger kicking;


@end

NS_ASSUME_NONNULL_END
