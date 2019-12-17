//
//  PayTopupWebViewCell.h
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CellWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupWebViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (strong, nonatomic) NSMutableArray *dataArray;
/// 
@property (nonatomic, strong) CellWebViewController *webView;

@end

NS_ASSUME_NONNULL_END
