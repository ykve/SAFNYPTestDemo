//
//  WitAlertTextCell.h
//  WRHB
//
//  Created by AFan on 2019/11/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WitAlertTextCell : UITableViewCell
/// 分割线
@property (nonatomic, strong) UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) id model;
@end

NS_ASSUME_NONNULL_END
