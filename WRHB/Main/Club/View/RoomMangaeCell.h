//
//  RoomMangaeCell.h
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class RoomMangaeModel;

typedef void(^RoomOpenBlock)(RoomMangaeModel *model);
typedef void(^RoomClosedBlock)(RoomMangaeModel *model);
typedef void(^RoomDeleteBlock)(RoomMangaeModel *model);


NS_ASSUME_NONNULL_BEGIN

@interface RoomMangaeCell : UITableViewCell
//
+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

// strong注释
@property (nonatomic, strong) RoomMangaeModel *model;

@property (nonatomic, copy) RoomOpenBlock roomOpenBlock;
@property (nonatomic, copy) RoomClosedBlock roomClosedBlock;
@property (nonatomic, copy) RoomDeleteBlock roomDeleteBlock;

@end

NS_ASSUME_NONNULL_END

