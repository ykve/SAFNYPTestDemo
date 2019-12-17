//
//  NSString+AFString.m
//  WRHB
//
//  Created by AFan on 2019/12/14.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "NSString+AFString.h"

@implementation NSString (AFString)

+ (NSString *)noNullStringWith:(id)dataString
{
    NSString *nullString = dataString;
    if ([nullString isKindOfClass:[NSString class]] && nullString.length) {
        return nullString;
    } else {
        return @"";
    }
}

@end
