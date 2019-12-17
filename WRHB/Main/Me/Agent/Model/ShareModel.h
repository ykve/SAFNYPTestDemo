//
//  ShareModel.h
//  WRHB
//
//  Created by AFan on 2019/10/27.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareModel : NSObject

/// id
@property (nonatomic, assign) NSInteger ID;
/// 分享里的图片
@property (nonatomic, copy) NSString *url;
/// 分享里的名称
@property (nonatomic, copy) NSString *name;
/// 评分 (1-5)
@property (nonatomic, assign) NSInteger score;
/// 访问量
@property (nonatomic, copy) NSString *views;

/// 邀请码 frame
@property (nonatomic, copy) NSString *codeImageFrame;
/// 
@property (nonatomic, copy) NSString *codeFrame;


@end

NS_ASSUME_NONNULL_END
