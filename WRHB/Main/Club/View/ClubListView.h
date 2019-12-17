//
//  ListView.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectBlock)(NSString *data);
NS_ASSUME_NONNULL_BEGIN

@interface ClubListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) SelectBlock block;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
/// 字体颜色
@property (nonatomic, strong) UIColor *textColor;
/// 字体大小
@property (nonatomic, assign) CGFloat fontSize;
/// 默认50 
@property (nonatomic, assign) CGFloat cellHeight;


-(void)reload:(NSArray <NSString *>*)data;

-(void)observerSelected:(SelectBlock)block;

@end

NS_ASSUME_NONNULL_END
