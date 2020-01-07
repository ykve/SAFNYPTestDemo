//
//  PayThirdModel.h
//  WRHB
//
//  Created by AFan on 2019/12/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayThirdModel : NSObject
/// 类型 1跳转url  2html表单提交
@property (nonatomic, assign) NSInteger type;
/// 信息
@property (nonatomic, copy) NSString *msg;
/// 内容  url + html from
@property (nonatomic, copy) NSString *res;
/// 订单号
@property (nonatomic, copy) NSString *no;

@end

NS_ASSUME_NONNULL_END
