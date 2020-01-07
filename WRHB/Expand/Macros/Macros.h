//
//  Macros.h
//  WRHB
//
//  Created by AFan on 2019/9/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

static NSString * const kServerUrl  = @"https://api.wr689.com/api/";
static NSString * const kWXKey = @"wx6855b12dbf3d7a06";
static NSString * const kWXSecret = @"3da5d9957cbc82685512002aac39e3f0";
static NSString * const kTenant = @"af_pig_test";
static NSString * const kMTAKey = @"IKAM6P7U2J7C";
static NSString * const kBaseKey = @"YXBwOmFwcA==";

/// Pusher 正式
static NSString * const kPusherKey = @"5b4078897a54dfcec98e";
/// Pusher 测试
static NSString * const kPusherKeyTest = @"1de35942831b786afc4d";


/// WS 正式
static NSString * const kWSSocketURL = @"https://im.wr689.com:8443";
/// WS 测试
static NSString * const kWSSocketURLTest = @"ws://192.168.177.5:8002";


/////////////////////////////////////////////////////////////////////////
// 测试服务器地址

static NSString * const kTestServerURLJson = @"[\
{\"apiUrl\":\"http://192.168.177.2:8004/api/\",\"isBeta\":\"1\",\"baseKey\":\"YXBwOmFwcA==\"},\
{\"apiUrl\":\"http://10.10.95.176:8099/\",\"isBeta\":\"1\",\"baseKey\":\"YXBwOmFwcA==\"},\
]";//10.10.95.191:8099//


/// 玩法规则
static NSString * const kWanFaJieSaoURL = @"https://wr869.com/#/h5/playmethod/wdwf";
/// 代理规则
static NSString * const kAgentRuleURL = @"https://wr869.com/#/h5/playmethod/agentIntroduction";


#endif /* Macros_h */
