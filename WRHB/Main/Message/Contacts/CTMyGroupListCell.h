//
//  CTMyGroupListCell.h
//  WRHB
//
//  Created by AFan on 2019/11/21.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatsModel;

NS_ASSUME_NONNULL_BEGIN

@interface CTMyGroupListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) ChatsModel *model;

@end

NS_ASSUME_NONNULL_END
