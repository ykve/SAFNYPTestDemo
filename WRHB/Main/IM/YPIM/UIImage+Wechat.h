//
//  UIImage+Wechat.h
//
//  Created by tiger on 2017/2/21.
//  Copyright © 2017年 xinma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Wechat)

/**
 use session compress Strategy  使用会话压缩策略
 */
- (UIImage *)wcSessionCompress;

/**
 use timeline compress Strategy   使用时间轴压缩策略
 */
- (UIImage *)wcTimelineCompress;

@end
