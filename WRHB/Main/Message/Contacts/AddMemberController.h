//
//  AddMemberController.h
//  WRHB
//
//  Created by AFan on 2019/2/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  添加 删除
 */
typedef NS_ENUM(NSInteger, AddType) {
    /// 添加好友
    AddType_Friend  = 1,
    /// 添加群成员
    AddType_GroupMember  = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface AddMemberController : UIViewController

@property (nonatomic, assign) AddType addType;
//
@property (nonatomic, assign) NSInteger groupId;

@end

NS_ASSUME_NONNULL_END
