//
//  PayTopupRecordCell.h
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BillItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupRecordCell : UITableViewCell
@property (nonatomic, strong) UIButton *seeDetBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) BillItemModel *model;

@property(nonatomic,copy)void(^onSeeDetailsBlock)(BillItemModel *model);
@end

NS_ASSUME_NONNULL_END
