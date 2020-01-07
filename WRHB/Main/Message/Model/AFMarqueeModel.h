//
//  AFMarqueeModel.h
//  WRHB
//
//  Created by AFan on 2018/3/15.
//  Copyright © 2019年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFMarqueeModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic , copy)NSString *userImg;

@property (nonatomic, assign) CGFloat titleWidth;

@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
