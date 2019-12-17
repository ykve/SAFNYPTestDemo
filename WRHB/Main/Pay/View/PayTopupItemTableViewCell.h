//
//  PayTopupItemTableViewCell.h
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayTopupModel;

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupItemTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) PayTopupModel *model;

@end

NS_ASSUME_NONNULL_END
