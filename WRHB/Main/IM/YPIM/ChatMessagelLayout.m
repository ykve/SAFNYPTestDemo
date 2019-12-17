//
//  YPMessagelLayoutModel.m
//  Project
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ChatMessagelLayout.h"
#import "YPChatDatas.h"
#import "YPChatIMEmotionModel.h"
#import "NSObject+SSAdd.h"
#import "YPMessage.h"
#import "ImageModel.h"
#import "AudioModel.h"
#import "VideoModel.h"


@implementation ChatMessagelLayout

//根据模型返回布局
-(instancetype)initWithMessage:(YPMessage *)message{
    if(self = [super init]){
        self.message = message;
    }
    return self;
}


-(void)setMessage:(YPMessage *)message {
    _message = message;
    
    switch (message.messageType) {
        case MessageType_Text:
        case MessageType_NoRob_SettleRedpacket:
            [self setText];
            break;
        case MessageType_Image:
            [self setImage];
            break;
        case MessageType_Voice:
            [self setVoice];
            break;
        case MessageType_Video:
            [self setVideo];
            break;
        case MessageType_RedPacket:
            [self setRedPacket];
            break;
        case MessageType_CowCow_SettleRedpacket:
            [self setCowCowRewardInfo];
            return;
        case MessageType_ChatNofitiText:
        case MessageType_Single_SettleRedpacket:
            [self setSystemMessage];
            return;
        case MessageType_Map:
            [self setMap];
            break;
        case MessageType_Undo:
            [self setRecallMessage];
            break;
        case MessageType_Delete:
            [self setRemoveMessage];
            break;
        default:
            break;
    }
    [self setCommonView];
}

#pragma mark - 公共部分
- (void)setCommonView {
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(YPChatIconLeftOrRight,YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        _nickNameRect = CGRectMake(YPChatIconLeftOrRight*2 + YPChatHeadImgWH,YPChatCellTopOrBottom, YPChatNameWidth, YPChatNameSpacingHeight-4);
    }else{
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        _nickNameRect = CGRectMake(0,0, 0, 0);
    }
    
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = YPChatTimeTopOrBottom * 2 + YPChatTimeHeight;
        self.headerImgRect = hRect;
        
        CGRect userRect = self.nickNameRect;
        userRect.origin.y = YPChatTimeTopOrBottom * 2 + YPChatTimeHeight;
        self.nickNameRect = userRect;
        
        CGFloat bubbleY;
        if(_message.messageFrom == MessageDirection_RECEIVE){
            bubbleY = _nickNameRect.origin.y + YPChatNameSpacingHeight;
        } else {
            bubbleY = _nickNameRect.origin.y;
        }
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, bubbleY, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
        
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + YPChatCellTopOrBottom;
    
}

#pragma mark - 红包
-(void)setRedPacket {
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight, YPChatCellTopOrBottom + YPChatNameSpacingHeight, YPRedPacketBackWidth, YPRedPacketBackHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
        _textLabRect.origin.x = YPChatTextLRB;
        _textLabRect.origin.y = YPChatTextTop;
        
    }else{
        
        //        _bubbleBackViewRect = CGRectMake( YPChatIcon_RX - YPRedPacketBackWidth - YPChatIconLeftOrRight, YPChatCellTopOrBottom +YPChatNameSpacingHeight, YPRedPacketBackWidth, YPRedPacketBackHeight);
        _bubbleBackViewRect = CGRectMake( YPChatIcon_RX - YPRedPacketBackWidth - YPChatIconLeftOrRight, YPChatCellTopOrBottom, YPRedPacketBackWidth, YPRedPacketBackHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
        
        _textLabRect.origin.x = YPChatTextLRS;
        _textLabRect.origin.y = YPChatTextTop;
    }
}

#pragma mark - 文本
-(void)setText {
    
    UITextView *mTextView = [UITextView new];
    mTextView.font = [UIFont systemFontOfSize:13];
    mTextView.bounds = CGRectMake(0, 0, YPChatTextInitWidth, 100);
    mTextView.text = self.message.text;
    mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [mTextView sizeToFit];
    
    _textLabRect = mTextView.bounds;
    
    CGFloat textWidth  = _textLabRect.size.width;
    if (textWidth <= 50) {
        textWidth = 50;
    }
    CGFloat textHeight = _textLabRect.size.height;
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight - 5, YPChatCellTopOrBottom + YPChatNameSpacingHeight, textWidth+YPChatTextLRB+YPChatTextLRS, textHeight+YPChatTextTop+YPChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
        _textLabRect.origin.x = YPChatTextLRB;
        _textLabRect.origin.y = YPChatTextTop;
        
        _readedBackViewRect = CGRectMake(textWidth+YPChatTextLRB+YPChatTextLRS -(YPChatReadedBackViewWidth - YPChatReadedIconWidth -5)-YPChatAirLRS, (textHeight+YPChatTextTop+YPChatTextBottom) - YPChatReadedBackViewHeight - 2, YPChatReadedBackViewWidth - YPChatReadedIconWidth -5, YPChatReadedBackViewHeight);
    } else {
        
        _bubbleBackViewRect = CGRectMake(YPChatIcon_RX-YPChatDetailRight-YPChatTextLRB-textWidth-YPChatTextLRS + 5, YPChatCellTopOrBottom, textWidth+YPChatTextLRB+YPChatTextLRS, textHeight+YPChatTextTop+YPChatTextBottom);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
        
        _textLabRect.origin.x = YPChatTextLRS;
        _textLabRect.origin.y = YPChatTextTop;
         
        _readedBackViewRect = CGRectMake(textWidth+YPChatTextLRB - YPChatReadedBackViewWidth-6, (textHeight+YPChatTextTop+YPChatTextBottom) - YPChatReadedBackViewHeight - 2, YPChatReadedBackViewWidth, YPChatReadedBackViewHeight);
    }
    
}

#pragma mark - 牛牛报奖信息
-(void)setCowCowRewardInfo {
    
    NSInteger height = 20 + 10;
    // 判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    if(_message.showTime==YES){
        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
    }
    _cellHeight =  _timeLabRect.origin.y + YPChatTimeHeight + YPChatTimeTopOrBottom +  + CowBackImageHeight + height;
    
}

#pragma mark - 系统消息
-(void)setSystemMessage {
    
    _cellHeight =  30;
    
}

#pragma mark - 图片消息
-(void)setImage {
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    imgWidth = _message.imageModel.width;
    imgHeight = _message.imageModel.height;
    
    
    if (imgWidth == 0) {
        imgWidth = 100;
    }
    if (imgHeight == 0) {
        imgHeight = 100;
    }
    CGSize realImageSize = CGSizeMake(imgWidth, imgHeight);

    CGSize imageSize = [self contentSize:kSCREEN_WIDTH size:realImageSize];
    
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(YPChatIconLeftOrRight,YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight, YPChatCellTopOrBottom + YPChatNameSpacingHeight, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
        _readedBackViewRect = CGRectMake(YPChatCellTopOrBottom + YPChatNameSpacingHeight -(YPChatReadedBackViewWidth - YPChatReadedIconWidth -5)-YPChatAirLRS, (YPChatCellTopOrBottom + YPChatNameSpacingHeight) - YPChatReadedBackViewHeight - 2, YPChatReadedBackViewWidth - YPChatReadedIconWidth -5, YPChatReadedBackViewHeight);
        
    }else{
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIcon_RX-YPChatDetailRight- imageSize.width, self.headerImgRect.origin.y, imageSize.width, imageSize.height);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
        
         _readedBackViewRect = CGRectMake(_bubbleBackViewRect.size.width -YPChatReadedBackViewWidth -5, imageSize.height - YPChatReadedBackViewHeight -2, YPChatReadedBackViewWidth, YPChatReadedBackViewHeight);
    }
    
    //判断时间是否显示
//    _timeLabRect = CGRectMake(0, 0, 0, 0);
//
//    if(_message.showTime==YES){
//
//        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
//
//        CGRect hRect = self.headerImgRect;
//        hRect.origin.y = YPChatTimeTopOrBottom+YPChatTimeTopOrBottom+YPChatTimeHeight;
//        self.headerImgRect = hRect;
//
//        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
//    }
//
//    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + YPChatCellTopOrBottom;
    
}

-(void)setVoice {
    
    //计算时间
    CGRect rect = [NSObject getRectWith:[NSString stringWithFormat:@"%d\"", _message.audioModel.time] width:150 font:[UIFont systemFontOfSize:YPChatVoiceTimeFont] spacing:0 Row:0];
    CGFloat timeWidth  = rect.size.width;
    CGFloat timeHeight = rect.size.height;
    
    //根据时间设置按钮实际长度
    CGFloat timeLength = YPChatVoiceMaxWidth - YPChatVoiceMinWidth;
    CGFloat changeLength = timeLength/60;
    CGFloat currentLength = changeLength* _message.audioModel.time+YPChatVoiceMinWidth;
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight - 5, YPChatCellTopOrBottom + YPChatNameSpacingHeight, currentLength, YPChatVoiceHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
        _voiceTimeLabRect = CGRectMake(_bubbleBackViewRect.size.width-timeWidth-18, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(20, (_bubbleBackViewRect.size.height-YPChatVoiceImgSize)/2, YPChatVoiceImgSize, YPChatVoiceImgSize);
        
        
        _readedBackViewRect = CGRectMake(currentLength-35,  YPChatVoiceHeight - YPChatReadedBackViewHeight -2, YPChatReadedBackViewWidth - YPChatReadedIconWidth -5, YPChatReadedBackViewHeight);
        
        _unreadRedDotViewRect = CGRectMake(currentLength-15, YPChatVoiceHeight/2-3, YPChatVoiceUnreadRedDotSize, YPChatVoiceUnreadRedDotSize);
        
    } else {
        
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        _bubbleBackViewRect = CGRectMake(YPChatIcon_RX-YPChatDetailRight-currentLength, self.headerImgRect.origin.y, currentLength, YPChatVoiceHeight);
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
        
        _voiceTimeLabRect = CGRectMake(10, (_bubbleBackViewRect.size.height-timeHeight)/2, timeWidth, timeHeight);
        
        _voiceImgRect = CGRectMake(_bubbleBackViewRect.size.width-YPChatVoiceImgSize-20, (_bubbleBackViewRect.size.height-YPChatVoiceImgSize)/2, YPChatVoiceImgSize, YPChatVoiceImgSize);
        
        _readedBackViewRect = CGRectMake(_bubbleBackViewRect.size.width -YPChatTextLRB -YPChatReadedBackViewWidth, YPChatVoiceHeight - YPChatReadedBackViewHeight -2, YPChatReadedBackViewWidth, YPChatReadedBackViewHeight);
    }
    
    //判断时间是否显示
    //    _timeLabRect = CGRectMake(0, 0, 0, 0);
    //
    //    if(_message.showTime==YES){
    //
    //        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
    //
    //        CGRect hRect = self.headerImgRect;
    //        hRect.origin.y = YPChatTimeTopOrBottom+YPChatTimeTopOrBottom+YPChatTimeHeight;
    //        self.headerImgRect = hRect;
    //
    //        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    //    }
    //
    //    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + YPChatCellTopOrBottom;
    
}


- (CGSize)contentSize:(CGFloat)cellWidth size:(CGSize)size
{
    CGFloat attachmentImageMinWidth  = (cellWidth / 4.0);
    CGFloat attachmentImageMinHeight = (cellWidth / 4.0);
    CGFloat attachmemtImageMaxWidth  = (cellWidth - 184);
    CGFloat attachmentImageMaxHeight = (cellWidth - 184);
    
    
    CGSize imageSize;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        imageSize = size;
    }
    else
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_message.imageModel.URL]]];
        //        UIImage *image = [UIImage imageWithContentsOfFile:_message.imageUrl];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize contentSize = [self sizeWithImageOriginSize:imageSize
                                               minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                               maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight )];
    return contentSize;
}


- (CGSize)sizeWithImageOriginSize:(CGSize)originSize
                          minSize:(CGSize)imageMinSize
                          maxSize:(CGSize)imageMaxSiz{
    CGSize size;
    NSInteger imageWidth = originSize.width ,imageHeight = originSize.height;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.height = imageMinHeight;  //高度取最小高度
        size.width = imageWidth * imageMinHeight / imageHeight;
        if (size.width > imageMaxWidth)
        {
            size.width = imageMaxWidth;
        }
    }
    else if(imageWidth < imageHeight)//高图
    {
        size.width = imageMinWidth;
        size.height = imageHeight *imageMinWidth / imageWidth;
        if (size.height > imageMaxHeight)
        {
            size.height = imageMaxHeight;
        }
    }
    else//方图
    {
        if (imageWidth > imageMaxWidth)
        {
            size.width = imageMaxWidth;
            size.height = imageMaxHeight;
        }
        else if(imageWidth > imageMinWidth)
        {
            size.width = imageWidth;
            size.height = imageHeight;
        }
        else
        {
            size.width = imageMinWidth;
            size.height = imageMinHeight;
        }
    }
    return size;
}


































-(void)setMap {
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(YPChatIconLeftOrRight,YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight, self.headerImgRect.origin.y, YPChatMapWidth, YPChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
        
    }else{
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIcon_RX-YPChatDetailRight-YPChatMapWidth, self.headerImgRect.origin.y, YPChatMapWidth, YPChatMapHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
        
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = YPChatTimeTopOrBottom+YPChatTimeTopOrBottom+YPChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight = _bubbleBackViewRect.size.height + _bubbleBackViewRect.origin.y + YPChatCellTopOrBottom;
    
}

//短视频
-(void)setVideo{
    
     UIImage *vimage = [UIImage imageWithData:_message.videoModel.thumbnail];
    
        CGFloat imgWidth  = CGImageGetWidth(vimage.CGImage);
        CGFloat imgHeight = CGImageGetHeight(vimage.CGImage);
//    CGFloat imgWidth  = 100;
//    CGFloat imgHeight = 100;
    if (imgWidth == 0) {
        imgWidth  = 20;
    }
    if (imgHeight == 0) {
        imgHeight  = 20;
    }
    
    CGFloat imgActualHeight = YPChatImageMaxSize;
    CGFloat imgActualWidth =  YPChatImageMaxSize * imgWidth/imgHeight;
    
    if(imgActualWidth>YPChatImageMaxSize){
        imgActualWidth = YPChatImageMaxSize;
        imgActualHeight = imgActualWidth * imgHeight/imgWidth;
    }
    
    if(_message.messageFrom == MessageDirection_RECEIVE){
        _headerImgRect = CGRectMake(YPChatIconLeftOrRight,YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIconLeftOrRight+YPChatHeadImgWH+YPChatIconLeftOrRight, self.headerImgRect.origin.y, imgActualHeight, imgActualWidth);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRB, YPChatAirBottom, YPChatAirLRS);
        
    }else{
        _headerImgRect = CGRectMake(YPChatIcon_RX, YPChatCellTopOrBottom, YPChatHeadImgWH, YPChatHeadImgWH);
        
        _bubbleBackViewRect = CGRectMake(YPChatIcon_RX-YPChatDetailRight-imgActualWidth, self.headerImgRect.origin.y, imgActualWidth, imgActualHeight);
        
        _imageInsets = UIEdgeInsetsMake(YPChatAirTop, YPChatAirLRS, YPChatAirBottom, YPChatAirLRB);
    }
    
    //判断时间是否显示
    _timeLabRect = CGRectMake(0, 0, 0, 0);
    
    if(_message.showTime==YES){
        
        _timeLabRect = CGRectMake(YPSCREEN_Width/2-100, YPChatTimeTopOrBottom, 200, YPChatTimeHeight);
        
        CGRect hRect = self.headerImgRect;
        hRect.origin.y = YPChatTimeTopOrBottom+YPChatTimeTopOrBottom+YPChatTimeHeight;
        self.headerImgRect = hRect;
        
        _bubbleBackViewRect = CGRectMake(_bubbleBackViewRect.origin.x, _headerImgRect.origin.y, _bubbleBackViewRect.size.width, _bubbleBackViewRect.size.height);
    }
    
    _cellHeight =  _bubbleBackViewRect.origin.y + _bubbleBackViewRect.size.height + YPChatCellTopOrBottom;
    
}



//显示支付定金订单信息
-(void)setOrderValue1{
    
    
}

//显示直接购买订单信息
-(void)setOrderValue2{
    
    
}


//撤销的消息
-(void)setRecallMessage{
    
    
}


//删除的消息
-(void)setRemoveMessage{
    
    
    
}







@end
