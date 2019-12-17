//
//  YPTextView.h
//  Project
//
//  Created by AFan on 2019/4/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DeleteMessageBlock)(void);


@protocol YPTextViewDelegate <NSObject>

@optional;
// 删除消息
-(void)onTextViewDeleteMessage;
// 撤回消息
-(void)onTextViewWithdrawMessage;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YPTextView : UITextView

@property (nonatomic, assign) ChatMessageFrom messageFrom;
//
@property (nonatomic, copy) DeleteMessageBlock deleteMessageBlock;
@property (nonatomic, weak) id <YPTextViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
