//
//  ImgCodeModel.h
//  WRHB
//
//  Created by John on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaptchaModel : NSObject

@property(nonatomic,assign)BOOL sensitive;

@property(nonatomic,copy)NSString *key;

@property(nonatomic,copy)NSString *img;

@end

NS_ASSUME_NONNULL_END
