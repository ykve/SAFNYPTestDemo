//
//  ClubMemberDetailsModels.m
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberDetailsModels.h"

@implementation ClubMemberDetailsModels


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"detail" : @"ClubMemberDetailsModel",
             @"summary" : @"ClubMemberSummaryModel",
             @"data" : @"ClubMemberDetailsListModel",
             };
}

@end
