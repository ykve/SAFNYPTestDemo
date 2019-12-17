//
//  YPMessagelLayoutModel.h
//  Project
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

@class YPMessage;

@interface ChatMessagelLayout : NSObject
/**
 根据模型生成布局
 
 @param message 传入消息模型
 @return 返回布局对象
 */
-(instancetype)initWithMessage:(YPMessage *)message;

/// 消息模型
@property (nonatomic, strong) YPMessage  *message;

/// 群id sql
@property (nonatomic, copy)         NSString *groupId;
@property (nonatomic, strong)        NSDate *create_time;

/// 消息布局到CELL的总高度
@property (nonatomic, assign) CGFloat      cellHeight;

/// 用户昵称frame
@property (nonatomic, assign) CGRect       nickNameRect;
/// 头像控件的frame
@property (nonatomic, assign) CGRect       headerImgRect;
/// 时间控件的frame
@property (nonatomic, assign) CGRect       timeLabRect;

/// 背景按钮的frame
@property (nonatomic, assign) CGRect       bubbleBackViewRect;
/// 背景按钮图片的拉伸膜是和保护区域
@property (nonatomic, assign) UIEdgeInsets imageInsets;

/// 文本间隙的处理
@property (nonatomic, assign) UIEdgeInsets textInsets;
/// 文本控件的frame
@property (nonatomic, assign) CGRect       textLabRect;

/// 语音时长控件的frame
@property (nonatomic, assign) CGRect       voiceTimeLabRect;
/// 语音波浪图标控件的frame
@property (nonatomic, assign) CGRect       voiceImgRect;
/// 语音未读红点
@property (nonatomic, assign) CGRect       unreadRedDotViewRect;


/// 视频控件的frame
@property (nonatomic, assign) CGRect       videoImgRect;



/// 已读标识frame
@property (nonatomic, assign) CGRect       readedBackViewRect;

@end
