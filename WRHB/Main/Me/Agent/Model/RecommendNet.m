//
//  RecommendNet.m
//  Project
//
//  Created by AFan on 2019/11/2.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "RecommendNet.h"

@implementation RecommendNet

- (instancetype)init{
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _page = 0;
        _pageSize = 15;
        _isNoMore = NO;
        _isEmpty = NO;
        _type = -1;
    }
    return self;
}

- (void)getPlayerWithPage:(NSInteger)page success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failue{
    WEAK_OBJ(weakSelf, self);
}

- (void)requestCommonInfoWithSuccess:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failue{
    WEAK_OBJ(weakSelf, self);
//    [NET_REQUEST_MANAGER requestMyPlayerCommonInfoWithSuccess:^(id object) {
//        weakSelf.commonInfo = object[@"data"];
//        success(object);
//    } fail:^(id object) {
//        failue(object);
//    }];
}
@end
