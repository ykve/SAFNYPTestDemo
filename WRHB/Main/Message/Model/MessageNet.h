//
//  MessageNet.h
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNet : NSObject

#define MESSAGE_NET [MessageNet sharedInstance] // 我加入的群组用单例

@property (nonatomic ,strong) NSMutableArray *dataList;   // 所有群组
@property (nonatomic ,strong) NSMutableArray *myChatsDataList;   // 我加入的群组
@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选

@property (nonatomic ,assign) BOOL isEmpty; ///<空
@property (nonatomic ,assign) BOOL isNoMore; ///<没有更多

@property (nonatomic ,assign) BOOL isEmptyMyJoin; ///<空
@property (nonatomic ,assign) BOOL isNoMoreMyJoin; ///<没有更多

@property (nonatomic ,assign) BOOL isNetError; ///

@property (nonatomic ,assign) BOOL isOnce; // 是否第一次请求


+ (MessageNet *)sharedInstance;
-(void)getGameListWithRequestParams:(id)requestParams successBlock:(void (^)(NSArray *))successBlock
                       failureBlock:(void (^)(id))failureBlock;
//- (void)getGroupObj:(id)obj
//            Success:(void (^)(NSDictionary *))success
//            Failure:(void (^)(NSError *))failue;


- (void)checkGroupId:(NSInteger)groupId
           Completed:(void (^)(BOOL complete))completed;



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



/**
 获取我加入的群组列表

 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getMyJoinedGroupListSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(NSError *))failureBlock;

/**
 获取所有群组列表
 
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getGroupListWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                       failureBlock:(void (^)(id))failureBlock;

- (void)destroyData;

@end
