//
//  BaseViewController.h
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/9.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"

#define WindowsSize [UIScreen mainScreen].bounds.size

@protocol ItemViewSelectedDelegate <NSObject>

@optional
/*
 @param index 选中的index
 */
- (void)didSelectedItemAtIndex:(NSInteger)index;

@end

@interface ContentBaseViewController : UIViewController<JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) id<ItemViewSelectedDelegate> delegate;

@property (nonatomic, strong) JXCategoryBaseView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

- (JXCategoryBaseView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

/// 是否隐藏TabBar  默认显示
@property (nonatomic, assign) BOOL isHidTabBar;

@end
