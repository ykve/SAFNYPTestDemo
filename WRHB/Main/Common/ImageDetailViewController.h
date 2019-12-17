//
//  ImageDetailViewController.h
//  Project
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDetailViewController : UIViewController
@property (nonatomic, strong) NSString *imageUrl;//图片url
@property (nonatomic, strong) UIColor *bgColor;//背景色
@property (nonatomic, assign) NSInteger insetsValue;//距离屏幕边框的距离

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL hiddenNavBar;

@property (nonatomic, assign) BOOL top;//是否置顶

-(void)showImage;
-(void)writeTitle;
@end

NS_ASSUME_NONNULL_END
