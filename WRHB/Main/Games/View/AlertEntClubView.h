//
//  AlertEntClubView.h
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^EntClubActionBlock)(void);
typedef void(^EntClubSubmitBtnBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface AlertEntClubView : UIView
///
@property (nonatomic, strong) UILabel *titleLabel;
///
@property (nonatomic, strong) UILabel *titLabel;
///
@property (nonatomic, strong) UIButton *submitBtn;
///
@property (nonatomic, strong) UITextField *textField;


@property(nonatomic, copy) EntClubActionBlock coubBlock;
-(void)observerSure:(EntClubActionBlock)coubBlock;

@property (nonatomic, copy) EntClubSubmitBtnBlock submitBtnBlock;

@end

NS_ASSUME_NONNULL_END
