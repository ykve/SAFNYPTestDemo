//
//  CowCowVSMessageCell.h
//  Project
//
//  Created by AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

//#import <RongIMKit/RongIMKit.h>
#import "AFSystemBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

#define bgWidth (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 2))//
#define bgRate 0.45

#define CowBackImageHeight 80

@interface CowCowVSMessageCell : AFSystemBaseCell

@property (nonatomic ,strong) UILabel *tipLabel;

@end

NS_ASSUME_NONNULL_END
