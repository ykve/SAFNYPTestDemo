//
//  TransferController.h
//  WRHB
//
//  Created by AFan on 2020/1/2.
//  Copyright © 2020 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransferViewDelegate <NSObject>

@required
- (void)didTransferFinished:(YPMessage *)message;

@end

@class ChatsModel;

NS_ASSUME_NONNULL_BEGIN

@interface TransferController : UIViewController
///
@property (nonatomic, strong) ChatsModel *chatsModel;
@property (nonatomic, weak) id<TransferViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
