//
//  ClubHomeCell.h
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ClubHomeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;


@end

NS_ASSUME_NONNULL_END
