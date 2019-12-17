//
//  ClubModel.m
//  WRHB
//
//  Created by AFan on 2019/11/30.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubModel.h"

@implementation ClubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID": @"id"};
}

- (void)setID:(NSInteger)ID {
    _ID = ID;
    _club_id = ID;
}

- (void)setName:(NSString *)name {
    _name = name;
    _club_name = name;
}

@end
