//
//  YSTopupListCell.h
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSTopupListModel;

NS_ASSUME_NONNULL_BEGIN

@interface YSTopupListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;
/// 图片
@property (nonatomic, strong) YSTopupListModel *model;

@end

NS_ASSUME_NONNULL_END
