//
//  Sub_Users.m
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "Sub_Users.h"

@implementation Sub_Users

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"ID": @"id"};
//}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"users" : @"Sub_Users",
             @"recommend" : @"Sub_Recommend",
             @"group" : @"Sub_Group"
             };
}
@end
