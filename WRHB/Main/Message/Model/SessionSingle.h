//
//  MessageNet.h
//  WRHB
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatsModel;

@interface SessionSingle : NSObject
/// 所有会话 比如说游戏房间
@property (nonatomic ,strong) NSMutableArray<ChatsModel *> *allDataList;
/// 我加入的会话
@property (nonatomic ,strong) NSMutableArray<ChatsModel *> *mySessionListData;
///
@property (nonatomic ,strong) NSMutableDictionary *mySessionListDictData;


/// 我加入的游戏会话ID  每次只能有一个
@property (nonatomic ,assign) NSInteger myJoinGameGroupSessionId;

@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选

@property (nonatomic ,assign) BOOL isEmpty; ///<空
@property (nonatomic ,assign) BOOL isNoMore; ///<没有更多

@property (nonatomic ,assign) BOOL isEmptyMyJoin; ///<空
@property (nonatomic ,assign) BOOL isNoMoreMyJoin; ///<没有更多

@property (nonatomic ,assign) BOOL isNetError; ///

@property (nonatomic ,assign) BOOL isOnce; // 是否第一次请求

@property (nonatomic ,assign) BOOL isCache;

+ (SessionSingle *)sharedInstance;


/**
 保存我的聊天列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)saveMyChatsListSuccessBlock:(void (^)(NSDictionary *))successBlock
                     failureBlock:(void (^)(NSError *))failureBlock;
/**
 获取我的聊天列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyChatsListSuccessBlock:(void (^)(NSDictionary *))successBlock
                             failureBlock:(void (^)(NSError *))failureBlock;

/**
 获取我加入的会话列表

 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyJoinedSessionListSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(NSError *))failureBlock;

/**
 获取所有会话列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getAllSessionListWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(id))failureBlock;

/**
 加入群组
 
 @param groupId 群ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)joinGroup:(NSInteger)groupId
         password:(NSString *)password
     successBlock:(void (^)(NSDictionary *))successBlock
     failureBlock:(void (^)(NSError *))failureBlock;
/// 验证我是否已经加入
- (void)checkGroupId:(NSInteger)groupId
           Completed:(void (^)(BOOL complete))completed;

#pragma mark -  退出群组请求  退群
/**
 退出群组请求  退群
 */
- (void)exitGroupRequest:(NSInteger)sessionId;

-(void)gamesChatsClearSuccessBlock:(void (^)(NSDictionary *))successBlock
                      failureBlock:(void (^)(NSError *))failureBlock;

- (void)queryMyJoinGroup;

- (void)destroyData;

@end
