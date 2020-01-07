//
//  BankModel.m
//  LotteryProduct
//
//  Created by vsskyblue on 2019/10/9.
//  Copyright © 2018年 vsskyblue. All rights reserved.
//

#import "WithdrawBankModel.h"

@implementation WithdrawBankModel

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}

-(void)setCard:(NSString *)card {
    _card = card;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    for(NSDictionary *dic in arr)
    {
        NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dic[@"regex"]];
        
        BOOL flag = [regextest evaluateWithObject:card];
        
        if(flag)
        {
            self.banktype = [self getBankTypeName:dic[@"bankType"]];

            break;
        }
    }
}

-(NSString *)getBankTypeName:(NSString *)bankType
{
    NSString *typeName = [[NSString alloc]init];
    if([bankType isEqualToString:@"CC"])
    {
        typeName = @"信用卡";
    }
    else if([bankType isEqualToString:@"PC"])
    {
        typeName = @"预付费卡";
    }
    else if([bankType isEqualToString:@"SCC"])
    {
        typeName = @"准贷记卡";
    }
    else if([bankType isEqualToString:@"DC"])
    {
        typeName = @"储蓄卡";
    }
    
    return typeName;
}

@end
