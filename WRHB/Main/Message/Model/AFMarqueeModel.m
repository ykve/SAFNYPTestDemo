//
//  AFMarqueeModel.m
//  WRHB
//
//  Created by AFan on 2018/3/15.
//  Copyright © 2019年 AFan. All rights reserved.
//

#import "AFMarqueeModel.h"

@implementation AFMarqueeModel

-(void)setTitle:(NSString *)title{
    
    _title = title;
    
    self.titleWidth = [self widthForTitle];
    self.width = 10 + 30 + 5 + self.titleWidth + 10;
}

-(CGFloat)widthForTitle{
    return [self.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
}

-(BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]]) {
        AFMarqueeModel *obj = (AFMarqueeModel *)object;
        
        return self.width == obj.width &&
        [self.userImg isEqualToString:obj.userImg]&&
        [self.title isEqualToString:obj.title]&&
        self.titleWidth == obj.titleWidth ;
    }else{
        return NO;
    }
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
