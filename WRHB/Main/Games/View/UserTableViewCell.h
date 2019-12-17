//
//  UserTableViewCell.h
//  Project
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DeleteBtnBlock)(void);

@interface UserTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic ,copy) DeleteBtnBlock deleteBtnBlock;


@end
