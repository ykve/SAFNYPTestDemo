//
//  SystemNotificationModel.m
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SystemNotificationModel.h"

@implementation SystemNotificationModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id", @"desTitle": @"description"};
}

@end
