//
//  MyFriendMessageListCell.h
//  WRHB
//
//  Created by AFan on 2019/6/21.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YPContacts;

NS_ASSUME_NONNULL_BEGIN

@interface MyFriendMessageListCell : UITableViewCell

///
@property (nonatomic, assign) NSInteger sessionId;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) YPContacts *model;

@end

NS_ASSUME_NONNULL_END
