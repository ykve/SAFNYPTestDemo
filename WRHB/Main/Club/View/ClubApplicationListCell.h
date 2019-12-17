//
//  ClubApplicationListCell.h
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ClubInitiator;

typedef void(^MemberRejectBlock)(ClubInitiator *model);
typedef void(^MemberPassBlock)(ClubInitiator *model);

NS_ASSUME_NONNULL_BEGIN

@interface ClubApplicationListCell : UITableViewCell

/// 身份
@property (nonatomic, strong) UIButton *rejectBtn;
/// 通过
@property (nonatomic, strong) UIButton *passButton;
//
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) ClubInitiator *model;


@property (nonatomic, copy) MemberRejectBlock memberRejectBlock;
@property (nonatomic, copy) MemberPassBlock memberPassBlock;
@end

NS_ASSUME_NONNULL_END
