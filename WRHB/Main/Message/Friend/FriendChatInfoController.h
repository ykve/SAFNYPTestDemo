//
//  FriendChatInfoController.h
//  WRHB
//
//  Created by AFan on 2019/6/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YPContacts;
@class ChatsModel;
NS_ASSUME_NONNULL_BEGIN

@interface FriendChatInfoController : UIViewController

//
@property (nonatomic, strong) YPContacts *contacts;
// 会话模型
@property (nonatomic, strong) ChatsModel *chatsModel;

@end

NS_ASSUME_NONNULL_END
