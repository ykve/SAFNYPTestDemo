

//
//  MessageNet.m
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "SessionSingle.h"
#import "MessageItem.h"
#import "MessageSingle.h"
#import "ChatsModel.h"
#import "PushMessageNumModel.h"

@implementation SessionSingle

static SessionSingle *instance = nil;
static dispatch_once_t predicate;

+ (SessionSingle *)sharedInstance {
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allDataList = [[NSMutableArray alloc]init];
        _page = 0;
        _pageSize = 15;
        _isNoMore = YES;
        _isEmpty = YES;
        _isNoMoreMyJoin = YES;
        _isEmptyMyJoin = YES;
        _isOnce = YES;
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [self getMyJoinedSessionListSuccessBlock:nil failureBlock:nil];
//        });
    }
    return self;
}

- (NSArray *)localList {
    ChatsModel *service_model = [[ChatsModel alloc] init];
    service_model.sessionType = ChatSessionType_CustomerService;
    service_model.sessionId = kCustomerServiceID;
    service_model.name = @"在线客服";
    service_model.avatar = @"105";
    service_model.isJoinChatsList = YES;
    [_mySessionListData addObject:service_model];
    return @[service_model];
}


/**
 保存我的聊天列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)saveMyChatsListSuccessBlock:(void (^)(NSDictionary *))successBlock
                      failureBlock:(void (^)(NSError *))failureBlock {
    
    NSString *query = @"select * from PushMessageNumModel where chatSessionType == 1 or chatSessionType == 2 or chatSessionType == 3  group by sessionId  order by isTopTime desc,create_time desc";
    
    NSArray *chatsArray = [WHC_ModelSqlite query:[PushMessageNumModel class] sql:query];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSInteger index =0; index < chatsArray.count; index++) {
        PushMessageNumModel *pushModel = chatsArray[index];
        [tmpArray addObject:@(pushModel.sessionId)];
    }
    NSDictionary *parameters = @{
                                 @"content":tmpArray
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/save"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"get 获取我的聊天列表 请求数据结果： *** %@", response);
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSLog(@"保存聊天列表成功");
        }
        if (successBlock) {
            successBlock(response);
        }
        
    } failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } progressBlock:nil];
}



/**
 获取我的聊天列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyChatsListSuccessBlock:(void (^)(NSDictionary *))successBlock
                     failureBlock:(void (^)(NSError *))failureBlock {
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/list"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"get 获取我的聊天列表 请求数据结果： *** %@", response);
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.isCache = NO;
//            [strongSelf handleGroupListData:response[@"data"] andIsJoinChatsList:YES];
        }
        if (successBlock) {
            successBlock(response);
        }
    } failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } progressBlock:nil];
}






/**
 获取我加入的会话
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyJoinedSessionListSuccessBlock:(void (^)(NSDictionary *))successBlock
                           failureBlock:(void (^)(NSError *))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/mines"];
    entity.needCache = NO;
    
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        self.isCache = YES;
        [self handleGroupListData:cacheJson andIsJoinChatsList:YES];
        if (successBlock) {
            successBlock(cacheJson);
        }
    } else {
        /*! 回到主线程刷新UI */
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD showActivityMessageInWindow:nil];
//        });
        
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//                NSLog(@"get 获取我加入的会话 请求数据结果： *** %@", response);
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            strongSelf.isCache = NO;
             [strongSelf handleGroupListData:response[@"data"] andIsJoinChatsList:YES];
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
            }];
        }
        if (successBlock) {
            successBlock(response);
        }
        
        
    } failureBlock:^(NSError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    } progressBlock:nil];
}


/**
 获取所有会话列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getAllSessionListWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(id))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/repacket/groups"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"status"]integerValue]==1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //        NSLog(@"get 请求数据结果： *** %@", response);
            strongSelf.isCache = NO;
            [strongSelf handleGroupListData:response[@"data"] andIsJoinChatsList:NO];
            successBlock(response);
            
        }else{
            self.isNetError = YES;
            self.isEmpty = NO;
            [[AFHttpError sharedInstance] handleFailResponse:response];
            failureBlock(response);
        }
        
        
    } failureBlock:^(id object) {
        self.isNetError = YES;
        self.isEmpty = NO;
        [[AFHttpError sharedInstance] handleFailResponse:object];
        failureBlock(object);
    } progressBlock:nil];
}


-(void)handleGroupListData:(NSArray *)dataArray andIsJoinChatsList:(BOOL)isJoinChatsList {
    if (dataArray != NULL && [dataArray isKindOfClass:[NSArray class]]) {
        self.isNetError = NO;
        
        if (isJoinChatsList) {
            self.mySessionListData = [[NSMutableArray alloc]initWithArray:self.localList];
            self.mySessionListDictData = [NSMutableDictionary dictionary];
            NSInteger myNumCount = 0;
            NSMutableArray *marray = [NSMutableArray array];
            for (id item in dataArray) {
                ChatsModel *model = [ChatsModel mj_objectWithKeyValues:item];
                
                if (model.sessionType == ChatSessionType_SystemRoom  || model.sessionType == ChatSessionType_ManyPeople_Game || model.sessionType == ChatSessionType_BigUnion) {
                    if (!self.isCache) {
                        // 退群
                        [self exitGroupRequest:model.sessionId];
                    }
                    continue;
                }
                
                model.isJoinChatsList = isJoinChatsList;
                NSString *queryId = [NSString stringWithFormat:@"%zd_%ld",model.sessionId,[AppModel sharedInstance].user_info.userId];
                PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
                myNumCount += pmModel.number;
                
                [self.mySessionListData addObject:model];
                [self.mySessionListDictData setValue:model forKey:queryId];
                
                // 保存群ID
                [marray addObject:@(model.sessionId)];
            }
//            [UnreadMessagesNumSingle sharedInstance].myMessageUnReadCount = myNumCount;
            if (self.isOnce) {   // 启动后第一次请求需要发一次通知  用来判断接收 消息
                self.isOnce = NO;
                //                [[NSNotificationCenter defaultCenter] postNotificationName:kDoneGetMyJoinedGroupsNotification object:nil];
            }
            
            self.isEmptyMyJoin = (self.mySessionListData.count == 0)?YES:NO;
            self.isNoMoreMyJoin = ((self.mySessionListData.count % self.pageSize == 0)&(dataArray.count>0))?NO:YES;
        }else{
            self.allDataList = [[NSMutableArray alloc] init];
            for (id item in dataArray) {
                ChatsModel *model = [ChatsModel mj_objectWithKeyValues:item];
                model.isJoinChatsList = isJoinChatsList;
                [self.allDataList addObject:model];
            }
            self.isEmpty = (self.allDataList.count == 0)?YES:NO;
            self.isNoMore = ((self.allDataList.count % self.pageSize == 0)&(dataArray.count>0))?NO:YES;
        }
        
    } else {
        // 没有数据
        self.isNetError = YES;
        self.isEmpty = NO;
        
//        if ([UnreadMessagesNumSingle sharedInstance].myMessageUnReadCount > 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"ChatspListNotification"];
//        }
        
    }
}
#pragma mark -  退出群组请求  退群
/**
 退出群组请求  退群
 */
- (void)exitGroupRequest:(NSInteger)sessionId {
    
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/leaveSession"];
    NSDictionary *parameters = @{
                                 @"session":@(sessionId)
                                 };
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInView:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            self.myJoinGameGroupSessionId = 0;
            NSLog(@"退出群组成功");
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

-(void)gamesChatsClearSuccessBlock:(void (^)(NSDictionary *))successBlock
                      failureBlock:(void (^)(NSError *))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/clear"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        //        __strong __typeof(weakSelf)strongSelf = weakSelf;
        successBlock(response);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];
}


/**
 加入群组
 
 @param sessionId 群ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)joinGroup:(NSInteger)sessionId
         password:(NSString *)password
     successBlock:(void (^)(NSDictionary *))successBlock
     failureBlock:(void (^)(NSError *))failureBlock {
    
    NSDictionary *parameters = @{
                                 @"session":@(sessionId)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/join/sessions"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:nil];
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            self.myJoinGameGroupSessionId = sessionId;
            if (successBlock) {
                successBlock(response);
            }
        } else if ([[response objectForKey:@"status"] integerValue] == 2) {
            // 退群
            [strongSelf exitGroupRequest:[response[@"data"][@"session"] integerValue]];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response[@"mesage"]];
        }
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


/// 验证我是否已经加入
- (void)checkGroupId:(NSInteger)groupId
           Completed:(void (^)(BOOL complete))completed {
    
    if (self.mySessionListData.count == 0) {
        
        __weak __typeof(self)weakSelf = self;
        [self getMyJoinedSessionListSuccessBlock:^(NSDictionary *info) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            completed([strongSelf isContainGroup:groupId]);
        } failureBlock:^(NSError *error) {
            [[AFHttpError sharedInstance] handleFailResponse:error];
        }];
        
    } else {
        completed([self isContainGroup:groupId]);
    }
    
    
}

- (BOOL)isContainGroup:(NSInteger)groupId {
    BOOL b = NO;
    for (ChatsModel *model in self.mySessionListData) {
        
//        NSString *gid = [NSString stringWithFormat:@"%ld",([item.obj isKindOfClass:[NSDictionary class]] ? [item.obj[@"id"] integerValue] : -1)];
        if (groupId == model.sessionId) {
            b = YES;
            break;
        }
    }
    return b;
}


//- (NSMutableArray *)mySessionListData {
//    if (!_mySessionListData) {
//        _mySessionListData = [NSMutableArray array];
//
//        ChatsModel *model = [[ChatsModel alloc] init];
//        model.sessionType = ChatSessionType_CustomerService;
//        model.sessionId = kCustomerServiceID;
//        model.name = @"在线客服";
//        model.avatar = @"105";
//        model.isJoinChatsList = YES;
//        [_mySessionListData addObject:model];
//
//    }
//    return _mySessionListData;
//}

- (void)queryMyJoinGroup {
    
    // 刷新一下我加入的会话数据
    [self getMyJoinedSessionListSuccessBlock:^(NSDictionary *dict) {
        
    } failureBlock:^(NSError *error) {
    }];
    
}


- (void)destroyData {
    [self.allDataList removeAllObjects];
    [self.mySessionListData removeAllObjects];
    [self.mySessionListDictData removeAllObjects];
    instance = nil;
    predicate = 0;
}

@end
