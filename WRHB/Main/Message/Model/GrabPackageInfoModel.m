//
//  GrabPackageInfoModel.m
//  WRHB
//
//  Created by AFan on 2019/10/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "GrabPackageInfoModel.h"

@implementation GrabPackageInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"grab_at": @"grab_time"};
}
@end
