//
//  ContactCell.h
//  Project
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPContacts.h"

@protocol ContactCellDelegate <NSObject>

- (void)cellAddFriendBtnIndex:(NSInteger)index model:(YPContacts *)model;

@end


@interface AFContactCell : UITableViewCell


@property (weak, nonatomic) id<ContactCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

///
@property (nonatomic, assign) BOOL isShowSelectView;
///
@property (nonatomic, strong) YPContacts *model;
///
@property (nonatomic, assign) TopIndexType topIndex;

@end
