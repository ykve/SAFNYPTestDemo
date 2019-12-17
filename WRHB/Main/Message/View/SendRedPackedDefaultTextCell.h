//
//  SendRedPackedDefaultTextCell.h
//  WRHB
//
//  Created by AFan on 2019/10/19.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendRedPackedDefaultTextCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *deTextField;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIViewController *object;


@property (nonatomic, copy) NSString *money;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
