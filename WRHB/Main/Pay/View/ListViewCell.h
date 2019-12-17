//
//  ListViewCell.h
//  WRHB
//
//  Created by AFan on 2019/10/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@class BankModel;

@interface ListViewCell : UITableViewCell

/// 名称
@property (nonatomic, strong) UILabel *titleLabel;
/// 说明
@property (nonatomic, strong) UILabel *desLabel;
/// 选中
@property (nonatomic, strong) UIImageView *selectImageView;


+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) BankModel *model;

@end

NS_ASSUME_NONNULL_END
