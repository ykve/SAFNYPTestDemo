//
//  YPChatKeyBordSymbolView.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPChatKeyBoardDatas.h"
#import "YPChatIMEmotionModel.h"
#import "UIImage+SSAdd.h"

/**
 表情视图底部发送和表情筛选部分
 */
#define YPChatKeyBordSymbolFooterH  40

@protocol YPChatKeyBordSymbolFooterDelegate <NSObject>

-(void)YPChatKeyBordSymbolFooterBtnClick:(UIButton *)sender;

@end


@interface YPChatKeyBordSymbolFooter : UIView

@property (nonatomic, assign)id<YPChatKeyBordSymbolFooterDelegate>delegate;

//表情切换的滚动视图(其实没有很多，为了能拓展就用这个吧)
@property (nonatomic, strong) UIScrollView *emojiFooterScrollView;
//发送按钮
@property (nonatomic, strong) UIButton *sendButton;
//第一类表情 第二类表情
@property (nonatomic, strong) UIButton *mButton1,*mButton2;


@end



/**
 表单cell
 */

#define YPChatEmojiCollectionCellId  @"YPChatEmojiCollectionCellId"
#define DeleteButtonId               @"DeleteButtonId"

@interface YPChatEmojiCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong) UIButton *button;

@end




/**
 表情列表视图
 */
@protocol YPChatKeyBordSymbolViewDelegate <NSObject>

-(void)YPChatKeyBordSymbolViewBtnClick:(NSInteger)index;
//点击其中的一个表情或者删除按钮
- (void)YPChatKeyBordSymbolCellClick:(NSObject *)emojiText;

@end

@interface YPChatKeyBordSymbolView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,YPChatKeyBordSymbolFooterDelegate>

@property (nonatomic, assign)id<YPChatKeyBordSymbolViewDelegate>delegate;

@property (nonatomic, strong)SSChartEmotionImages *emotion;
@property (nonatomic, strong) NSMutableArray *defaultEmoticons;
@property (nonatomic, strong) NSMutableArray *emoticonImages;

//每一页的表情数量
@property (nonatomic, assign) NSInteger number;
//底部pagecontroller显示的数量
@property (nonatomic, assign) NSInteger numberPage;
@property (nonatomic, assign) NSInteger numberPage1;
@property (nonatomic, assign) NSInteger numberPage2;


@property (nonatomic, strong) YPChatKeyBordSymbolFooter *footer;


@property (nonatomic, strong)YPChatCollectionViewFlowLayout *layout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageControl;

@end




