//
//  ChatViewController.h
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

//#import <RongIMKit/RongIMKit.h>
#import "IMSessionMessageController.h"
@class MessageItem;
@class YPContacts;
@class ChatsModel;
@class GamesTypeModel;

@interface ChatViewController : IMSessionMessageController

//
+ (ChatViewController *)chatsFromModel:(ChatsModel *)model;

//
+ (ChatViewController *)currentChat;
@property (nonatomic, strong) GamesTypeModel *gamesTypeModel;

@property (weak, nonatomic)id <AFReceiveMessageDelegate> receiveMessageDelegate;


@end
