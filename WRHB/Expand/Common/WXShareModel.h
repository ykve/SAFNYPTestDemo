//
//  WXShareModel.h
//  WRHB
//
//  Created by AFan on 2019/11/10.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXShareModel : NSObject

@property (nonatomic ,assign) NSInteger WXShareType;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,strong) UIImage *imageIcon;
@property (nonatomic ,strong) NSData *imageData;
@property (nonatomic ,copy) NSString *link;

@end
