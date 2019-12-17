//
//  BillTypeModel.h
//  WRHB
//
//  Created by AFan on 2019/10/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface BillTypeModel : NSObject
/// 图标
@property (nonatomic, copy) NSString *icon;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 账单类型
@property (nonatomic, assign) NSInteger category;



@property (nonatomic, strong) NSString *billTypeArray;

///
@property (nonatomic, assign) NSInteger tag;
/// 子标题
@property (nonatomic, copy) NSString *subTitle;
@end

NS_ASSUME_NONNULL_END
