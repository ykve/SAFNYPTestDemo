//
//  RoomMangaeModel.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "RoomMangaeModel.h"

@implementation RoomMangaeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"initiator" : @"ClubInitiator"
             };
}
@end
