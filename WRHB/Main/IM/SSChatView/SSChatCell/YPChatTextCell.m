//
//  YPChatTextCell.m
//  YPChatView
//
//  Created by soldoros on 2019/10/10.
//  Copyright © 2018年 soldoros. All rights reserved.
//



#import "YPChatTextCell.h"
#import "YPTextView.h"
#import "NSDate+DaboExtension.h"

@interface YPChatTextCell () <YPTextViewDelegate>

@end


@implementation YPChatTextCell

-(void)initChatCellUI{
    [super initChatCellUI];
    
    self.mTextView = [YPTextView new];
    self.mTextView.backgroundColor = [UIColor clearColor];
    self.mTextView.editable = NO;
    self.mTextView.scrollEnabled = NO;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.mTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.bubbleBackView addSubview:self.mTextView];
    self.mTextView.delegate = self;
    self.mTextView.font = [UIFont systemFontOfSize:13];
    
//    __weak __typeof(self)weakSelf = self;
//    self.mTextView.deleteMessageBlock = ^{
//        [self onDeleteMessage];
//    };
}




-(void)setModel:(ChatMessagelLayout *)model{
    [super setModel:model];
    self.mTextView.messageFrom = model.message.messageFrom;
    
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
//    [self.bubbleBackView setBackgroundImage:image forState:UIControlStateNormal];

    self.mTextView.frame = model.textLabRect;
    self.mTextView.text = model.message.text;
    self.mTextView.textColor = [UIColor colorWithHex:@"#333333"];
    
    self.readedBackView.frame = model.readedBackViewRect;
    self.dateLabel.text = [NSDate stringFromDate:model.message.create_time andNSDateFmt:NSDateFmtHHmm];
    self.dateLabel.textColor = [UIColor colorWithHex:@"#666666"];
    
    if(model.message.messageFrom == MessageDirection_SEND){
        if (model.message.isRemoteRead) {
            self.readedImg.image = [UIImage imageNamed:@"chat_readed"];
        } else {
            self.readedImg.image = [UIImage imageNamed:@"chat_read_send"];
        }
        self.mTextView.textColor = [UIColor whiteColor];
        self.dateLabel.textColor = [UIColor whiteColor];
    }
    
    
    [self setSendMessageStats];
    
}




-(void)onTextViewWithdrawMessage {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onWithdrawMessageCell:)]){
        [self.delegate onWithdrawMessageCell:self.model.message];
    }
}


#pragma mark - 删除消息代理
-(void)onTextViewDeleteMessage {
    [self onDeleteMessage];
}

/**
 删除消息
 */
- (void)onDeleteMessage {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDeleteMessageCell:indexPath:)]){
        [self.delegate onDeleteMessageCell:self.model.message indexPath:self.indexPath];
    }
}



@end
