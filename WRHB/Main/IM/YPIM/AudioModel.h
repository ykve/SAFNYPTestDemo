//
//  AudioModel.h
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioModel : NSObject

/** 语音名称 */
@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

/** 语音大小 */
@property(nonatomic, readwrite) int32_t size;

/** 语音ID */
@property(nonatomic, readwrite, copy, null_resettable) NSString *id_p;

/** 语音时间 */
@property(nonatomic, readwrite) int32_t time;

/** URL */
@property(nonatomic, readwrite, copy, null_resettable) NSString *URL;




/// 是否已读或者未读 本地字段 点击过就是已读
@property (nonatomic, assign) BOOL isClickReaded;
/// 授权上传链接 重发消息时使用
@property (nonatomic, copy) NSString *uploadUrl;
// 语音路径 本地
@property (nonatomic, strong) NSString    *voiceLocalPath;
// 语音二进制 本地
@property(nonatomic, strong) NSData *voiceData;


@end

NS_ASSUME_NONNULL_END
