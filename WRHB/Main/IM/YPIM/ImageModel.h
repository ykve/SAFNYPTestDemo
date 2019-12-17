//
//  ImageModel.h
//  WRHB
//
//  Created by AFan on 2019/10/26.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

/** 图片名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 图片大小 */
@property(nonatomic, readwrite) int32_t size;

/** 图片ID */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** 高度 */
@property(nonatomic, readwrite) int32_t height;

/** 宽度 */
@property(nonatomic, readwrite) int32_t width;

/** URL */
@property(nonatomic, readwrite, copy, null_resettable) NSString *URL;

/** 缩略图 */
@property(nonatomic, readwrite, copy, null_resettable) NSData *thumbnail;





/// 图片
//@property(nonatomic, strong) UIImage *image;


// 图片转二进制  二进制转图片
///   UIImage *image = [UIImage imageNamed:@"sea"];     NSData *imageData = UIImagePNGRepresentation(image);
///  UIImage *image = [UIImage imageWithData:imageData];
@property(nonatomic, strong) NSData *imageData;
/// 授权上传链接 重发消息时使用
@property (nonatomic, copy) NSString *uploadUrl;

@end

NS_ASSUME_NONNULL_END
