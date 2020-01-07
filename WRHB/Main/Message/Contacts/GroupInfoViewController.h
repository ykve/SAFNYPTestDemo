//
//  GroupInfoViewController.h
//  WRHB
//
//  Created by AFan on 2019/11/9.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatsModel;
@class SessionInfoModels;

@interface GroupInfoViewController : UIViewController

+ (GroupInfoViewController *)groupVc:(ChatsModel *)model;

/// 会话信息
@property (nonatomic, strong) SessionInfoModels *sessionModel;

@end
