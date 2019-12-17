//
//  Public.h
//  FreeFare
//
//  Created by wc on 14-4-29.
//  Copyright (c) 2014年 wc All rights reserved.
//


#define INT_TO_STR(x) [NSString stringWithFormat:@"%ld",(long)x]
#define STR_TO_AmountFloatSTR(x) [NSString stringWithFormat:@"%.2f",[x doubleValue]]
#define NUMBER_TO_STR(a) [a isKindOfClass:[NSString class]]?a:[a stringValue]


#define WEAK_OBJ(weakObj,obj) __weak __typeof(obj)weakObj = obj;


typedef void (^CallbackBlock)(id object);
typedef void (^ActionBlock)(id data);
typedef void (^TypeBlock)(NSInteger type);


typedef NS_ENUM(NSInteger, RewardType){
    RewardType_nil,
    RewardType_bzsz = 6000,//豹子顺子奖励
    RewardType_ztlsyj = 5000,//直推流水佣金
    RewardType_yqhycz = 1110,//邀请好友充值
    RewardType_czjl = 1100,//充值奖励
    RewardType_ecjl = 1200,//二充奖励 未知类处理
    RewardType_fbjl = 3000,//发包奖励
    RewardType_qbjl = 4000,//抢包奖励
    RewardType_jjj = 7000,//救济金
    RewardType_zcdljl = 2100,//注册登录奖励
};

typedef NS_ENUM(NSUInteger,EnumActionTag){
    EnumActionTag0 = 0 ,
    EnumActionTag1  ,
    EnumActionTag2  ,
    EnumActionTag3  ,
    EnumActionTag4  ,
    EnumActionTag5  ,
    EnumActionTag6  ,
    EnumActionTag7  ,
    EnumActionTag8  ,
    EnumActionTag9  ,
    EnumActionTag10  ,
    EnumActionTag11  ,
    EnumActionTag12
};

#define WXShareDescription [NSString stringWithFormat:@"我的邀请码是%zd",[AppModel sharedInstance].user_info.userId]

#define PUSH_C(viewController,targetViewController,animation) targetViewController *vc = [[targetViewController alloc] init]; vc.hidesBottomBarWhenPushed = YES; [viewController.navigationController pushViewController:vc animated:animation];

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

///<页面背景色
#define BaseColor HexColor(@"#F6F6F6")
///<导航栏背景色
#define Color_3 HexColor(@"#333333")

///<分割线颜色
#define TBSeparaColor HexColor(@"#EBEBEB")
///<提交按钮颜色
#define MBTNColor HexColor(@"#FE3962")//ff3833  a971fb

#define SexBack HexColor(@"#6cd1f1")

// 黑色
#define Color_0 HexColor(@"#1E1E1E")
#define Color_3 HexColor(@"#333333")
#define Color_6 HexColor(@"#666666")
#define Color_9 HexColor(@"#999999")


#define COLOR_X(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#pragma mark - UserDefault

#define GetUserDefaultWithKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#pragma mark - 沙盒路径
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString * const kJSPatchURL = @"https://www.520qun.com";

#define kSendRPTitleCellWidth 80
#define kTopupWebCellHeight 220

#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil
#endif

