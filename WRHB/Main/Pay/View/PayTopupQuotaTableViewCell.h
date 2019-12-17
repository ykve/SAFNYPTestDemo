//
//  PayTopupQuotaTableViewCell.h
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayTopupModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupQuotaTableViewCell : UITableViewCell

/// 名称
@property (nonatomic, strong) UILabel *nameLabel;
///
@property (nonatomic, strong) UITextField *textField;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (strong, nonatomic) PayTopupModel *model;

@end

NS_ASSUME_NONNULL_END
