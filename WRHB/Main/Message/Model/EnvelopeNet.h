//
//  EnvelopeNet.h
//  WRHB
//
//  Created by AFan on 2019/11/20.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvelopeNet : NSObject

@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选


@property (nonatomic ,strong) NSMutableDictionary *redPackedInfoDetail;  
@property (nonatomic ,strong) NSMutableArray *redPackedListArray;  // 原始数据
@property (nonatomic ,strong) NSMutableArray *dataList;   // 处理过的数据

@property (nonatomic ,assign) BOOL isEnd;
@property (nonatomic ,assign) BOOL isEmpty;///<空
@property (nonatomic ,assign) BOOL isNoMore;///<没有更多
@property (nonatomic ,assign) BOOL isNetError;///<没有更多


@property (nonatomic ,assign) BOOL isGrabId;


+ (EnvelopeNet *)sharedInstance;
/**
 从bill 列表 bizId获取发包详情
 
 @param packetId 抢包ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getUnityRedpDetail:(NSInteger)packetId successBlock:(void (^)(NSDictionary *))successBlock
             failureBlock:(void (^)(NSError *))failureBlock;
/**
 获取红包详情
 
 @param packetId ID
 @param successBlock 成功block
 @param failureBlock 失败block
 */
-(void)getRedpDetSendId:(NSString *)packetId successBlock:(void (^)(NSDictionary *))successBlock
           failureBlock:(void (^)(NSError *))failureBlock;


-(void)gamesChatsClearSuccessBlock:(void (^)(NSDictionary *))successBlock
                      failureBlock:(void (^)(NSError *))failureBlock;

- (void)destroyData;




@end
