//
//  ClubModel.h
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubModel : NSObject<NSCoding>
/// 俱乐部 ID
@property (nonatomic, assign) NSInteger club_id;
/// 俱乐部名称
@property (nonatomic, copy) NSString *club_name;
/// 俱乐部会话ID
@property (nonatomic, assign) NSInteger session_id;
/// 俱乐部会话名称
@property (nonatomic, copy) NSString *session_name;



/// 俱乐部头像
@property (nonatomic, assign) NSInteger avatar;
/// 是否是拥有者
@property (nonatomic, assign) BOOL is_owner;


/// ********* 用上面的代替 *********
/// 俱乐部 ID 使用club_id替代
@property (nonatomic, assign) NSInteger ID;
/// 俱乐部名称 使用club_name替代
@property (nonatomic, copy) NSString *name;


@end

NS_ASSUME_NONNULL_END
