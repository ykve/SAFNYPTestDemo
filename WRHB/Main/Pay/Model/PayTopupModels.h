//
//  PayTopupModels.h
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayTopupModels : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *type_name;
/// 充值说明  HTML
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, strong) NSArray *items;


@end

NS_ASSUME_NONNULL_END
