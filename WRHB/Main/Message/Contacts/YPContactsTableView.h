//
//  ContactsTableView.h
//  WRHB
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTableViewDelegate;



@interface YPContactsTableView : UIView

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) id<ContactsTableViewDelegate> delegate;
- (void)reloadData;


@end

@protocol ContactsTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSArray *)sectionIndexTitlesForABELTableView:(YPContactsTableView *)tableView;


@end
