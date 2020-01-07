//
//  AllUserViewController.h
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatsModel;
@class SessionInfoModels;

// 群成员控制器
@interface AllUserViewController : UIViewController

// 群ID
@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, assign) BOOL isDelete;
+ (AllUserViewController *)allUser:(id)obj;


@property (nonatomic, strong) ChatsModel *chatsModel;
/// 会话信息
@property (nonatomic, strong) SessionInfoModels *sessionModel;

@end
