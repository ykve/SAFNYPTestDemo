//
//  ClubMemberDetailsModels.h
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClubMemberDetailsModel;
@class ClubMemberSummaryModel;
@class ClubMemberDetailsListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ClubMemberDetailsModels : NSObject

///
@property (nonatomic, strong) ClubMemberDetailsModel *detail;
///
@property (nonatomic, strong) ClubMemberSummaryModel *summary;
///
@property (nonatomic, strong) NSArray<ClubMemberDetailsListModel *> *data;

@end

NS_ASSUME_NONNULL_END
