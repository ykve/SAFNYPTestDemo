//
//  MeTableViewCell.h
//  WRHB
//
//  Created by AFan on 2019/10/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeTableViewCell : UITableViewCell

/// 特殊标记
@property (nonatomic, assign) NSInteger unusualMarkIndex;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) id model;

@end

NS_ASSUME_NONNULL_END
