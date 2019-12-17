

//
//  MessageNet.m
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "MessageNet.h"
#import "MessageItem.h"
#import "MessageSingle.h"
#import "ChatsModel.h"
#import "PushMessageNumModel.h"

@implementation MessageNet

static MessageNet *instance = nil;
static dispatch_once_t predicate;
+ (MessageNet *)sharedInstance {
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _page = 0;
        _pageSize = 15;
        _isNoMore = YES;
        _isEmpty = YES;
        _isNoMoreMyJoin = YES;
        _isEmptyMyJoin = YES;
        _isOnce = YES;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getMyJoinedGroupListSuccessBlock:nil failureBlock:nil];
        });
    }
    return self;
}

- (NSArray *)localList {
    ChatsModel *service_model = [[ChatsModel alloc] init];
    service_model.localImg = @"chats_kefu";   // 本地图片名称
    service_model.name = @"在线客服";
    service_model.sessionId = 0;
    service_model.desc = @"有问题，找客服";
    
    ChatsModel *friend_model = [[ChatsModel alloc] init];
    friend_model.localImg = @"chats_haoyou";   // 图片名称
    friend_model.name = @"我的好友";
    friend_model.sessionId = 0;
    friend_model.desc = @"";
    
    //    return @[notif,service];
    return @[service_model,friend_model];
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
    
//    NSDictionary *parameters = @{
//                                 @"session":sessionId,
//                                 @"pwd":password == nil ? @"" :password
//                                 };
    NSDictionary *parameters = @{
                                 @"session":@(sessionId)
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/join/sessions"];
    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [strongSelf queryMyJoinGroup];
        }
        successBlock(response);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    } progressBlock:nil];
}

/**
 获取我加入的群组
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyJoinedGroupListSuccessBlock:(void (^)(NSDictionary *))successBlock
                           failureBlock:(void (^)(NSError *))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/mines"];
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        NSLog(@"get 请求数据结果： *** %@", response);
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
             [strongSelf handleGroupListData:response[@"data"] andIsChatsList:YES];
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
 获取所有群组列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getGroupListWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(id))failureBlock {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"chat/repacket/groups"];
//    NSDictionary *parameters = @{
//                                 @"size":@"100",
//                                 @"sort":@"id",
//                                 @"isAsc":@"false",
//                                 @"current":@"1"
//                                 };
//    entity.parameters = parameters;
    entity.needCache = NO;
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        if ([response[@"status"]integerValue]==1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //        NSLog(@"get 请求数据结果： *** %@", response);
            [strongSelf handleGroupListData:response[@"data"] andIsChatsList:NO];
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

/**
 获取game banner
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getGameListWithRequestParams:(id)requestParams successBlock:(void (^)(NSArray *))successBlock
                       failureBlock:(void (^)(id))failureBlock {
//    WEAK_OBJ(weakSelf, self);
//    [NET_REQUEST_MANAGER requestMsgBannerWithId:[requestParams integerValue] WithPictureSpe:OccurBannerAdsPictureTypeNormal success:^(id object) {
//        self.dataList = [[NSMutableArray alloc] init];
//        BannerModel* model = [BannerModel mj_objectWithKeyValues:object];
//        if (model.data.skAdvDetailList.count>0) {
//            [self.dataList addObjectsFromArray: model.data.skAdvDetailList];
//            self.isEmpty = NO;
//            self.isNetError = NO;
//            successBlock(self.dataList);
//            
//        }else{
//            self.isEmpty = YES;
//            self.isNetError = NO;
//            [[AFHttpError sharedInstance] handleFailResponse:object];
//            failureBlock(object);
//            
//        }
//    } fail:^(id object) {
//        self.isNetError = YES;
//        self.isEmpty = NO;
//        [[AFHttpError sharedInstance] handleFailResponse:object];
//        failureBlock(object);
//    }];
}

-(void)handleGroupListData:(NSArray *)data andIsChatsList:(BOOL)isChatsList {
    if (data != NULL && [data isKindOfClass:[NSArray class]]) {
        self.isNetError = NO;
        
        if (isChatsList) {
            self.myChatsDataList = [[NSMutableArray alloc]initWithArray:self.localList];
            [AppModel sharedInstance].unReadAllCount = 0;
            NSMutableArray *marray = [NSMutableArray array];
            for (id item in data) {
                ChatsModel *model = [ChatsModel mj_objectWithKeyValues:item];
                model.isChatsList = isChatsList;
                
                NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",model.sessionId,[AppModel sharedInstance].user_info.userId];
                PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
                [AppModel sharedInstance].unReadAllCount += pmModel.number;
                
                [self.myChatsDataList addObject:model];
                // 保存群ID
                [marray addObject:@(model.sessionId)];
            }
            
            if (self.isOnce) {   // 启动后第一次请求需要发一次通知
                self.isOnce = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:kDoneGetMyJoinedGroupsNotification object:nil];
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"ChatspListNotification"];
            
            self.isEmptyMyJoin = (self.myChatsDataList.count == 0)?YES:NO;
            self.isNoMoreMyJoin = ((self.myChatsDataList.count % self.pageSize == 0)&(data.count>0))?NO:YES;
        }else{
            self.dataList = [[NSMutableArray alloc] init];
            for (id item in data) {
                ChatsModel *model = [ChatsModel mj_objectWithKeyValues:item];
                model.isChatsList = isChatsList;
                [self.dataList addObject:model];
            }
            self.isEmpty = (self.dataList.count == 0)?YES:NO;
            self.isNoMore = ((self.dataList.count % self.pageSize == 0)&(data.count>0))?NO:YES;
        }
        
    } else {
        // 没有数据
        self.isNetError = YES;
        self.isEmpty = NO;
//        {
//            message = "每页显示行数不能为空";
//            code = 1;
//            errorcode = 10000001;
//            msg = "PageRequestBody(queryParam=null, current=null, size=null, sort=id, isAsc=false)";
//        }
        if ([AppModel sharedInstance].unReadAllCount > 0) {
            [AppModel sharedInstance].unReadAllCount = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadMessageNumberChange object:@"ChatspListNotification"];
        }
        
    }
}

- (void)checkGroupId:(NSInteger)groupId
           Completed:(void (^)(BOOL complete))completed {
    
    if (self.myChatsDataList.count == 0) {
        
        __weak __typeof(self)weakSelf = self;
        [self getMyJoinedGroupListSuccessBlock:^(NSDictionary *info) {
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
    for (ChatsModel *model in self.myChatsDataList) {
        
//        NSString *gid = [NSString stringWithFormat:@"%ld",([item.obj isKindOfClass:[NSDictionary class]] ? [item.obj[@"id"] integerValue] : -1)];
        if (groupId == model.sessionId) {
            b = YES;
            break;
        }
    }
    return b;
}



- (void)queryMyJoinGroup {
    
    // 刷新一下我加入的群组数据
    [self getMyJoinedGroupListSuccessBlock:^(NSDictionary *dict) {
    } failureBlock:^(NSError *error) {
    }];
    
}


- (void)destroyData {
    [self.dataList removeAllObjects];
    [self.myChatsDataList removeAllObjects];
    instance = nil;
    predicate = 0;
}

@end
