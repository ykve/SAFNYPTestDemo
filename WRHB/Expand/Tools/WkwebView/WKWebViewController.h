//
//  WKWebViewController.h
//  WKWebViewOC
//
//  Created by XiaoFeng on 2016/11/24.
//  Copyright © 2016年 XiaoFeng. All rights reserved.
//  QQ群:384089763 欢迎加入
//  github链接:https://github.com/XFIOSXiaoFeng/WKWebView

#import <UIKit/UIKit.h>

@interface WKWebViewController : UIViewController

/** 是否显示Nav */
@property (nonatomic,assign) BOOL isNavHidden;
/// 是否加载网页的标题 默认YES加载
@property (nonatomic,assign) BOOL isLoadWebTitle;

- (void)loadWebURLSring:(NSString *)string;

- (void)loadWebHTMLSring:(NSString *)string;

- (void)loadWebFormHTMLSring:(NSString *)string;

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;


@end
