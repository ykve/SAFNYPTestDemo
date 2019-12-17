//
//  UUProgressHUD.m
//  1111
//
//  Created by shake on 14-8-6.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUProgressHUD.h"
#import "Define.h"


#define kBackViewWidth 200

@interface UUProgressHUD ()
{
    NSTimer *_myTimer;
    CGFloat _angle;
}



@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, weak) UIWindow *overlayWindow;


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIImageView *voImage;
@property (nonatomic, strong) UIImageView *soundImage;

@end

@implementation UUProgressHUD

@synthesize overlayWindow;

+ (instancetype)sharedView
{
    static dispatch_once_t once;
    static UUProgressHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[UUProgressHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
        sharedView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    });
    return sharedView;
}

+ (void)show {
    [[UUProgressHUD sharedView] show];
}

+ (void)changeSubTitle:(NSString *)str
{
	[UUProgressHUD sharedView].subTitleLabel.text = str;
}

+ (void)dismissWithSuccess:(NSString *)str
{
	[[UUProgressHUD sharedView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str
{
	[[UUProgressHUD sharedView] dismiss:str];
}

- (void)show
{
	[self removeFromSuperview];
	[self.overlayWindow addSubview:self];
	
    self.leftImage.center = CGPointMake(kBackViewWidth/2 -60,kBackViewWidth/2);
    self.voImage.center = CGPointMake(kBackViewWidth/2,kBackViewWidth/2);
    self.soundImage.center = CGPointMake(kBackViewWidth/2+60,kBackViewWidth/2);
    
	self.titleLabel.center = CGPointMake(kBackViewWidth/2,kBackViewWidth/2 - 80);
	self.titleLabel.text = @"倒计时";
	
	self.subTitleLabel.center = CGPointMake(kBackViewWidth/2,kBackViewWidth/2 + 60);
	self.subTitleLabel.text = @"向上滑动取消";
	
	self.centerLabel.center = CGPointMake(kBackViewWidth/2,kBackViewWidth/2-55);
	self.centerLabel.text = @"60";
	
	self.backView.center = CGPointMake(YPSCREEN_Width/2,YPSCREEN_Height/2);
	
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.leftImage];
    [self.backView addSubview:self.voImage];
    [self.backView addSubview:self.soundImage];
	[self.backView addSubview:self.centerLabel];
	[self.backView addSubview:self.subTitleLabel];
	[self.backView addSubview:self.titleLabel];
	
	if (_myTimer) {
		[_myTimer invalidate];
		_myTimer = nil;
	}
	_myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
	
	[UIView animateWithDuration:0.5
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 self.alpha = 1;
					 }
					 completion:nil];
}

- (void)updateLevel:(double)reff {
    if (reff) {
       double ff = reff+60;
        if (ff>0&&ff<=10) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_0"];
        } else if (ff>10 && ff<20) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_1"];
        } else if (ff >=20 &&ff<30) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_2"];
        } else if (ff >=30 &&ff<40) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_3"];
        } else if (ff >=40 &&ff<50) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_4"];
        } else if (ff >= 50 && ff < 60) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_5"];
        } else if (ff >= 60 && ff < 70) {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_6"];
        } else {
            self.soundImage.image = [UIImage imageNamed:@"chat_sound_7"];
        }
    }
}


- (void)startAnimation
{
    _angle -= 3;
//    self.backView.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    float second = [_centerLabel.text floatValue];
	self.centerLabel.textColor = second <= 10.0f ? [UIColor redColor] : [UIColor yellowColor];
    self.centerLabel.text = [NSString stringWithFormat:@"%.1f",second-0.1];
}

- (void)free
{
	NSArray<UIView *> *subviews = @[_titleLabel, _centerLabel, _backView, _subTitleLabel];
	[subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj = nil;
	}];
	[self removeFromSuperview];
}

- (void)dismiss:(NSString *)state
{
	[_myTimer invalidate];
	_myTimer = nil;
	self.subTitleLabel.text = nil;
	self.titleLabel.text = nil;
	_centerLabel.text = state;
	_centerLabel.textColor = [UIColor whiteColor];
	
	CGFloat timeLonger;
	if ([state isEqualToString:@"TooShort"]) {
		timeLonger = 1;
	} else {
		timeLonger = 0.6;
	}
	[UIView animateWithDuration:timeLonger animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		[self free];
	}];
}

- (UIWindow *)overlayWindow
{
    return [UIApplication sharedApplication].delegate.window;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel){
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.font = [UIFont boldSystemFontOfSize:15];
		_titleLabel.textColor = [UIColor whiteColor];
	}
	return _titleLabel;
}

- (UILabel *)centerLabel
{
	if (!_centerLabel) {
		_centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
		_centerLabel.backgroundColor = [UIColor clearColor];
		_centerLabel.textAlignment = NSTextAlignmentCenter;
		_centerLabel.font = [UIFont systemFontOfSize:22];
		_centerLabel.textColor = [UIColor yellowColor];
	}
	return _centerLabel;
}

- (UILabel *)subTitleLabel
{
	if (!_subTitleLabel){
		_subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
		_subTitleLabel.backgroundColor = [UIColor clearColor];
		_subTitleLabel.textAlignment = NSTextAlignmentCenter;
		_subTitleLabel.font = [UIFont boldSystemFontOfSize:16];
		_subTitleLabel.textColor = [UIColor whiteColor];
	}
	return _subTitleLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, 200, 200);
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.8;
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)leftImage {
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _leftImage.image = [UIImage imageNamed:@"chat_vo_left"];
    }
    return _leftImage;
}
- (UIImageView *)voImage {
    if (!_voImage) {
        _voImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 82, 82)];
        _voImage.image = [UIImage imageNamed:@"chat_vo_vo"];
    }
    return _voImage;
}
- (UIImageView *)soundImage {
    if (!_soundImage) {
        _soundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 25)];
        _soundImage.image = [UIImage imageNamed:@"chat_sound_0"];
    }
    return _soundImage;
}

@end
