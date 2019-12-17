//
//  CustomSegmentControl.m
//  SwipeTableView
//
//  Created by Roy lee on 16/5/28.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "CustomSegmentControl.h"
#import "UIView+STFrame.h"
#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CustomSegmentControl ()

@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;

///
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CustomSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles images:(NSArray<NSString *> *)images {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        if (titles.count > 0) {
            self.titles = titles;
            self.images = images;
        }
    }
    return self;
}

- (void)commonInit {
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    _font = [UIFont systemFontOfSize:15];
    _textColor = RGBColor(50, 50, 50);
    _selectedTextColor = RGBColor(0, 0, 0);
    _selectionIndicatorColor = RGBColor(150, 150, 150);
    _titles = @[@"Segment0",@"Segment1"];
    _selectedSegmentIndex = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    
    
    _contentView.backgroundColor = _backgroundColor;
    _contentView.frame = CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height-2);
    
    
    for (int i = 0; i < _titles.count; i ++) {
        UIButton * itemBt = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBt.tag = 666 + i;
        [itemBt setTitleColor:_textColor forState:UIControlStateNormal];
        [itemBt setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [itemBt setImage:[UIImage imageNamed:self.images[i]] forState:UIControlStateNormal];
        
        [itemBt setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
        [itemBt setTitle:_titles[i] forState:UIControlStateNormal];
        [itemBt.titleLabel setFont:_font];
        CGFloat itemWidth = self.st_width/_titles.count;
        itemBt.st_size = CGSizeMake(itemWidth, self.st_height);
        itemBt.st_x    = itemWidth * i;
        if (i == _selectedSegmentIndex) {
            itemBt.backgroundColor = _selectionIndicatorColor;
            itemBt.selected = YES;
        }else {
            itemBt.backgroundColor = [UIColor clearColor];
        }
        [itemBt addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:itemBt];
        
        
        if (i != _titles.count -1) {
            UIView *backView = [[UIView alloc] init];
            backView.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
            [_contentView addSubview:backView];
            
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(itemBt.mas_top).offset(2);
                make.left.equalTo(itemBt.mas_right);
                make.bottom.equalTo(itemBt.mas_bottom);
                make.width.mas_equalTo(1);
            }];
        }
        
    }
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor redColor];
    [_contentView addSubview:lineView];
    _lineView = lineView;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH/4-1, 2));
    }];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];
    oldItemBt.backgroundColor = [UIColor clearColor];
    oldItemBt.selected        = NO;
    
    UIButton * itemBt      = [_contentView viewWithTag:666 + selectedSegmentIndex];
    itemBt.backgroundColor = _selectionIndicatorColor;
    itemBt.selected        = YES;
    _selectedSegmentIndex  = selectedSegmentIndex;
}

- (void)didSelectedSegment:(UIButton *)itemBt {
    _selectedSegmentIndex  = itemBt.tag - 666;
    if (self.IndexChangeBlock) {
        self.IndexChangeBlock(_selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (_selectedSegmentIndex > 0) {  // 屏蔽后面的点击效果
        return;
    }
    
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];
    oldItemBt.backgroundColor = [UIColor clearColor];
    oldItemBt.selected        = NO;
    
    itemBt.backgroundColor = _selectionIndicatorColor;
    itemBt.selected        = YES;
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(self->_selectedSegmentIndex * kSCREEN_WIDTH/4, 0, kSCREEN_WIDTH/4-1, 2);
    }];
}

@end





