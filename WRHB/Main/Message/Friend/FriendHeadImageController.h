//
//  FriendHeadImageController.h
//  WRHB
//
//  Created by AFan on 2019/12/24.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChatsModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendHeadImageController : UIViewController
///
@property (nonatomic, assign) NSInteger userId;
// 会话模型
@property (nonatomic, strong) ChatsModel *chatsModel;

@end

NS_ASSUME_NONNULL_END
