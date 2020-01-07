//
//  ListView.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WithdrawBankModel;


typedef void(^ClubCancelBlock)(void);
typedef void(^ClubSelectBlock)(WithdrawBankModel *model);
NS_ASSUME_NONNULL_BEGIN

@interface ListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,  copy)ClubSelectBlock selectBlock;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

//关闭当前视图
@property (nonatomic, copy) ClubCancelBlock cancelBlock;

-(void)reload:(NSArray <NSString *>*)data;

-(void)observerSelected:(ClubSelectBlock)block;

@end

NS_ASSUME_NONNULL_END
