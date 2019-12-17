//
//  YPChatLocationController.h
//  YPChatView
//
//  Created by soldoros on 2019/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YPChatLocationBlock)(NSDictionary *locationDic, NSError *error);

@interface YPChatLocationController : UIViewController

@property (nonatomic, copy)YPChatLocationBlock locationBlock;


@end


