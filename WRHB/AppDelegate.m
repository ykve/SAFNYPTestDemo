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
#import "SessionSingle.h"
#import "AFSocketManager.h"
#import "IMMessageManager.h"

#import <Pusher/Pusher.h>
#import <AVFoundation/AVFoundation.h>
#import "SysMessageListModel.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
UIColor *MainNavBarColor = nil;
UIColor *MainViewColor = nil;



@interface AppDelegate () <UIActionSheetDelegate,PTPusherDelegate>
@property (nonatomic ,strong) PTPusher *client;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation AppDelegate

static AppDelegate *_singleInstance;
+(AppDelegate *)shareInstance {
    return _singleInstance;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"服务器地址 %@",kServerUrl);
    NSLog(@"微信key %@ 微信secret %@",kWXKey,kWXSecret);
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"确定";
    [self initData];
#if TARGET_IPHONE_SIMULATOR
    [JPEngine startEngine];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
#elif TARGET_OS_IPHONE
    [JSPatchManager asyncUpdate:YES];
#endif
    [self getHistoryMessageNum];
    
#if DEBUG
#else
    //    [NSThread sleepForTimeInterval:2.0];
#endif
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self setRootViewController];
    
    
    [self broadcastNotification];
    /// 刷新会话信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPusherSetValue) name:kLoginedNotification object:nil];
    
    
    //    [self setTabbar];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)initData {
    // 初始化一些数据
    [AppModel sharedInstance].isClubChat = NO;
    [UnreadMessagesNumSingle sharedInstance];
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
    [[SessionSingle sharedInstance] destroyData];
    [[AppModel sharedInstance] saveAppModel];
    [[UnreadMessagesNumSingle sharedInstance] destoryInstance];
    
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


#pragma mark -  Chats 广播
- (void)broadcastNotification {
    NSString *pushKey = nil;
    if ([AppModel sharedInstance].isDebugMode) {
        pushKey = kPusherKeyTest;
    } else {
        pushKey = kPusherKey;
    }
    
    // self.client is a strong instance variable of class PTPusher
    self.client = [PTPusher pusherWithKey:pushKey delegate:self encrypted:YES cluster:@"ap1"];
    
    // subscribe to channel and bind to event
    PTPusherChannel *channel = [self.client subscribeToChannelNamed:@"pmd"];
    
    [channel bindToEventNamed:@"carousel" handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictianary of the JSON object received
        NSDictionary *data = [channelEvent.data objectForKey:@"data"];
        //        NSLog(@"message received: %@", message);
        if (data) {
            //            NSDictionary *dict = @{@"content":data[@"content"],@"num":data[@"num"]};
            /// 中奖广播
            [[NSNotificationCenter defaultCenter] postNotificationName:kWinningBroadcastNotification object: data];
        }
    }];
    
    if ([AppModel sharedInstance].channel.length > 0) {
        [self loginPusherSetValue];
    }
    
    [self.client connect];
    
}


#pragma mark -  系统消息接收
- (void)loginPusherSetValue {
    
    if ([AppModel sharedInstance].channel.length == 0) {
        return;
    }
    // subscribe to channel and bind to event
    PTPusherChannel *channel2 = [self.client subscribeToChannelNamed:[AppModel sharedInstance].channel];
    
    __weak __typeof(self)weakSelf = self;
    
    [channel2 bindToEventNamed:[AppModel sharedInstance].event handleWithBlock:^(PTPusherEvent *channelEvent) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // channelEvent.data is a NSDictianary of the JSON object received
        NSDictionary *data2 = [channelEvent.data objectForKey:@"data"];
        //        NSLog(@"message received: %@", message);
        if (data2) {
            //            NSDictionary *dict = @{@"type":data2[@"type"],@"title":data2[@"title"],@"content":data2[@"content"],@"updateTime":data2[@"updateTime"]};
            [strongSelf receiveSysMessageDict:data2];
        }
    }];
}

- (void)receiveSysMessageDict:(NSDictionary *)dict {
    
    [UnreadMessagesNumSingle sharedInstance].sysMessageListNum += 1;
    
    if (![AppModel sharedInstance].turnOnSound) {
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
        [self.player play];
#endif
    }
    
    SysMessageListModel *model = [[SysMessageListModel alloc] init];
    model.userId = [AppModel sharedInstance].user_info.userId;
    model.type = [dict[@"type"] integerValue];
    model.title = dict[@"title"];
    model.content = dict[@"content"];
    model.updateTime = [dict[@"updateTime"] integerValue];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL isSuccess = [WHC_ModelSqlite insert:model];
        if (!isSuccess) {
            [WHC_ModelSqlite removeModel:[SysMessageListModel class]];
            [WHC_ModelSqlite insert:model];
        }
    });
    
    [self performSelector:@selector(sysNotificat) withObject:nil afterDelay:1];
    //    [self performSelectorOnMainThread:@selector(sysNotificat) withObject:nil waitUntilDone:YES];
}

- (void)sysNotificat {
    /// 系统消息列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kSysMessageListNotification object: @"kUpdateSysMessageList"];
    
}


#pragma mark -  未读历史消息数量
- (void)getHistoryMessageNum {
    
    NSString *queryWhere = [NSString stringWithFormat:@"userId='%ld'",(long)[AppModel sharedInstance].user_info.userId];
    NSArray *userGroupArray = [WHC_ModelSqlite query:[PushMessageNumModel class] where:queryWhere];
    
    for (NSInteger index = 0; index < userGroupArray.count; index++) {
        PushMessageNumModel *pmModel = (PushMessageNumModel *)userGroupArray[index];
        
        if (pmModel != nil && pmModel.sessionId != 0) {
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld", (long)pmModel.sessionId,(long)[AppModel sharedInstance].user_info.userId];
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







- (AVAudioPlayer *)player {
    if (!_player) {
        // 虽然传递的参数是NSURL地址, 但是只支持播放本地文件, 远程音乐文件路径不支持
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"af_sms-received.caf" withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //允许调整速率,此设置必须在prepareplay 之前
        _player.enableRate = YES;
        //        _player.delegate = self;
        
        //指定播放的循环次数、0表示一次
        //任何负数表示无限播放
        [_player setNumberOfLoops:0];
        //准备播放
        [_player prepareToPlay];
        
    }
    return _player;
}

@end
