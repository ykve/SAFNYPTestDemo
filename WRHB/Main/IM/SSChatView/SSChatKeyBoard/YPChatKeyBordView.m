//
//  YPChatKeyBordView.m
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatKeyBordView.h"

@implementation YPChatKeyBordView


-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = YPChatCellColor;
        
        _symbolView = [[YPChatKeyBordSymbolView alloc]initWithFrame:self.bounds];
        _symbolView.delegate = self;
        [self addSubview:_symbolView];
        _symbolView.userInteractionEnabled = YES;
        
        _functionView = [[YPChatKeyBordFunctionView alloc]initWithFrame:self.bounds];
        _functionView.delegate = self;
        [self addSubview:_functionView];
        _functionView.userInteractionEnabled = YES;
        
        _mCoverView = [[UIView alloc]initWithFrame:self.bounds];
        _mCoverView.backgroundColor = YPChatCellColor;
        [self addSubview:_mCoverView];
        _mCoverView.hidden = NO;
        
        UIView *topLine = [UIView new];
        topLine.frame = CGRectMake(0, 0, self.width, 0.5);
        topLine.backgroundColor = CellLineColor;
        [self addSubview:topLine];
        
        _type = KeyBordViewFouctionAdd;
    }
    return self;
}

//表情视图  其他功能视图
-(void)setType:(KeyBordViewFouctionType)type{
    
    if(_type == type)return;
    _type = type;
    if(_type == KeyBordViewFouctionSymbol){
        _functionView.hidden = YES; 
        _symbolView.hidden = NO;
        _symbolView.top = self.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.symbolView.top = 0;
        } completion:nil];
    }else{
        _functionView.hidden = NO;
        _symbolView.hidden = YES;
        _functionView.top = self.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.functionView.top = 0;
        } completion:nil];
    }
}




#pragma YPChatKeyBordSymbolViewDelegate 发送200
-(void)YPChatKeyBordSymbolViewBtnClick:(NSInteger)index{
    [self YPChatKeyBordButtonPressed:index];
}

//表情点击回调
-(void)YPChatKeyBordSymbolCellClick:(NSObject *)emojiText{
    if(_delegate && [_delegate respondsToSelector:@selector(YPChatKeyBordSymbolViewBtnClick:)]){
        [_delegate YPChatKeyBordSymbolViewBtnClick:emojiText];
    }
}

#pragma YPChatKeyBordFunctionDelegate  其他功能按钮点击回调 500+
-(void)YPChatKeyBordFunctionViewBtnClick:(NSInteger)index{
    [self YPChatKeyBordButtonPressed:index];
}

//发送200  多功能点击10+
-(void)YPChatKeyBordButtonPressed:(NSInteger)index{
    if(_delegate && [_delegate respondsToSelector:@selector(chatFunctionBoardClickedItemWithTag:type:)]){
        [_delegate chatFunctionBoardClickedItemWithTag:index type:_type];
    }
}


@end
