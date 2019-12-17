//
//  UpdateGroupInfoController.h
//  WRHB
//
//  Created by AFan on 2019/11/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionInfoModel;
@class ChatsModel;

NS_ASSUME_NONNULL_BEGIN

@interface UpdateGroupInfoController : UIViewController

@property (nonatomic, strong) ChatsModel *model;
/// 会话信息
@property (nonatomic, strong) SessionInfoModel *sessionModel;

@end

NS_ASSUME_NONNULL_END
