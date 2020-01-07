//
//  HeadImageTopCell.h
//  WRHB
//
//  Created by AFan on 2019/12/24.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadImageTopCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;


///
@property (nonatomic, assign) NSInteger userId;

@end

NS_ASSUME_NONNULL_END
