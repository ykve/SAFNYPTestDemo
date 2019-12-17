//
//  CServiceChatController.h
//  WRHB
//
//  Created by AFan on 2019/11/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CServiceIMSessionMessageController.h"

@class MessageItem;
@class YPContacts;
@class ChatsModel;
@class GamesTypeModel;

@interface CServiceChatController : CServiceIMSessionMessageController

//
+ (CServiceChatController *)chatsFromModel:(ChatsModel *)model;

//
+ (CServiceChatController *)currentChat;
@property (nonatomic, strong) GamesTypeModel *gamesTypeModel;

@property (weak, nonatomic)id <AFReceiveMessageDelegate> receiveMessageDelegate;


@end

