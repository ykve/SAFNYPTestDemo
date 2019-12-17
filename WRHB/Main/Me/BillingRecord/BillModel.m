//
//  BillModel.m
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BillModel.h"


@implementation BillModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataList = [[NSMutableArray alloc]init];
        _pageSize = 20;
        _page = 0;
        _beginTime = dateString_date([NSDate date], CDDateDay);
        _endTime = dateString_date([NSDate date], CDDateDay);
    }
    return self;
}


- (void)getBillListType:(NSInteger)category
                   page:(NSInteger)page
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSError *))failue {
    
    NSDictionary *time = @{
                           @"begin": @(timeStamp_string(self.beginTime, CDDateDay)),
                           @"end": @(timeStamp_string(self.endTime, CDDateDay) + 24*60*60 -1),
                           };
    
    NSDictionary *filters = @{
                              @"type":@(category),   // 账单类型
                              @"time":time    // 过滤时间 [begin,end]
                              };
    
    NSDictionary *parameters = @{
                                 @"pageSize":@(self.pageSize),   // 请求条目数 <= 30
                                 @"current":@(page + 1),    // 当前页
                                 @"filters":filters     // 过滤条件
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"finance/bills"];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    if (self.page == 0) {
        id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:entity.parameters];
        if (cacheJson) {
            NSDictionary *data = [cacheJson objectForKey:@"data"];
            [self.dataList removeAllObjects];
            NSArray *array = [BillItemModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
            
            if (array.count > 0) {
                self.isNoMore = ((array.count % self.pageSize == 0) & (array.count>0)) ? NO : YES;
                self.isEmpty = NO;
            } else {
                self.isNoMore = YES;
                self.isEmpty = YES;
            }
            [self.dataList addObjectsFromArray:array];
            success(cacheJson);
        }else {
            [MBProgressHUD showActivityMessageInWindow:nil];
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSDictionary *data = [response objectForKey:@"data"];
            if (data != NULL) {
                strongSelf.page = page + 1;
                if (strongSelf.page == 1) {
                    [strongSelf.dataList removeAllObjects];
                }
                
                NSArray *array = [BillItemModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
                
                if (array.count > 0) {
                    strongSelf.isNoMore = ((array.count % strongSelf.pageSize == 0) & (array.count>0)) ? NO : YES;
                    strongSelf.isEmpty = NO;
                } else {
                    strongSelf.isNoMore = YES;
                    strongSelf.isEmpty = YES;
                }
                [strongSelf.dataList addObjectsFromArray:array];
            }
            
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:entity.parameters completed:^(BOOL result) {
                NSLog(@"1");
            }];
        }
        
         success(response);
    } failureBlock:^(NSError *error) {
        failue(error);
    } progressBlock:nil];
    
}


@end
