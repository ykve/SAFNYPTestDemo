//
//  AppDelegate.m
//  WRHB
//
//  Created by AFan on 2019/10/2.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AppDelegate.h"
#import "JSPatchManager.h"
#import <WHC_ModelSqlite.h>

#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "LoginViewController.h"

#import "YPIMManager.h"
#import "MessageNet.h"
#import "AFSocketManager.h"
#import "IMMessageManager.h"


UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;



@interface AppDelegate () <UIActionSheetDelegate>

@end

@implementation AppDelegate

static AppDelegate *_singleInstance;
+(AppDelegate *)shareInstance {
    return _singleInstance;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"服务器地址 %@",kServerUrl);
    NSLog(@"微信key %@ 微信secret %@",kWXKey,kWXSecret);
    
    [self initData];
#if TARGET_IPHONE_SIMULATOR
    //    [JPEngine startEngine];
    //    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    //    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    //    [JPEngine evaluateScript:script];
#elif TARGET_OS_IPHONE
    // 热更新加载
    //    [JSPatchManager asyncUpdate:YES];
#endif
    [self gethistoryMessageNum];
    
#if DEBUG
#else
    //    [NSThread sleepForTimeInterval:2.0];
#endif
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setRootViewController];
    
    //    [self setTabbar];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)initData {
    // 初始化一些数据
    [AppModel sharedInstance].isClubChat = NO;
}

/**
 设置根控制器
 */
-(void)setRootViewController {
    
    if ([AppModel sharedInstance].user_info.isLogined) {
        [BANetManager initialize];
        [YPIMManager sharedInstance];
        [self.window.layer addAnimation:self.animation forKey:nil];
        self.window.rootViewController = [[NSClassFromString(@"ZMTabBarController") alloc] init];
    } else {
        
        LoginViewController *vc =  [[LoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    
}


/**
 退出登录
 */
- (void)logOut {
    
    [AppModel sharedInstance].token = nil;
    [AppModel sharedInstance].user_info = [UserInfo new];
    [[YPIMManager sharedInstance] userSignout];
    [AppModel sharedInstance].unReadAllCount = 0;
    [[MessageNet sharedInstance] destroyData];
    [[AppModel sharedInstance] saveAppModel];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(),^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf setRootViewController];
    });
}



- (CATransition *)animation {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.type =  @"cube";  //立方体效果
    
    //设置动画子类型
    animation.subtype = kCATransitionFromTop;
    return animation;
}


- (void)setTabBarItems:(UITabBarController*)tabBarVC
{
    NSArray *titles = @[@"常用", @"自定义导航栏", @"移动导航栏",@"移动导航栏"];
    NSArray *normalImages = @[@"mine", @"mine", @"mine",@"mine"];
    NSArray *highlightImages = @[@"mineHighlight", @"mineHighlight", @"mineHighlight",@"mineHighlight"];
    [tabBarVC.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = titles[idx];
        obj.image = [[UIImage imageNamed:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.selectedImage = [[UIImage imageNamed:highlightImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
}





- (void)gethistoryMessageNum {
    
    NSInteger oldMessageNum = 0;
    if ([AppModel sharedInstance].unReadAllCount > 0) {
        oldMessageNum = [AppModel sharedInstance].unReadAllCount;
    }
    [AppModel sharedInstance].unReadAllCount = 0;
    
    NSString *queryWhere = [NSString stringWithFormat:@"userId='%ld'",[AppModel sharedInstance].user_info.userId];
    NSArray *userGroupArray = [WHC_ModelSqlite query:[PushMessageNumModel class] where:queryWhere];
    
    for (NSInteger index = 0; index < userGroupArray.count; index++) {
        PushMessageNumModel *pmModel = (PushMessageNumModel *)userGroupArray[index];
        
        if (pmModel != nil && pmModel.sessionId == 0 && !(pmModel.sessionId == 0)) {
            //            [AppModel sharedInstance].unReadAllCount += pmModel.number;
            
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",pmModel.sessionId,[AppModel sharedInstance].user_info.userId];
            [MessageSingle sharedInstance].unreadAllMessagesDict[queryId] = pmModel;
        }
    }
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}



// 程序 重新激活（复原）注意：应用程序在启动时，在调用了“applicationDidFinishLaunching”方法之后 同样也会 调用“applicationDidBecomeActive”方法!
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestJSPatchInfo];
    // 更新的弹框 AFan
//    [[FunctionManager sharedInstance] checkVersion:NO];
}

/**
 *  当应用程序收到内存警告的时候调用
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    NSLog(@"1");
}




- (void)requestJSPatchInfo {
    NSString *requestJStime = [[NSUserDefaults standardUserDefaults] valueForKey:@"requestJStime"];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    CGFloat timeSpace = currentTime - [requestJStime floatValue];
    if (requestJStime.length==0 | timeSpace > 3600) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",currentTime] forKey:@"requestJStime"];
        [JSPatchManager asyncUpdate:YES];
    }
}

/// 当应用程序即将终止的时候调用
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"1");
}


@end
