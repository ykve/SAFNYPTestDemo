//
//  BillModel.h
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BillItemModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface BillModel : NSObject

@property (nonatomic ,assign) NSInteger total;
///
@property (nonatomic, strong) NSMutableArray<BillItemModel *> *dataList;

@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,assign) NSInteger pageSize;

@property (nonatomic ,strong) NSString *beginTime;
@property (nonatomic ,strong) NSString *endTime;

/// 是否为空
@property (nonatomic ,assign) BOOL isEmpty;
/// 是否没有更多
@property (nonatomic ,assign) BOOL isNoMore;

@property (nonatomic ,strong) NSString *categoryStr;


- (void)getBillListType:(NSInteger)category
                   page:(NSInteger)page
                success:(void (^)(NSDictionary *))success
                failure:(void (^)(NSError *))failue;

@end

NS_ASSUME_NONNULL_END
