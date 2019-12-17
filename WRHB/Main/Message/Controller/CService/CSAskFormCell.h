//
//  CSAskFormCell.h
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kCSAskFormCellIdentifier = @"CSAskFormCellIdentifier";


NS_ASSUME_NONNULL_BEGIN

@interface CSAskFormCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

/// index  带点 .
@property (nonatomic, strong) UILabel *indexLabel;
/// title
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END

