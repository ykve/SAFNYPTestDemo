//
//  ReportFormsView.h
//  WRHB
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportFormsItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *desc2;
@property (nonatomic, assign) BOOL isShowDesBtn;
@end


@interface ReportFormsView : UIView

@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;

@property(nonatomic,strong)NSString *tempBeginTime;
@property(nonatomic,strong)NSString *tempEndTime;
@property (nonatomic, strong) UIButton *rightBtn;
-(void)getData;
-(void)showTimeSelectView;
@end

NS_ASSUME_NONNULL_END
