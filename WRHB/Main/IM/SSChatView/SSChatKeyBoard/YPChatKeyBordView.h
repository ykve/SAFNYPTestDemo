//
//  YPChatKeyBordView.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPChatKeyBoardDatas.h"
#import "YPChatKeyBordSymbolView.h"
#import "YPChatKeyBordFunctionView.h"


/**
 多功能界面+表情视图的承载视图
 */

@protocol YPChatKeyBordViewDelegate <NSObject>

//点击其他按钮
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)index type:(KeyBordViewFouctionType)type;

//点击表情
-(void)YPChatKeyBordSymbolViewBtnClick:(NSObject *)emojiText;

@end

@interface YPChatKeyBordView : UIView<UIScrollViewDelegate,YPChatKeyBordSymbolViewDelegate,YPChatKeyBordFunctionViewDelegate>

@property (nonatomic, assign)id<YPChatKeyBordViewDelegate>delegate;

//弹窗界面是表情还是其他功能
@property (nonatomic, assign)KeyBordViewFouctionType type;
//表情视图
@property (nonatomic, strong)YPChatKeyBordSymbolView   *symbolView;
//多功能视图
@property (nonatomic, strong)YPChatKeyBordFunctionView *functionView; 
//覆盖视图
@property (nonatomic, strong) UIView *mCoverView;

@end






