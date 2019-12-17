//
//  BillTableViewCell.h
//  Project
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BillItemModel;

@interface BillTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *seeDetBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) BillItemModel *model;

@property(nonatomic,copy)void(^onSeeDetailsBlock)(BillItemModel *model);

@end
