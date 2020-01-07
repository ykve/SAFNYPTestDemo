//
//  ContactsTableView.m
//  WRHB
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YPContactsTableView.h"
#import "ContactsTableViewIndex.h"

@interface YPContactsTableView()<ContactsTableViewIndexDelegate>

@property (nonatomic, strong) ContactsTableViewIndex * tableViewIndex;

@end

@implementation YPContactsTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        [self addSubview:self.tableView];
        
        self.tableViewIndex = [[ContactsTableViewIndex alloc] initWithFrame:(CGRect){self.bounds.size.width - 20, 0, 20, frame.size.height-0}];
        [self addSubview:self.tableViewIndex];
        
    }
    return self;
}

- (void)setDelegate:(id<ContactsTableViewDelegate>)delegate
{
    _delegate = delegate;
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexTitlesForABELTableView:)]) {
        self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    }
    
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height = self.tableViewIndex.indexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height) / 2;
    self.tableViewIndex.frame = rect;
    
    self.tableViewIndex.tableViewIndexDelegate = self;
}

- (void)reloadData
{
    [self.tableView reloadData];
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexTitlesForABELTableView:)]) {
        self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    }
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height = self.tableViewIndex.indexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top + 20;
    self.tableViewIndex.frame = rect;
    self.tableViewIndex.tableViewIndexDelegate = self;
    self.tableView.tableFooterView = nil;
}


//#pragma mark -
- (void)tableViewIndex:(ContactsTableViewIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title
{
    if ([self.tableView numberOfSections] > index){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }

}

- (void)tableViewIndexTouchesBegan:(ContactsTableViewIndex *)tableViewIndex
{
}

- (void)tableViewIndexTouchesEnd:(ContactsTableViewIndex *)tableViewIndex
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    
}

- (NSArray *)tableViewIndexTitle:(ContactsTableViewIndex *)tableViewIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionIndexTitlesForABELTableView:)]) {
        self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForABELTableView:self];
    }
    return nil;
}


@end
