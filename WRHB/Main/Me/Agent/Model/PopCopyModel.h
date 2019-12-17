//
//  PopCopyModel.h
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopCopyModel : NSObject
///
@property (nonatomic ,copy) NSString *title;
/// 1    常见问题
//2    存款问题
//3    提款问题
//4    游戏问题
//5    规则问题
//6    推广文案
@property (nonatomic ,assign) NSInteger type;
///
@property (nonatomic ,copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
