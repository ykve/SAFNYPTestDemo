//
//  SysMessageListCell.h
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SysMessageListModel;

NS_ASSUME_NONNULL_BEGIN

@interface SysMessageListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) SysMessageListModel *model;
///
@property (nonatomic, assign) BOOL isShowSelectImg;


@end

NS_ASSUME_NONNULL_END


