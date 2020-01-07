//
//  AFSystemBaseCell.h
//  WRHB
//
//  Created by AFan on 2019/4/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessagelLayout.h"


@protocol AFSystemBaseCellDelegate <NSObject>

@optional;
// 点击VS牛牛Cell消息背景视图
- (void)didTapVSCowcowCell:(YPMessage *)model;

@end




@interface AFSystemBaseCell : UITableViewCell

-(void)initChatCellUI;
@property (nonatomic, strong) ChatMessagelLayout  *model;

@property (nonatomic, weak) id <AFSystemBaseCellDelegate> delegate;

@end
