//
//  GroupHeadView.h
//  Project
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SessionInfoModel;

typedef void (^HeadAddOrDeleteClick)(NSInteger index);

@interface GroupHeadView : UIView

// 0 为 添加  1 删除  其它为全部成员
@property (nonatomic, copy) HeadAddOrDeleteClick headAddOrDeleteClick;
// 是否群主
@property (nonatomic ,assign) BOOL isGroupLord;

/// model   数据模型
/// showRow  默认3行
/// isGroupLord  是否群主
+ (GroupHeadView *)headViewWithModel:(SessionInfoModel *)model showRow:(NSInteger)showRow isGroupLord:(BOOL)isGroupLord;


@end
