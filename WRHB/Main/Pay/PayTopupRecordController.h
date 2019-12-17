//
//  PayTopupRecordController.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillTypeModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupRecordController : UIViewController
/// 来源类型  1 Me 红包游戏  2 账单记录
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) BillTypeModel *billTypeModel;

@end

NS_ASSUME_NONNULL_END
