//
//  EnvelopeTipCell.m
//  WRHB
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "EnvelopeTipCell.h"

@implementation EnvelopeTipCell
//+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
+ (CGSize)sizeForMessageModel:(id *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight
{
    CGFloat __messagecontentview_height = 15.0f;
    __messagecontentview_height += extraHeight;
    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Data
- (void)initData{
//    self.allowsSelection = NO;
}


#pragma mark - Layout
- (void)initLayout{
//    self.tipLabel.frame = self.baseContentView.bounds;
}

#pragma mark - subView
- (void)setupSubViews{
    self.tipLabel = [UILabel new];
//    [self.baseContentView addSubview:self.tipLabel];
    
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = @"xsdas领取了你的红包";
    self.tipLabel.font = [UIFont systemFontOfSize2:14];
}

//- (void)setDataModel:(RCMessageModel *)model{
    - (void)setDataModel:(id *)model{
//    [super setDataModel:model];
    
    
    [self initLayout];
}


@end
