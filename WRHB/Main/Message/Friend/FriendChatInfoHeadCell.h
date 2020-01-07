//
//  FriendChatInfoHeadCell.h
//  WRHB
//
//  Created by AFan on 2019/6/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPContacts.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendChatInfoHeadCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) YPContacts *contacts;

@end

NS_ASSUME_NONNULL_END
