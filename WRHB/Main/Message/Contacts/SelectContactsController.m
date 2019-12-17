//
//  SelectContactsController.m
//  WRHB
//
//  Created by AFan on 2019/11/11.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SelectContactsController.h"
#import "YPContacts.h"
#import "AFContactCell.h"
#import "BaseUserModel.h"

@interface SelectContactsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *haoyouArray;
@property (nonatomic, strong) NSMutableArray *indexTitles;

@property (nonatomic, strong) UILabel *confirmDeleteLabel;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray *selectedArr;



@end

@implementation SelectContactsController

- (UILabel *)confirmDeleteLabel {
    if (!_confirmDeleteLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"确认删除";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:250/255.0 green:62/255.0 blue:56/255.0 alpha:1];
        label.userInteractionEnabled = YES;
        _confirmDeleteLabel = label;
    }
    return _confirmDeleteLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.navigationItem.title isEqualToString:@"删除成员"]) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (BaseUserModel *model in self.addedArray) {
            if (model.userId == [AppModel sharedInstance].user_info.userId) {
                continue;
            }
            YPContacts *con = [[YPContacts alloc] init];
            con.user_id = model.userId;
            con.name = model.name;
            con.avatar = model.avatar;
            [tempArray addObject:con];
        }
        [self.haoyouArray addObject:tempArray];
    } else {
        [self queryContactsData];
    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [UIView new];
    
    for (UIGestureRecognizer *ges in self.tableView.gestureRecognizers) {
        if ([ges isKindOfClass:NSClassFromString(@"_UISwipeActionPanGestureRecognizer")]) {
            [ges addTarget:self action:@selector(_swipeRecognizerDidRecognize:)];
        }
    }
    
    // 左边图片和文字
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.userInteractionEnabled = NO;
    _doneButton = doneButton;
    doneButton.layer.cornerRadius = 3;
    self.doneButton.backgroundColor = [UIColor lightGrayColor];
    //    doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
    doneButton.frame = CGRectMake(0, 0, 56, 32);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [doneButton addTarget:self action:@selector(beginToSelectFile:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
}



#pragma mark -  查询通讯录数据
/**
 查询通讯录数据
 */
- (void)queryContactsData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/friends"];
    entity.needCache = NO;
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf loadLocalData:[response objectForKey:@"data"]];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)loadLocalData:(NSDictionary *)dataDict
{
    
    NSArray *subordinateArray = (NSArray *)[dataDict objectForKey:@"subUsers"];   // 我邀请的人
    NSArray *friendsArray = (NSArray *)[dataDict objectForKey:@"friends"];   // 我的好友
    
    
    // ******** 邀请我的好友 + 好友申请 + 我推荐的好友 ********
    NSMutableArray *superiorArrayTemp = [[NSMutableArray alloc] init];
    YPContacts *superiorModel = [YPContacts mj_objectWithKeyValues:[dataDict objectForKey:@"recommend"]];  // 邀请我的人
    superiorModel.contactsType = FriendType_Super;
    if (superiorModel) {
        [superiorArrayTemp addObject:superiorModel];
    }
    
    if (superiorArrayTemp.count > 0) {
        [self.haoyouArray addObject:superiorArrayTemp];
        [self.indexTitles addObject:@"邀请我的好友"];  // 邀请我的好友
    }
    
    
    // ****** 我邀请的好友 ******
    NSMutableArray *subordinateArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < subordinateArray.count; i++) {
        YPContacts *contact = [[YPContacts alloc] initWithPropertiesDictionary:subordinateArray[i]];
        contact.contactsType = FriendType_Sub;
        [subordinateArraytemp addObject:contact];
    }
    if (subordinateArray.count > 0) {
        [self.haoyouArray addObject:subordinateArraytemp];
        [self.indexTitles addObject:@"我邀请的好友"]; // 我邀请的好友
    }
    
    // ******** 正常好友 游戏好友 ********
    NSMutableArray *friendsArraytemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < friendsArray.count; i++) {
        YPContacts *contact = [[YPContacts alloc] initWithPropertiesDictionary:friendsArray[i]];
        contact.contactsType = FriendType_Normal;
        [friendsArraytemp addObject:contact];
    }
    
    if (friendsArraytemp.count > 0) {
        [self.haoyouArray addObject:friendsArraytemp];
        [self.indexTitles addObject:@"游戏好友"];
    }
    
    // 是否已添加
    for (BaseUserModel *model in self.addedArray) {
        for (NSInteger i = 0; i < self.haoyouArray.count; i++) {
            NSArray *arr = self.haoyouArray[i];
            for (NSInteger iy = 0; iy < arr.count; iy++) {
                YPContacts *con = arr[iy];
                if (model.userId == con.user_id) {
                    con.isAdded = YES;
                }
            }
        }
    }
    
    [self.tableView reloadData];
}



#pragma mark -  完成 添加成员 | 删除成员
- (void)beginToSelectFile:(UIBarButtonItem *)rightItem{
    //    NSString *itemTitle = rightItem.title;
    //    self.selectedArr = [NSMutableArray array];
    //    [self.tableView setEditing:YES animated:YES];
    //    rightItem.title = @"完成";
    //    [self addNavLeftItemWithTitle:@"全选" andSeloctor:@selector(setSelectAllFile)];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (YPContacts *con in self.selectedArr) {
        [arr addObject:@(con.user_id)];
    }
    
    NSDictionary *parameters = @{
                                 @"session":@(self.sessionId),
                                 @"user":arr
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    if ([self.navigationItem.title isEqualToString:@"删除成员"]) {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/removeUser"];
    } else {
        entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/addUser"];
    }
    
    entity.needCache = NO;
    entity.parameters  = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            [MBProgressHUD showTipMessageInWindow:response[@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadMyMessageGroupList object:nil];
            [strongSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
}

- (void)addNavLeftItemWithTitle:(NSString *)title andSeloctor:(SEL)selector{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setSelectAllFile {
    [self addNavLeftItemWithTitle:@"取消全选" andSeloctor:@selector(setCancelSelectAllFile)];
    
    for (int zzi = 0; zzi< self.haoyouArray.count; zzi++) {
        for (int i = 0; i< [self.haoyouArray[zzi] count]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:zzi];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
    
    
    if (self.selectedArr.count >0) {
        [self.selectedArr removeAllObjects];
    }
    [self.selectedArr addObjectsFromArray:self.haoyouArray];
    
}

- (void)setCancelSelectAllFile{
    
    for (int i = 0; i< self.haoyouArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    [self.selectedArr removeAllObjects];
    [self addNavLeftItemWithTitle:@"全选" andSeloctor:@selector(setSelectAllFile)];
}

- (void)_swipeRecognizerDidRecognize:(UISwipeGestureRecognizer *)swipe{
    if (_confirmDeleteLabel.superview) {
        [_confirmDeleteLabel removeFromSuperview];
        _confirmDeleteLabel = nil;
    }
}

#pragma mark - UITableViewDelegate

// 设置头部title行高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.indexTitles.count > 0) {
        return [self.indexTitles objectAtIndex:section] ? 20 : 0.0001;
    } else {
        return 0.0001;
    }
    
}
// 设置头部title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.indexTitles.count > 0) {
        return [self.indexTitles objectAtIndex:section] ? [self.indexTitles objectAtIndex:section] : @"";
    } else {
        return @"";
    }
}

// 设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.haoyouArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.haoyouArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ContactCell";
    
    AFContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [AFContactCell cellWithTableView:tableView reusableId:CellIdentifier];
    }
    cell.isShowSelectView = YES;
//    cell.delegate = self;
    YPContacts *contact = (YPContacts *)[[self.haoyouArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    contact.isSelected = NO;
    for (YPContacts *model in self.selectedArr) {
        if (contact.user_id == model.user_id) {
            contact.isSelected = YES;
            break;
        }
    }
    cell.model = contact;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BOOL isContains = NO;
    YPContacts *contact = (YPContacts *)[[self.haoyouArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (contact.isAdded) {  // 已添加
        return;
    }
    for (NSInteger index = 0; index < self.selectedArr.count; index++) {
        YPContacts *con = self.selectedArr[index];
        if (con.user_id == contact.user_id) {
            [self.selectedArr removeObject:con];
            isContains = YES;
        }
    }
    if (!isContains) {
        YPContacts *contModel = self.haoyouArray[indexPath.section][indexPath.row];
        contModel.isSelected = YES;
        [self.selectedArr addObject:contModel];
    }
    
    if (self.selectedArr.count > 0) {
        self.doneButton.userInteractionEnabled = YES;
        self.doneButton.backgroundColor = [UIColor colorWithRed:0.027 green:0.757 blue:0.376 alpha:1.000];
        [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%zd)", self.selectedArr.count] forState:UIControlStateNormal];
    } else {
        self.doneButton.userInteractionEnabled = NO;
        self.doneButton.backgroundColor = [UIColor lightGrayColor];
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    YPContacts *contModel = self.haoyouArray[indexPath.section][indexPath.row];
    [self.selectedArr removeObject:contModel];
    if (self.selectedArr.count == 0) {
        
    }else{
        
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//API_AVAILABLE(ios(11.0))
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.confirmDeleteLabel.superview) {
            [self.haoyouArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } else {
            NSLog(@"显示确认删除Label");
            // 核心代码
            UIView *rootView = nil; // 这个rootView指的是UISwipeActionPullView，最上层的父view
            if ([sourceView isKindOfClass:[UILabel class]]) {
                rootView = sourceView.superview.superview;
                self.confirmDeleteLabel.font = ((UILabel *)sourceView).font;
            }
            self.confirmDeleteLabel.frame = CGRectMake(sourceView.bounds.size.width, 0, sourceView.bounds.size.width, sourceView.bounds.size.height);
            [sourceView.superview.superview addSubview:self.confirmDeleteLabel];
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect labelFrame = self.confirmDeleteLabel.frame;
                labelFrame.origin.x = 0;
                labelFrame.size.width = rootView.bounds.size.width;
                self.confirmDeleteLabel.frame = labelFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    }];
    
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"更多" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        if (self.confirmDeleteLabel.superview) {
            [self.haoyouArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        } else {
            NSLog(@"更多");
        }
        
    }];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,moreAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//  在这个代理方法里，可以获取左滑按钮，进而修改其文字颜色，大小等
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"将要开始编辑cell");
    
    for (UIView *subView in tableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            for (UIView *childView in subView.subviews) {
                if ([childView isKindOfClass:NSClassFromString(@"UISwipeActionStandardButton")]) {
                    UIButton *button = (UIButton *)childView;
                    button.titleLabel.font = [UIFont systemFontOfSize:18];
                }
            }
        }
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    //    header.contentView.backgroundColor= [UIColor whiteColor];
    [header.textLabel setTextColor:[UIColor colorWithHex:@"#333333"]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"已经结束编辑cell");
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self showAlertWithTitle:@"点击了详情按钮"];
}

- (void)showAlertWithTitle:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)haoyouArray {
    if (!_haoyouArray) {
        _haoyouArray = [NSMutableArray array];
    }
    return _haoyouArray;
}
- (NSMutableArray *)indexTitles {
    if (!_indexTitles) {
        _indexTitles = [NSMutableArray array];
    }
    return _indexTitles;
}
- (NSMutableArray *)selectedArr {
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

@end

