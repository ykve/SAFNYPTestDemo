//
//  ClubBillCell.h
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubBillModel;


NS_ASSUME_NONNULL_BEGIN

@interface ClubBillCell : UITableViewCell

/// 身份
@property (nonatomic, strong) UIButton *IDTypeBtn;
/// 操作
@property (nonatomic, strong) UIButton *operationTypeBtn;
//
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) ClubBillModel *model;

@end

NS_ASSUME_NONNULL_END
