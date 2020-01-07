//
//  BasePayTopUpController.h
//  WRHB
//
//  Created by John on 2020/1/5.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasePayTopUpController : UIViewController
/// 表单
@property (nonatomic, strong) UITableView *tableView;

/// 数据源
@property (strong, nonatomic) NSMutableArray *dataArray;

///占位图 如果无数据
@property (nonatomic, strong) UIView *placeholderView;
///显示占位图
-(void)showPlaceholderDefaultView;

@end

NS_ASSUME_NONNULL_END
