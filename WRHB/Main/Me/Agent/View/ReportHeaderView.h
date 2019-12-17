//
//  BillHeadView.h
//  Project
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TimeBlock)(id);
typedef void (^TypeBlock)(NSInteger type);

@interface ReportHeaderView : UIView<UIActionSheetDelegate>

+ (ReportHeaderView *)headView;

@property (nonatomic ,copy) TimeBlock beginChange;
@property (nonatomic ,copy) TimeBlock endChange;
@property (nonatomic ,copy) NSString *beginTime;
@property (nonatomic ,copy) NSString *endTime;

@end
