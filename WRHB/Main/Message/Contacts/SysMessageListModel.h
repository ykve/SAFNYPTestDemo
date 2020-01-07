//
//  SysMessageListModel.h
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SysMessageListModel : NSObject
///
@property (nonatomic, assign) NSInteger userId;
///
@property (nonatomic, assign) NSInteger type;
///
@property (nonatomic, copy) NSString *title;
///
@property (nonatomic, copy) NSString *content;
///
@property (nonatomic, assign) NSInteger updateTime;
///
@property (nonatomic, assign) NSInteger isReaded;
///
@property (nonatomic, assign) NSInteger isSelected;

@end

NS_ASSUME_NONNULL_END
