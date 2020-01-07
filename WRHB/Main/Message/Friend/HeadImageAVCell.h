//
//  HeadImageAVCell.h
//  WRHB
//
//  Created by AFan on 2019/12/24.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadImageAVCell : UITableViewCell
@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;
@end

NS_ASSUME_NONNULL_END
