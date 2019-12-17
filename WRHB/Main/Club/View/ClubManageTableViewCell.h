//
//  ClubManageTableViewCell.h
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubManageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

/// 图片
@property (nonatomic, strong) UIImageView *headView;
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// 消息数量
@property (nonatomic, strong) UILabel *messageNumLabel;

@end

NS_ASSUME_NONNULL_END
