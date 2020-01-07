//
//  EnvelopeMessage.m
//  WRHB
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "EnvelopeMessage.h"


@implementation EnvelopeMessage

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"redp_id": @"packet", @"redpacketType": @"type"};
}

- (void)setRedPacket:(NSString *)redPacket {
    _redPacket = redPacket;
    _redp_id= redPacket;
}

@end
