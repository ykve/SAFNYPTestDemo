//
//  UIView+CDSDImage.h
//  WRHB
//
//  Created by zhyt on 2019/11/10.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CDSDImage)

@end

@interface UIButton (CDSDImage)

- (void)cd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state;

- (void)cd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)image;

@end

@interface UIImageView (CDSDImage)

- (void)cd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(UIImage *)image;
@end
