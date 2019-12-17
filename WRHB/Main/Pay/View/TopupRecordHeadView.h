//
//  TopupRecordHeadView.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


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

@interface TopupRecordHeadView : UIView

@property (nonatomic ,copy) TimeBlock beginChange;
@property (nonatomic ,copy) TimeBlock endChange;
@property (nonatomic ,copy) TypeBlock TypeChange;
@property (nonatomic ,copy) NSString *beginTime;
@property (nonatomic ,copy) NSString *endTime;
@property (nonatomic, strong) NSMutableArray *billTypeList;
@property (nonatomic, strong) UILabel *balanceLabel;
/// 累计金额
@property (nonatomic, strong) UILabel *allMoneyLabel;

@end



