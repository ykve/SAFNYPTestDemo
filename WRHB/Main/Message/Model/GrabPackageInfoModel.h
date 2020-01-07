//
//  GrabPackageInfoModel.h
//  WRHB
//
//  Created by AFan on 2019/10/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GrabPackageInfoModel : NSObject

/// 抢包金额
@property (nonatomic, copy) NSString *value;
/// 用户ID
@property (nonatomic, assign) NSInteger user_id;
/// 是否是发送者
@property (nonatomic, assign) BOOL is_sender;
/// 抢包时间
@property (nonatomic, assign) NSInteger grab_at;
/// 是否中雷
@property (nonatomic, assign) BOOL got_mime;
/// 用户名
@property (nonatomic, copy) NSString *name;
/// 中雷赔付
@property (nonatomic, copy) NSString *mime;
/// 头像
@property (nonatomic, copy) NSString *avatar;
/// 是否是免死机器人
@property (nonatomic, assign) BOOL is_nd;

// *********** 牛牛 ***********
/// 是否庄家  是否是发送者
@property (nonatomic, assign) BOOL is_banker;
/// 牛牛类型  牛牛点数
@property (nonatomic, assign) NSInteger nn_type;



/// 手气最佳
@property (nonatomic, assign) BOOL isLuck;


@end

NS_ASSUME_NONNULL_END
