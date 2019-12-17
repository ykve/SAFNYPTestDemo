//
//  CSAskFormModel.h
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSAskFormModel : NSObject
/// ID
@property (nonatomic, assign) NSInteger ID;
/// 名称
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
