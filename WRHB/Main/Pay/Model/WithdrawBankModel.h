//
//  BankModel.h
//  LotteryProduct
//
//  Created by vsskyblue on 2019/10/9.
//  Copyright © 2018年 vsskyblue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawBankModel : NSObject

/// 银行卡号
@property (nonatomic, copy) NSString *card;
/// 持卡人
@property (nonatomic, copy) NSString *cardholder;
/// 银行名称
@property (nonatomic, copy) NSString *bank_name;
/// 开户行
@property (nonatomic, copy) NSString *bank_address;


/// 选中
@property (nonatomic, assign) BOOL isSelected;
/// 到账时间
@property (nonatomic, copy) NSString *desTime;
/// 银行卡图标
@property (nonatomic , copy) NSString *icon;


@property (nonatomic , copy) NSString              * banktype;


//@property (nonatomic , copy) NSString              * account;
//@property (nonatomic , copy) NSString              * withdrawDepositTimes;
//@property (nonatomic , copy) NSString              * realName;
//@property (nonatomic , assign) NSInteger              ID;
//@property (nonatomic , assign) NSInteger              status;
//@property (nonatomic , assign) NSInteger              deleted;
//@property (nonatomic , copy) NSString              * bank;
//@property (nonatomic , copy) NSString              * cardNumber;
//@property (nonatomic , assign) NSInteger              memberId;
////@property (nonatomic , copy) NSString              * icon;
//@property (nonatomic , copy) NSString              * bindTime;
//@property (nonatomic , copy) NSString              * banktype;
@end
