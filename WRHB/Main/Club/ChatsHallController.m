//
//  ChatsHallController.m
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ChatsHallController.h"
#import "ChatsModel.h"
#import "ChatViewController.h"
#import "ClubManager.h"

@interface ChatsHallController ()

@end

@implementation ChatsHallController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self goto_Chat];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([ClubManager sharedInstance].isClickTabBar) {
        [ClubManager sharedInstance].isClickTabBar = NO;
        [self goto_Chat];
    }
}

#pragma mark - goto聊天界面
- (void)goto_Chat {
    ChatsModel *chatsModel = [[ChatsModel alloc] init];
    chatsModel.sessionId = [ClubManager sharedInstance].clubInfo.session;
    chatsModel.name = [ClubManager sharedInstance].clubInfo.title;
    chatsModel.sessionType = ChatSessionType_ManyPeople_NormalChat;
    ChatViewController *vc = [ChatViewController chatsFromModel:chatsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
