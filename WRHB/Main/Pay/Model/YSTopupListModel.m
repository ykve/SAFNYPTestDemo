//
//  YSTopupListModel.m
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YSTopupListModel.h"

@implementation YSTopupListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"reply" : @"YSReplyModel"
             };
}
@end
