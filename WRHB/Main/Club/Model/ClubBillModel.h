//
//  ClubBillModel.h
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClubBillModel : NSObject

/// ID
@property (nonatomic, assign) NSInteger users;
///
@property (nonatomic, copy) NSString *capital;
///
@property (nonatomic, copy) NSString *commission;
///
@property (nonatomic, assign) NSTimeInterval date;

@end

NS_ASSUME_NONNULL_END
