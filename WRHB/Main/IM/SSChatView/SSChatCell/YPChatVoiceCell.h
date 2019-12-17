//
//  YPChatVoiceCell.h
//  YPChatView
//
//  Created by soldoros on 2019/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "AFChatBaseCell.h"
#import "UUAVAudioPlayer.h"

@interface YPChatVoiceCell : AFChatBaseCell<UUAVAudioPlayerDelegate>

@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *mTimeLab;
@property (nonatomic, strong) UIImageView *mVoiceImg;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

//是否在播放
@property (nonatomic, assign) BOOL contentVoiceIsPlaying;

//音频路径 音频文件 播放控制
@property (nonatomic, strong) NSString *voiceURL;
@property (nonatomic, strong) NSData *songData;
@property (nonatomic, strong) UUAVAudioPlayer *audio;

/// 未读红点
@property (nonatomic, strong) UIView *unreadRedDotView;

@end


