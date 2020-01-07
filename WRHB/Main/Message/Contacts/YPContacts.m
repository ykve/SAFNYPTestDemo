//
//  Contacts.m
//  WRHB
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YPContacts.h"

@implementation YPContacts

MJCodingImplementation

- (id)initWithPropertiesDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if (dic != nil) {
            // tox_id  忽略
            self.user_id = [[dic objectForKey:@"user_id"] integerValue];
            self.name = [dic objectForKey:@"name"];
            self.avatar = [dic objectForKey:@"avatar"];
            self.sex = [[dic objectForKey:@"sex"] integerValue];
            self.nickName = [dic objectForKey:@"mark"] != [NSNull null] ? [dic objectForKey:@"mark"] : @"";
        }
    }
    
    return self;
}


@end
