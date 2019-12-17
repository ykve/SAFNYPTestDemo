//
//  ClubMemberDetailsModel.h
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PayAssetsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberDetailsModel : NSObject

/// ID
@property (nonatomic, assign) NSInteger ID;
/// 昵称
@property (nonatomic, copy) NSString *name;
///
@property (nonatomic, copy) NSString *avatar;
/// 用户金额相关信息
@property (nonatomic ,strong) PayAssetsModel *asset;

@end

NS_ASSUME_NONNULL_END
