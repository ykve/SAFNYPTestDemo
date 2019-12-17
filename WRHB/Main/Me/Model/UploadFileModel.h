//
//  UploadFileModel.h
//  WRHB
//
//  Created by AFan on 2019/10/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileModel : NSObject

/// 授权上传链接
@property (nonatomic, copy) NSString *url;
/// 上传完成后的url链接
@property (nonatomic, copy) NSString *img;

@end

NS_ASSUME_NONNULL_END
