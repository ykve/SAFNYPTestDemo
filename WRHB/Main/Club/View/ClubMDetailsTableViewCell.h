//
//  ClubMDetailsTableViewCell.h
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubMemberDetailsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ClubMDetailsTableViewCell : UITableViewCell

//
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) ClubMemberDetailsListModel *model;

@end

NS_ASSUME_NONNULL_END
