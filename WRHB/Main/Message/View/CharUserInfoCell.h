//
//  CharUserInfoCell.h
//  Project
//
//  Created by AFan on 2019/9/7.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class <#name#>

@interface CharUserInfoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// <#strong注释#>
@property (nonatomic, strong) id model;

@end

