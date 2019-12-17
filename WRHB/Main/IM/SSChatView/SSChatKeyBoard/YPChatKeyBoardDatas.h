//
//  YPChatKeyBoardDatas.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"
#import "UIView+SSAdd.h"


/**
 底部按钮点击的五种状态
 
 - YPChatBottomTypeDefault: 默认在底部的状态
 - YPChatBottomTypeVoice: 准备发语音的状态
 - YPChatBottomTypeEdit: 准备编辑文本的状态
 - YPChatBottomTypeSymbol: 准备发送表情的状态
 - YPChatBottomTypeAdd: 准备发送其他功能的状态
 */
typedef NS_ENUM(NSInteger,YPChatKeyBoardStatus) {
    YPChatKeyBoardStatusDefault=1,
    YPChatKeyBoardStatusVoice,
    YPChatKeyBoardStatusEdit,
    YPChatKeyBoardStatusSymbol,
    YPChatKeyBoardStatusAdd,
};



/**
 弹出多功能界面是表情还是其他功能
 
 - KeyBordViewFouctionSymbol: 表情
 - KeyBordViewFouctionAdd: 多功能
 */
typedef NS_ENUM(NSInteger,KeyBordViewFouctionType) {
    KeyBordViewFouctionAdd=1,
    KeyBordViewFouctionSymbol,
};











