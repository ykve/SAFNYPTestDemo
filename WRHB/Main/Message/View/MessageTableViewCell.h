//
//  MessageTableViewCell.h
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatsModel;

@interface MessageTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic,strong) ChatsModel *model;

@end
