//
//  VideoModel.h
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject
/** 视频名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 视频大小 */
@property(nonatomic, readwrite) int32_t size;

/** 视频ID */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** 视频时间 */
@property(nonatomic, readwrite) int32_t time;

/** 缩略图 */
@property(nonatomic, readwrite, copy, null_resettable) NSData *thumbnail;

/** 远程URL */
@property(nonatomic, readwrite, copy, null_resettable) NSString *URL;


/// 是否已下载
@property (nonatomic, assign) BOOL isDownload;
/// 视频的本地路径
@property (nullable, nonatomic, copy) NSString *localPath;
/// 授权上传链接 重发消息时使用
@property (nonatomic, copy) NSString *uploadUrl;

@end

NS_ASSUME_NONNULL_END
