//
//  AFHttpError.h
//  WRHB
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFHttpError : NSObject

+ (instancetype)sharedInstance;

-(void)handleFailResponse:(id)object;

@end

NS_ASSUME_NONNULL_END
