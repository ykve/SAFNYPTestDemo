//
//  ClubMemberModel.m
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberModel.h"

@implementation ClubMemberModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}
@end
