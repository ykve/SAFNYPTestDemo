//
//  EnvelopeListViewController.h
//  WRHB
//
//  Created by AFan on 2019/11/13.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatsModel;

@interface RedPacketDetListController : UIViewController

/// 会话模型
@property (nonatomic ,strong) ChatsModel *chatsModel;

@property (nonatomic, assign) BOOL isCowCow;
@property (nonatomic, assign) BOOL isRightBarButton;
/// 红包ID
@property (nonatomic, copy) NSString *redPackedId;
@property (nonatomic, assign) NSInteger bankerId;
// 退包时间
@property (nonatomic, assign) CGFloat returnPackageTime;

@end
