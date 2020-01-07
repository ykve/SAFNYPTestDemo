//
//  WitAlertHeaderView.h
//  WRHB
//
//  Created by AFan on 2019/11/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVAlertModel.h"

@class WitAlertHeaderView;

@protocol WitAlertHeaderViewDelegate <NSObject>

- (void)WitAlertHeaderViewDidClickBtn:(WitAlertHeaderView *)headerView;

@end

@interface WitAlertHeaderView : UITableViewHeaderFooterView
//代理属性
@property (nonatomic, assign) id<WitAlertHeaderViewDelegate>delegate;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) VVAlertModel *groupModel;

@property (nonatomic, assign) BOOL isExpend;

+ (instancetype)VVAlertGroupHeaderViewWithTableView:(UITableView *)tableView;

@end
