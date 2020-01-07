//
//  RedPackedDetTableCell.j
//  WRHB
//
//  Created by AFan on 2019/9/3.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GrabPackageInfoModel;

@interface RedPackedDetTableCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

/** 红包类型, 1: 竞抢, 2: 牛牛 */
@property(nonatomic, readwrite) RedPacketType redpacketType;

// strong注释
@property (nonatomic,strong) GrabPackageInfoModel *model;

@end
