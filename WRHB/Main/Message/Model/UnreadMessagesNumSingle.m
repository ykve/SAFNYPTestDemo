//
//  UnreadMessagesNumSingle.m
//  WRHB
//
//  Created by AFan on 2019/12/29.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "UnreadMessagesNumSingle.h"

@implementation UnreadMessagesNumSingle
MJCodingImplementation


static UnreadMessagesNumSingle *sharedInstance = nil;
static dispatch_once_t onceToken;

+ (UnreadMessagesNumSingle *)sharedInstance
{
    
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            NSString *whereStr = [NSString stringWithFormat:@"userId='%ld'",(long)[AppModel sharedInstance].user_info.userId];
            NSArray *dataArray = [WHC_ModelSqlite query:[UnreadMessagesNumSingle class] where:whereStr];
            UnreadMessagesNumSingle *model = dataArray.firstObject;
            if (!model) {
                model = [[UnreadMessagesNumSingle alloc] init];
                model.userId = [AppModel sharedInstance].user_info.userId;
                model.weChatsUnReadAllCount = 0;
                model.weChatslastBadgeNum = 0;
                model.myMessageUnReadCount = 0;
                model.myMessagelastBadgeNum = 0;
                model.myFriendMessageNum = 0;
                model.sysMessageListNum = 0;
                model.clubAppltJoinNum = 0;
                BOOL isInsertSuccess = [WHC_ModelSqlite insert:model];
                if (!isInsertSuccess) {
                    NSLog(@"1");
                }
            }
            sharedInstance = model;
        }
        
        //        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

//+(instancetype)alloc{
//    NSAssert(0, @"这是一个单例对象，请使用+(UnreadMessagesNumSingle *)sharedInstance方法");
//    return nil;
//}
//+(instancetype)new {
//    return [self alloc];
//}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    return [self sharedInstance];
//}

- (id)copy
{
    NSLog(@"这是一个单例对象，copy将不起任何作用");
    return self;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}


- (void)setMyMessageUnReadCount:(NSInteger)myMessageUnReadCount {
    
    if (myMessageUnReadCount < 0) {
        self.weChatsUnReadAllCount -= _myMessageUnReadCount;
        _myMessageUnReadCount = 0;
        return;
    } else if (myMessageUnReadCount > 0 && myMessageUnReadCount > _myMessageUnReadCount) {
        self.weChatsUnReadAllCount += myMessageUnReadCount - _myMessageUnReadCount;
    } else if (myMessageUnReadCount > 0 && myMessageUnReadCount < _myMessageUnReadCount) {
        self.weChatsUnReadAllCount -= _myMessageUnReadCount - myMessageUnReadCount;
    } else {
        self.weChatsUnReadAllCount -= _myMessageUnReadCount - myMessageUnReadCount;
    }
    
    _myMessageUnReadCount = myMessageUnReadCount;
    
}

- (void)setMyFriendMessageNum:(NSInteger)myFriendMessageNum {
    if (myFriendMessageNum < 0) {
        self.weChatsUnReadAllCount -= _myFriendMessageNum;
        _myFriendMessageNum = 0;
        return;
    } else if (myFriendMessageNum > 0 && myFriendMessageNum > _myFriendMessageNum) {
        self.weChatsUnReadAllCount += myFriendMessageNum - _myFriendMessageNum;
    } else if (myFriendMessageNum > 0 && myFriendMessageNum < _myFriendMessageNum) {
        self.weChatsUnReadAllCount -= _myFriendMessageNum - myFriendMessageNum;
    } else {
        self.weChatsUnReadAllCount -= _myFriendMessageNum - myFriendMessageNum;
    }
    
    _myFriendMessageNum = myFriendMessageNum;
}


- (void)setSysMessageListNum:(NSInteger)sysMessageListNum {
    if (sysMessageListNum < 0) {
        self.weChatsUnReadAllCount -= _sysMessageListNum;
        _sysMessageListNum = 0;
        return;
    } else if (sysMessageListNum > 0 && sysMessageListNum > _sysMessageListNum) {
        self.weChatsUnReadAllCount += sysMessageListNum - _sysMessageListNum;
    } else if (sysMessageListNum > 0 && sysMessageListNum < _sysMessageListNum) {
        self.weChatsUnReadAllCount -= _sysMessageListNum - sysMessageListNum;
    } else {
        self.weChatsUnReadAllCount -= _sysMessageListNum - sysMessageListNum;
    }
    
    _sysMessageListNum = sysMessageListNum;
}

- (void)setWeChatsUnReadAllCount:(NSInteger)weChatsUnReadAllCount {
    
    BOOL isRefresh = NO;
    if (_weChatsUnReadAllCount != weChatsUnReadAllCount) {
        [self updateDBData];
        isRefresh = YES;
    }
    
    if (weChatsUnReadAllCount < 0) {
        _weChatsUnReadAllCount = 0;
    }
    _weChatsUnReadAllCount = weChatsUnReadAllCount;
    if (isRefresh) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarBadgeValueUpdateNotification object:nil];
    }
}


- (void)setClubAppltJoinNum:(NSInteger)clubAppltJoinNum {
    if (_clubAppltJoinNum != clubAppltJoinNum) {
        [self updateDBData];
    }
    _clubAppltJoinNum = clubAppltJoinNum;
}

- (void)updateDBData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *whereStr = [NSString stringWithFormat:@"userId='%ld'",(long)[AppModel sharedInstance].user_info.userId];
        BOOL isSuccess = [WHC_ModelSqlite update:self where:whereStr];
        if (!isSuccess) {
            [WHC_ModelSqlite removeModel:[UnreadMessagesNumSingle class]];
            BOOL isInsertSuccess = [WHC_ModelSqlite insert:self];
            if (!isInsertSuccess) {
                NSLog(@"1");
            }
        }
    });
}

/// 主动销毁  切换账号的时候
- (void)destoryInstance {
    onceToken = 0;
    sharedInstance = nil;
}

@end
