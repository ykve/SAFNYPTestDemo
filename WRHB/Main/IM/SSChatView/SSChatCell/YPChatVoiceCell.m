//
//  YPChatVoiceCell.m
//  YPChatView
//
//  Created by soldoros on 2019/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatVoiceCell.h"
#import "audioModel.h"
#import "NSDate+DaboExtension.h"
#import "WHC_ModelSqlite.h"
#import "LGAudioPlayer.h"

@implementation YPChatVoiceCell


-(void)initChatCellUI{
    
    [super initChatCellUI];
    
    
    _voiceBackView = [[UIView alloc]init];
    [self.bubbleBackView addSubview:self.voiceBackView];
    _voiceBackView.userInteractionEnabled = YES;
    _voiceBackView.backgroundColor = [UIColor clearColor];
    
    
    _mTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _mTimeLab.textAlignment = NSTextAlignmentCenter;
    _mTimeLab.font = [UIFont systemFontOfSize:YPChatVoiceTimeFont];
    _mTimeLab.userInteractionEnabled = YES;
    _mTimeLab.backgroundColor = [UIColor clearColor];
    
    
    _mVoiceImg = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 20, 20)];
    _mVoiceImg.userInteractionEnabled = YES;
    _mVoiceImg.animationDuration = 1;
    _mVoiceImg.animationRepeatCount = 0;
    _mVoiceImg.backgroundColor = [UIColor clearColor];
    
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.center=CGPointMake(80, 15);
    
    UIView *voView = [[UIView alloc] init];
    voView.backgroundColor = [UIColor redColor];
    voView.layer.cornerRadius = YPChatVoiceUnreadRedDotSize/2;
    voView.layer.masksToBounds = YES;
    [_voiceBackView addSubview:voView];
    _unreadRedDotView = voView;
    
    
    [_voiceBackView addSubview:_indicator];
    [_voiceBackView addSubview:_mVoiceImg];
    [_voiceBackView addSubview:_mTimeLab];
    
    
    //整个列表只能有一个语音处于播放状态 通知其他正在播放的语音停止
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
    
    //红外线感应监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
}


-(void)setModel:(ChatMessagelLayout *)model{
    [super setModel:model];
    
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
    //    [self.bubbleBackView setBackgroundImage:image forState:UIControlStateNormal];
    
    
    
    _mVoiceImg.image = [UIImage imageNamed:model.message.voiceImg];
    _mVoiceImg.animationImages = model.message.voiceImgs;
    _mVoiceImg.frame = model.voiceImgRect;
    
    
    NSString *time = [NSString stringWithFormat:@"%d\"",self.model.message.audioModel.time];
    _mTimeLab.text = time;
    _mTimeLab.frame = model.voiceTimeLabRect;
    
    self.readedBackView.frame = model.readedBackViewRect;
    self.dateLabel.text = [NSDate stringFromDate:model.message.create_time andNSDateFmt:NSDateFmtHHmm];
    self.dateLabel.textColor = [UIColor colorWithHex:@"#666666"];
    self.unreadRedDotView.frame = model.unreadRedDotViewRect;
    
    if(model.message.messageFrom == MessageDirection_SEND){
        self.readedBackView.frame = model.readedBackViewRect;
        if (model.message.isRemoteRead) {
            self.readedImg.image = [UIImage imageNamed:@"chat_readed"];
        } else {
            self.readedImg.image = [UIImage imageNamed:@"chat_read_send"];
        }
        self.dateLabel.text = [NSDate stringFromDate:model.message.create_time andNSDateFmt:NSDateFmtHHmm];
        
        _unreadRedDotView.hidden = YES;
    } else {
        
        if (model.message.audioModel.isClickReaded) {
            _unreadRedDotView.hidden = YES;
        } else {
            _unreadRedDotView.hidden = NO;
        }
        
    }
//    self.readedImg.hidden = NO;
//    [self.view bringSubviewToFront:backView];
    
    
    
    [self setSendMessageStats];
}


//播放音频 暂停音频
-(void)buttonPressed:(UIButton *)sender {
    self.model.message.audioModel.isClickReaded = YES;
    self.unreadRedDotView.hidden = YES;
    
    if(!_contentVoiceIsPlaying){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
        _contentVoiceIsPlaying = YES;
        [_mVoiceImg startAnimating];
        _audio = [UUAVAudioPlayer sharedInstance];
        _audio.delegate = self;
        if (self.model.message.messageFrom == MessageDirection_SEND) {
            NSData *audioData = [NSData dataWithContentsOfFile:self.model.message.audioModel.voiceLocalPath];
            [_audio playSongWithData:audioData];
        } else {
            [_audio playSongWithUrl:self.model.message.audioModel.URL];
        }
    }else{
        [self UUAVAudioPlayerDidFinishPlay];
    }
    
    
    NSString *whereStr = [NSString stringWithFormat:@"userId = '%ld' and sessionId=%zd AND messageId=%zd", [AppModel sharedInstance].user_info.userId,self.model.message.sessionId,self.model.message.messageId];
    YPMessage *oldMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    oldMessage.audioModel.isClickReaded = YES;
    
    // 更新数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess =  [WHC_ModelSqlite update:oldMessage where:whereStr];
        if (!isSuccess) {
            [WHC_ModelSqlite removeModel:[YPMessage class]];
        }
    });
}

//播放显示开始加载
- (void)UUAVAudioPlayerBeiginLoadVoice{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator startAnimating];
    });
}

//开启红外线感应
- (void)UUAVAudioPlayerBeiginPlay{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [self.indicator stopAnimating];
    
}

//关闭红外线感应
- (void)UUAVAudioPlayerDidFinishPlay{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    _contentVoiceIsPlaying = NO;
    [_mVoiceImg stopAnimating];
    [[UUAVAudioPlayer sharedInstance]stopSound];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}



@end
