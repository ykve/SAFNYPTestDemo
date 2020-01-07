//
//  RecommendNet.h
//  WRHB
//
//  Created by AFan on 2019/11/2.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendNet : NSObject

@property (nonatomic ,strong) NSMutableArray *dataList;
@property (nonatomic ,assign) NSInteger page; ///< 页数(从1开始，默认值1)           可选
@property (nonatomic ,assign) NSInteger total;
@property (nonatomic ,assign) NSInteger pageSize; ///< 页大小(默认值15)                可选

@property (nonatomic ,assign) BOOL isEmpty;///<空
@property (nonatomic ,assign) BOOL isNoMore;///<没有更多
@property (nonatomic ,assign) BOOL IsNetError;///<没有更多

/// 用户账号
@property (nonatomic, assign) NSInteger userId;
/// 1普通用户 2 代理用户
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSDictionary *commonInfo;

- (void)getPlayerWithPage:(NSInteger)page success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failue;

- (void)requestCommonInfoWithSuccess:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *))failue;
@end
