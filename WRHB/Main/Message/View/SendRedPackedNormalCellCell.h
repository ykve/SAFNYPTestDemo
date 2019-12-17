//
//  SendRedPackedNormalCellCell.h
//  WRHB
//
//  Created by AFan on 2019/11/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendRedPackedNormalCellCell : UITableViewCell
///
@property (nonatomic, strong) UITextField *deTextField;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
