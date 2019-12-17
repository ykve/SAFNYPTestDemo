//
//  AgentAlertView.h
//  WRHB
//
//  Created by AFan on 2019/10/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AgentAlertViewBlock)(NSInteger tag);


NS_ASSUME_NONNULL_BEGIN

@interface AgentAlertView : UIView

@property(nonatomic,  copy) AgentAlertViewBlock alertBlock;

@end

NS_ASSUME_NONNULL_END
