
//
//  CPTPayModel.m
//  LotteryProduct
//
//  Created by Jason Lee on 2019/5/20.
//  Copyright © 2019 vsskyblue. All rights reserved.
//

#import "PayTopupModel.h"

@implementation PayTopupModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{
//             @"amounts" : @"TopupAmountsModel"
//             };
//}

- (void)setAmounts:(NSArray *)amounts {
    _amounts = amounts;
    if (amounts.count > 0) {
       _minMoney = [amounts.firstObject integerValue];
        _maxMoney = [amounts.lastObject integerValue];
    }
}
@end
