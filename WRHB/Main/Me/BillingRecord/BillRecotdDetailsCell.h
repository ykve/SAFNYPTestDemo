//
//  BillRecotdDetailsCell.h
//  WRHB
//
//  Created by AFan on 2019/12/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillRecotdDetailsCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// des
@property (nonatomic, strong) UILabel *desLabel;

@end

NS_ASSUME_NONNULL_END
