//
//  SearchCell.h
//  Project
//
//  Created by AFan on 2019/2/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^AddBtnBlock)(BaseUserModel *);


NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic ,copy) AddBtnBlock addBtnBlock;

///
@property (nonatomic, strong) BaseUserModel *model;

@end

NS_ASSUME_NONNULL_END
