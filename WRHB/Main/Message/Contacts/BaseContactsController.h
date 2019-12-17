//
//  YPContactsController.h
//  Project
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFContactCell.h"
#import "YPContactsTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseContactsController : UIViewController<ContactCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YPContactsTableView *contactTableView;
@property (nonatomic, assign) TopIndexType selectedItemIndex;
@property (nonatomic, strong) NSMutableArray *groupArray;

@end

NS_ASSUME_NONNULL_END
