//
//  RecommendCell.h
//  WRHB
//
//  Created by AFan on 2019/11/2.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sub_Users;

@interface SubUserCell : UITableViewCell
@property (nonatomic, strong) UIButton *detailButton;
///
@property (nonatomic, strong) Sub_Users *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;


@end
