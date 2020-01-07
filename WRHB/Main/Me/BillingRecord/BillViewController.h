//
//  BillViewController.h
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillTypeModel;

@interface BillViewController : UIViewController

/// 来源类型  1 Me 红包游戏  2 账单记录
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) BillTypeModel *billTypeModel;

@end
