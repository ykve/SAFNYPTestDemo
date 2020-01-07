//
//  RedPacketDetListModel.m
//  WRHB
//
//  Created by AFan on 2019/10/10.
//  Copyright © 2019 AFan. All rights reserved.
//
#import "SenderModel.h"

#import "RedPacketDetModel.h"

@implementation RedPacketDetModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"redpacketType": @"type", @"packetId": @"packet"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"grab_logs" : @"GrabPackageInfoModel",
             @"summary" : @"PopSummaryModel"
             };
}

-(void)setGraber:(GrabPackageInfoModel *)graber
{
    _graber = graber;
    if (graber!=nil) {
        self.grab_logs = @[graber];
    }
}


- (void)setBanker_info:(SenderModel *)banker_info {
    _banker_info = banker_info;
    _sender = banker_info;
}
@end
