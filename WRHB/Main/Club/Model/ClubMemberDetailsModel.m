//
//  ClubMemberDetailsModel.m
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberDetailsModel.h"

@implementation ClubMemberDetailsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"asset" : @"PayAssetsModel"
             };
}
@end
