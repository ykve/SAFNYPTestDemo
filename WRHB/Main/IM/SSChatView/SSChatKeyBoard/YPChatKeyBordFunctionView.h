//
//  YPChatKeyBordFunctionView.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPChatKeyBoardDatas.h"


/**
 多功能视图
 */

@protocol YPChatKeyBordFunctionViewDelegate <NSObject>

-(void)YPChatKeyBordFunctionViewBtnClick:(NSInteger)index;

@end


@interface YPChatKeyBordFunctionView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign)id<YPChatKeyBordFunctionViewDelegate>delegate;

@property (nonatomic, strong) UIScrollView  *mScrollView;


@end
