//
//  YPChatKeyBoardInputView.m
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatKeyBoardInputView.h"

@implementation YPChatKeyBoardInputView

-(instancetype)init{
    if(self = [super init]){
        self.backgroundColor =  YPChatCellColor;
        self.frame = CGRectMake(0, YPSCREEN_Height-YPChatKeyBoardInputViewH-kiPhoneX_Bottom_Height, YPSCREEN_Width, YPChatKeyBoardInputViewH);
        
        _keyBoardStatus = YPChatKeyBoardStatusDefault;
        _keyBoardHieght = 0;
        _changeTime = 0.25;
        _textH = YPChatTextHeight;
        
        _topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YPSCREEN_Width, 0.5)];
        _topLine.backgroundColor = CellLineColor;
        [self addSubview:_topLine];
        
        //左侧按钮
        _mLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mLeftBtn.bounds = CGRectMake(0, 0, YPChatBtnSize, YPChatBtnSize);
        _mLeftBtn.left    = YPChatBtnDistence;
        _mLeftBtn.bottom  = self.height - YPChatBBottomDistence;
        _mLeftBtn.tag  = 10;
        [self addSubview:_mLeftBtn];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_yuying"] forState:UIControlStateNormal];
        [_mLeftBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuru"] forState:UIControlStateSelected];
        _mLeftBtn.selected = NO;
        [_mLeftBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //添加按钮
        _mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mAddBtn.bounds = CGRectMake(0, 0, YPChatBtnSize, YPChatBtnSize);
        _mAddBtn.right = YPSCREEN_Width - YPChatBtnDistence;
        _mAddBtn.bottom  = self.height - YPChatBBottomDistence;
        _mAddBtn.tag  = 12;
        _mAddBtn.selected = NO;
        [self addSubview:_mAddBtn];
        
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
        [_mAddBtn setBackgroundImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateSelected];
        _mAddBtn.selected = NO;
        [_mAddBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //表情按钮
        _mSymbolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mSymbolBtn.bounds = CGRectMake(0, 0, YPChatBtnSize, YPChatBtnSize);
        _mSymbolBtn.right = _mAddBtn.left - YPChatBtnDistence;
        _mSymbolBtn.bottom  = self.height - YPChatBBottomDistence;
        _mSymbolBtn.backgroundColor = [UIColor whiteColor];
        _mSymbolBtn.tag  = 11;
        [self addSubview:_mSymbolBtn];
        [_mSymbolBtn setBackgroundImage:[UIImage imageNamed:@"icon_biaoqing"] forState:UIControlStateNormal];
        [_mSymbolBtn setBackgroundImage:[UIImage imageNamed:@"icon_shuru"] forState:UIControlStateSelected];
        _mSymbolBtn.selected = NO;
        [_mSymbolBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        // 语音按钮   输入框
        _mTextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _mTextBtn.bounds = CGRectMake(0, 0, YPChatTextWidth, YPChatTextHeight);
        _mTextBtn.left = _mLeftBtn.right+YPChatBtnDistence;
//        _mTextBtn.left = YPChatBtnDistence;
        _mTextBtn.bottom = self.height - YPChatTBottomDistence;
        _mTextBtn.backgroundColor = [UIColor whiteColor];
        _mTextBtn.layer.borderWidth = 0.5;
        _mTextBtn.layer.borderColor = CellLineColor.CGColor;
        _mTextBtn.clipsToBounds = YES;
        _mTextBtn.layer.cornerRadius = 3;
        [self addSubview:_mTextBtn];
        _mTextBtn.userInteractionEnabled = YES;
        _mTextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_mTextBtn setTitleColor:makeColorRgb(100, 100, 100) forState:UIControlStateNormal];
        [_mTextBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_mTextBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_mTextBtn addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        
        [_mTextBtn addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [_mTextBtn addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_mTextBtn addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_mTextBtn addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        
        _mTextView = [[UITextView alloc]init];
        _mTextView.frame = _mTextBtn.bounds;
        _mTextView.textContainerInset = UIEdgeInsetsMake(7.5, 5, 5, 5);
        _mTextView.delegate = self;
        [_mTextBtn addSubview:_mTextView];
        _mTextView.backgroundColor = [UIColor whiteColor];
        _mTextView.returnKeyType = UIReturnKeySend;
        _mTextView.font = [UIFont systemFontOfSize:15];
        _mTextView.showsHorizontalScrollIndicator = NO;
        _mTextView.showsVerticalScrollIndicator = NO;
        _mTextView.enablesReturnKeyAutomatically = YES;
        _mTextView.scrollEnabled = NO;
        
        
        _mKeyBordView = [[YPChatKeyBordView alloc]initWithFrame:CGRectMake(0, self.height, YPSCREEN_Width, YPChatKeyBordHeight)];
        _mKeyBordView.delegate = self;
        [self addSubview:_mKeyBordView];
        
        
        //键盘显示 回收的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


//开始布局就把底部的表情和多功能放在输入框底部了 这里需要对点击界外事件做处理
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if(point.y>YPChatKeyBoardInputViewH){
        UIView *hitView = [super hitTest:point withEvent:event];
        
        NSMutableArray *array = [NSMutableArray new];

        if(_mKeyBordView.type == KeyBordViewFouctionAdd){
            for(UIView * view in _mKeyBordView.functionView.mScrollView.subviews){
                [array addObjectsFromArray:view.subviews];
            }
        }
        else if(_mKeyBordView.type == KeyBordViewFouctionSymbol){
            
            CGPoint buttonPoint = [_mKeyBordView.symbolView.footer.sendButton convertPoint:point fromView:self];
        if(CGRectContainsPoint(_mKeyBordView.symbolView.footer.sendButton.bounds, buttonPoint)) {
                [array addObject:_mKeyBordView.symbolView.footer.sendButton];
            }
            else{
                CGPoint footerPoint = [_mKeyBordView.symbolView.footer.emojiFooterScrollView convertPoint:point fromView:self];
            if(CGRectContainsPoint(_mKeyBordView.symbolView.footer.emojiFooterScrollView.bounds, footerPoint)) {
                    [array addObjectsFromArray: _mKeyBordView.symbolView.footer.emojiFooterScrollView.subviews];
                }
                else{
                    [array addObjectsFromArray: _mKeyBordView.symbolView.collectionView.subviews];
                }
            }
        }
        
        for(UIView *subView in array) {
            
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if(CGRectContainsPoint(subView.bounds, myPoint)) {
                hitView = subView;
                break;
            }
        }
      
        return hitView;
    }
    else{
        return [super hitTest:point withEvent:event];
    }
}

//键盘显示监听事件
- (void)keyboardWillChange:(NSNotification *)noti{
    
    _changeTime  = [[noti userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    if(noti.name == UIKeyboardWillHideNotification){
        height = kiPhoneX_Bottom_Height;
        if(_keyBoardStatus == YPChatKeyBoardStatusSymbol ||
           _keyBoardStatus == YPChatKeyBoardStatusAdd){
            height = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
        }
    }else{
        
        self.keyBoardStatus = YPChatKeyBoardStatusEdit;
        self.currentBtn.selected = NO;
        
        if(height==kiPhoneX_Bottom_Height || height==0) height = _keyBoardHieght;
    }
    
    self.keyBoardHieght = height;
}

//弹起的高度
-(void)setKeyBoardHieght:(CGFloat)keyBoardHieght{
    
    if(keyBoardHieght == _keyBoardHieght){
        return;
    }
    
    _keyBoardHieght = keyBoardHieght;
    [self setNewSizeWithController];

    [UIView animateWithDuration:_changeTime animations:^{
        if(self.keyBoardStatus == YPChatKeyBoardStatusDefault ||
           self.keyBoardStatus == YPChatKeyBoardStatusVoice){
            self.bottom = YPSCREEN_Height-kiPhoneX_Bottom_Height;
        }else{
            self.bottom = YPSCREEN_Height-self.keyBoardHieght;
        }
    } completion:nil];
    
}


//设置默认状态
-(void)setKeyBoardStatus:(YPChatKeyBoardStatus)keyBoardStatus{
    _keyBoardStatus = keyBoardStatus;
    
    if(_keyBoardStatus == YPChatKeyBoardStatusDefault){
        self.currentBtn.selected = NO;
        self.mTextView.hidden = NO;
        self.mKeyBordView.mCoverView.hidden = NO;
    }
}


//视图归位 设置默认状态 设置弹起的高度
-(void)SetSSChatKeyBoardInputViewEndEditing{
    if(self.keyBoardStatus != YPChatKeyBoardStatusVoice){
        self.keyBoardStatus = YPChatKeyBoardStatusDefault;
        [self endEditing:YES];
        self.keyBoardHieght = 0.0;
    }
}


//语音10  表情11  其他功能12
-(void)btnPressed:(UIButton *)sender{
   
    [[UUAVAudioPlayer sharedInstance]stopSound];

    switch (self.keyBoardStatus) {
            
            //默认在底部状态
        case YPChatKeyBoardStatusDefault:{
            if(sender.tag==10){
                self.keyBoardStatus = YPChatKeyBoardStatusVoice;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                self.mTextView.hidden = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.keyBoardHieght = 0.0;
                [self setNewSizeWithBootm:YPChatTextHeight];
            }
            else if (sender.tag==11){
                self.keyBoardStatus = YPChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                [self.mTextView resignFirstResponder];
                self.keyBoardHieght = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }else{
                self.keyBoardStatus = YPChatKeyBoardStatusAdd;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                _mKeyBordView.mCoverView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }
        }
            break;
            
            //在输入语音的状态
        case YPChatKeyBoardStatusVoice:{
            if(sender.tag==10){
                self.keyBoardStatus = YPChatKeyBoardStatusEdit;
                self.currentBtn.selected = NO;
                self.mTextView.hidden = NO;
                _mKeyBordView.mCoverView.hidden = NO;
                [self.mTextView becomeFirstResponder];
                [self setNewSizeWithBootm:_textH];
                
            }else if (sender.tag==11){
                self.keyBoardStatus = YPChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }else{
                self.keyBoardStatus = YPChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
                [self setNewSizeWithBootm:_textH];
            }
            [self textViewDidChange:self.mTextView];
        }
            break;
            
            //在编辑文本的状态
        case YPChatKeyBoardStatusEdit:{
            if(sender.tag==10){
                self.keyBoardStatus = YPChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                [self.mTextView endEditing:YES];
                [self setNewSizeWithBootm:YPChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = YPChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                [self.mTextView resignFirstResponder];
                self.keyBoardHieght = kiPhoneX_Bottom_Height+YPChatKeyBordHeight;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
                
            }else{
                self.keyBoardStatus = YPChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
                [self.mTextView endEditing:YES];
            }
        }
            break;
            
            //在选择表情的状态
        case YPChatKeyBoardStatusSymbol:{
            
            if(sender.tag==10){
                self.keyBoardStatus = YPChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;

                [self setNewSizeWithBootm:YPChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = YPChatKeyBoardStatusEdit;
                self.currentBtn.selected = NO;
                _mKeyBordView.mCoverView.hidden = YES;
                [self.mTextView becomeFirstResponder];
                
            }else{
                self.keyBoardStatus = YPChatKeyBoardStatusAdd;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                _mKeyBordView.type = KeyBordViewFouctionAdd;
            }
        }
            
            break;
            
            //在选择其他功能的状态
        case YPChatKeyBoardStatusAdd:{
            if(sender.tag==10){
                self.keyBoardStatus = YPChatKeyBoardStatusVoice;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = NO;
                self.mTextView.hidden = YES;
                self.keyBoardHieght = kiPhoneX_Bottom_Height;

                [self setNewSizeWithBootm:YPChatTextHeight];
            }else if (sender.tag==11){
                self.keyBoardStatus = YPChatKeyBoardStatusSymbol;
                self.currentBtn.selected = NO;
                self.currentBtn = sender;
                self.currentBtn.selected = YES;
                _mKeyBordView.mCoverView.hidden = YES;
                self.mTextView.hidden = NO;
                self.keyBoardHieght = kiPhoneX_Bottom_Height+_mKeyBordView.height;
                _mKeyBordView.type = KeyBordViewFouctionSymbol;
            }else{
                [self.mTextView becomeFirstResponder];
                _mKeyBordView.mCoverView.hidden = YES;
            }
        }
            break;
            
        default:
            break;
    }
    
}


//添加表情来了
-(void)setEmojiText:(NSObject *)emojiText{
    _emojiText = emojiText;
    
    //删除表情字符串
    if ([emojiText isEqual: DeleteButtonId]) {
        [[SSChartEmotionImages ShareSSChartEmotionImages] deleteEmtionString:_mTextView];
    }
    //系统自带表情直接拼接
    else if (![_emojiText isKindOfClass:[UIImage class]]) {
        [self.mTextView replaceRange:self.mTextView.selectedTextRange withText:(NSString *)_emojiText];
    }
    //其他的表情用可变字符来处理
    else {
        NSString * emtionString = [[SSChartEmotionImages ShareSSChartEmotionImages] emotionStringWithImg:(UIImage *)_emojiText];
        self.mTextView.text = [NSString stringWithFormat:@"%@%@",_mTextView.text, emtionString];
    }
    
    [self textViewDidChange:_mTextView];
}



//设置所有控件新的尺寸位置
-(void)setNewSizeWithBootm:(CGFloat)height{
   
    [self setNewSizeWithController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mTextView.height = height;
        self.height = 8 + 8 + self.mTextView.height;
        
        self.mTextBtn.height = self.mTextView.height;
        self.mTextBtn.bottom = self.height-YPChatTBottomDistence;
        self.mTextView.top = 0;
        self.mLeftBtn.bottom = self.height-YPChatBBottomDistence;
        self.mAddBtn.bottom = self.height-YPChatBBottomDistence;
        self.mSymbolBtn.bottom = self.height-YPChatBBottomDistence;
        self.mKeyBordView.top = self.height;
        
        if(self.keyBoardStatus == YPChatKeyBoardStatusDefault ||
           self.keyBoardStatus == YPChatKeyBoardStatusVoice){
            self.bottom = YPSCREEN_Height-kiPhoneX_Bottom_Height;
        }else{
            self.bottom = YPSCREEN_Height-self.keyBoardHieght;
        }
        
    } completion:^(BOOL finished) {
        [self.mTextView.superview layoutIfNeeded];
    }];
}

//设置键盘和表单位置
-(void)setNewSizeWithController{
    
    CGFloat changeTextViewH = fabs(_textH - YPChatTextHeight);
    if(self.mTextView.hidden == YES) changeTextViewH = 0;
    CGFloat changeH = _keyBoardHieght + changeTextViewH;
    
//    SSDeviceDefault *device = [SSDeviceDefault shareCKDeviceDefault];
    if(kiPhoneX_Bottom_Height != 0 && _keyBoardHieght!=0){
        changeH -= kiPhoneX_Bottom_Height;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(YPChatKeyBoardInputViewHeight:changeTime:)]){
        [_delegate YPChatKeyBoardInputViewHeight:changeH changeTime:_changeTime];
    }
}

//拦截发送按钮
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if(text.length==0){
        [[SSChartEmotionImages ShareSSChartEmotionImages] deleteEmtionString:self.mTextView];
        [self textViewDidChange:self.mTextView];
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self startSendMessage];
        return NO;
    }
    
    return YES;
}

//开始发送消息
-(void)startSendMessage{
    NSString *message = [_mTextView.attributedText string];
    NSString *newMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(message.length==0){
       
    }
    else if(_delegate && [_delegate respondsToSelector:@selector(onChatKeyBoardInputViewSendText:)]){
        [_delegate onChatKeyBoardInputViewSendText:newMessage];
    }
    
    _mTextView.text = @"";
    _textString = _mTextView.text;
    _mTextView.contentSize = CGSizeMake(_mTextView.contentSize.width, 30);
    [_mTextView setContentOffset:CGPointZero animated:YES];
    [_mTextView scrollRangeToVisible:_mTextView.selectedRange];
    _mKeyBordView.symbolView.footer.sendButton.enabled = NO;
    
    _textH = YPChatTextHeight;
    [self setNewSizeWithBootm:_textH];
}


//监听输入框的操作 输入框高度动态变化
- (void)textViewDidChange:(UITextView *)textView{
    
    _textString = textView.text;
    
    NSString *message = [_textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(message.length==0 || message==nil){
        _mKeyBordView.symbolView.footer.sendButton.enabled = NO;
    }else{
        _mKeyBordView.symbolView.footer.sendButton.enabled = YES;
    }

    
    //获取到textView的最佳高度
    NSInteger height = ceilf([textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)].height);

    if(height>YPChatTextMaxHeight){
        height = YPChatTextMaxHeight;
        textView.scrollEnabled = YES;
    }
    else if(height<YPChatTextHeight){
        height = YPChatTextHeight;
        textView.scrollEnabled = NO;
    }
    else{
        textView.scrollEnabled = NO;
    }

    if(_textH != height){
        _textH = height;
        [self setNewSizeWithBootm:height];
    }
    else{
        [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 2)];
    }
}


#pragma YPChatKeyBordSymbolViewDelegate 底部视图按钮点击回调
//发送200  多功能点击10+
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)tag type:(KeyBordViewFouctionType)type{
    if(tag==200){
        [self startSendMessage];
    }
    else if(tag<200 || tag>=2000){
        if(_delegate && [_delegate respondsToSelector:@selector(chatFunctionBoardClickedItemWithTag:)]){
            [_delegate chatFunctionBoardClickedItemWithTag:tag];
        }
    }
}

//点击表情
-(void)YPChatKeyBordSymbolViewBtnClick:(NSObject *)emojiText{
    self.emojiText = emojiText;
}


#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button{
    
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:nil];
    [_audioSession setActive:YES error:nil];

    NSDictionary *recordSetting = @{AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                    AVSampleRateKey : [NSNumber numberWithFloat:8000],
                                    AVEncoderBitRateKey : [NSNumber numberWithInt:16],
                                    AVNumberOfChannelsKey : @1,
                                    AVLinearPCMBitDepthKey : @16
                                    };
    NSError *error = nil;
   
    NSString *cdPath = [CDFunction recordPath];
    //设置文件保存路径和名称
    NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.caf", [[NSDate date] timeIntervalSince1970]];
     _docmentFilePath = [cdPath stringByAppendingPathComponent:fileName];
    NSURL *pathURL = [NSURL fileURLWithPath:_docmentFilePath];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:recordSetting error:&error];
    if (error || !_recorder) {
        NSLog(@"recorder: %@ %zd %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    
    if (!_audioSession.isInputAvailable) {
        return;
    }
    
    [_recorder record];
    [_recorder recordForDuration:0];
    
    _playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
    
}

//录音结束
- (void)endRecordVoice:(UIButton *)button{
    [_recorder stop];
    [_playTimer invalidate];
    _playTimer = nil;
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (_playTimer) {
        [_recorder stop];
        [_recorder deleteRecording];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"取消"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"释放即可取消"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"向上滑动即可取消"];
}


- (void)countVoiceTime
{
    [_recorder updateMeters];
    double ff = [_recorder averagePowerForChannel:0];
    [[UUProgressHUD sharedView] updateLevel:ff];
    _playTime ++;
    if (_playTime>=59) {
        [self endRecordVoice:nil];
    }
}


#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    if(![self recordFileCanBeSend:self.docmentFilePath]){
//        [MBProgressHUD showTipMessageInWindow:@"录音时间太短"];
        [UUProgressHUD dismissWithError:@"录音时间太短"];
    } else {
        
        if(_delegate && [_delegate respondsToSelector:@selector(YPChatKeyBoardInputViewBtnClick:voicePath:sendVoice:time:)]){
            [self.delegate YPChatKeyBoardInputViewBtnClick:self voicePath:self.docmentFilePath sendVoice:voiceData time:_playTime+1];
        }
        [UUProgressHUD dismissWithSuccess:@"成功"];
        
        //缓冲消失时间 (最好有block回调消失完成)
        self.btnVoiceRecord.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btnVoiceRecord.enabled = YES;
        });
    }
    
    
    
}

- (void)failRecord
{
//    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}



#pragma mark - AVAudioRecorderDelegate 关闭活动 避免影响其他媒体
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    [_audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:_docmentFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
    if (audioData) {
        [self endConvertWithData:audioData];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    [_audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}


/**
 添加@ 用户
 
 @param userInfo 用户模型
 */
- (void)addMentionedUser:(UserInfo *)userInfo {
    self.mTextView.text = [NSString stringWithFormat:@"%@@%@ ",_mTextView.text, userInfo.name];
    [self textViewDidChange:_mTextView];
}


- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 1;
}

@end
