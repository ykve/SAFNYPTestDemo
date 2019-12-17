//
//  YPTextView.m
//  Project
//
//  Created by AFan on 2019/4/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YPTextView.h"

@implementation YPTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addMenuItemView];
    }
    return self;
}

- (void)addMenuItemView {
    UIMenuItem *peiMenuItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(onDeleteMessage:)];
    UIMenuItem *withdrawItem = [[UIMenuItem alloc]initWithTitle:@"撤回" action:@selector(withdrawMessage:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[peiMenuItem,withdrawItem]];
}



-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) || action == @selector(onDeleteMessage:) || action == @selector(withdrawMessage:)) {
        if (action == @selector(withdrawMessage:) && self.messageFrom == MessageDirection_RECEIVE) {
            
                if([AppModel sharedInstance].user_info.managerFlag || [AppModel sharedInstance].user_info.groupowenFlag || [AppModel sharedInstance].user_info.innerNumFlag){
                    return YES;
                }
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)onDeleteMessage:(id)sender {
//    if (self.deleteMessageBlock) {
//        self.deleteMessageBlock();
//    }
    self.userInteractionEnabled = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onTextViewDeleteMessage)]){
        [self.delegate onTextViewDeleteMessage];
    }
    self.userInteractionEnabled = YES;
}
- (void)withdrawMessage:(id)sender {
    self.userInteractionEnabled = NO;
    if(self.delegate && [self.delegate respondsToSelector:@selector(onTextViewWithdrawMessage)]){
        [self.delegate onTextViewWithdrawMessage];
    }
    self.userInteractionEnabled = YES;
}


- (void)allSelectClick:(id)sender {
    
    NSLog(@"全选");
}

@end
