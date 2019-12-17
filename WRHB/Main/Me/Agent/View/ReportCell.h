//
//  ReportCell.h
//  Project
//
//  Created AFan on 2019/9/9.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportFormsItem;

NS_ASSUME_NONNULL_BEGIN

@interface ReportCell : UICollectionViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *ddsLabel;


///
@property (nonatomic, strong) ReportFormsItem *model;

@end

NS_ASSUME_NONNULL_END
