//
//  ClubMemberCell.h
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubMemberModel;


typedef void(^MemberOperationTypeBlock)(ClubMemberModel *model, id cell);
typedef void(^MemberIDTypeBlock)(ClubMemberModel *model, id cell);

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberCell : UITableViewCell

/// 身份
@property (nonatomic, strong) UIButton *IDTypeBtn;
/// 操作
@property (nonatomic, strong) UIButton *operationTypeBtn;
//
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) ClubMemberModel *model;


@property (nonatomic, copy) MemberOperationTypeBlock memberOperationTypeBlock;
@property (nonatomic, copy) MemberIDTypeBlock memberIDTypeBlock;

@end

NS_ASSUME_NONNULL_END
