//
//  GroupInfoViewController.h
//  Project
//
//  Created by AFan on 2019/11/9.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatsModel;
@class SessionInfoModel;

@interface GroupInfoViewController : UIViewController

+ (GroupInfoViewController *)groupVc:(ChatsModel *)model;

/// 会话信息
@property (nonatomic, strong) SessionInfoModel *sessionModel;

@end
