//
//  YPMessage.m
//  WRHB
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YPMessage.h"
#import "NSTimer+SSAdd.h"
#import "YPChatIMEmotionModel.h"


@implementation YPMessage

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"messageId": @"id",
              @"sessionId": @"chatId",
              @"messageSendId": @"from",
              @"messageType": @"msgType",
              @"text": @"content",
              @"timestamp": @"createTime",
              @"toUserId": @"to"
              };
}

//判断当前时间是否展示
-(void)showTimeWithLastShowTime:(NSTimeInterval)lastTime currentTime:(NSTimeInterval)currentTime{
    
    NSTimeInterval timeInterval = [NSTimer CompareTwoTime:lastTime time2:currentTime];
    
    if(timeInterval/60 >= 5 || lastTime == currentTime){
        _showTime = YES;
    } else {
        _showTime = NO;
    }
}


//文本消息
-(void)setText:(NSString *)text {
    _text = text;
//    self.attTextString = [[SSChartEmotionImages ShareSSChartEmotionImages]emotionImgsWithString:text];
}

//可变文本消息
-(void)setAttTextString:(NSMutableAttributedString *)attTextString{
    
//    NSMutableParagraphStyle *paragraphString = [[NSMutableParagraphStyle alloc] init];
//    [paragraphString setLineSpacing:YPChatTextLineSpacing];
//    [attTextString addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, attTextString.length)];
//    [attTextString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YPChatTextFont] range:NSMakeRange(0, attTextString.length)];
//    [attTextString addAttribute:NSForegroundColorAttributeName value:YPChatTextColor range:NSMakeRange(0, attTextString.length)];
//    _attTextString = attTextString;
    
}

@end
