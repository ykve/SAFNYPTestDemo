//
//  PayTopupRecordCell.m
//  WRHB
//
//  Created by AFan on 2019/12/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopupRecordCell.h"
#import "BillItem.h"
#import "BillItemModel.h"
#import "UIButton+GraphicBtn.h"

@interface PayTopupRecordCell()
/// 充值渠道背景图
@property (nonatomic, strong) UIImageView *bgImgView;
/// 时间
@property (nonatomic, strong) UILabel *date;
/// 账单类型名称
@property (nonatomic, strong) UILabel *typeName;
/// 数目
@property (nonatomic, strong) UILabel *money;
/// 充值渠道
@property (nonatomic, strong) UILabel *channelNameLabel;

@end

@implementation PayTopupRecordCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    PayTopupRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PayTopupRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}




- (void)setModel:(BillItemModel *)model {
    _model = model;
    
    BOOL b = [model.number containsString:@"-"];
    self.money.textColor = (b)?HexColor(@"#ff4646"):HexColor(@"#369b3c");
    self.money.text = [NSString stringWithFormat:@"￥%@" ,model.number];
    
    self.date.text = dateString_stamp(model.created_at, CDDateSeconds);
    self.typeName.text = model.title;
    
    if (model.method == 1) {  /// 支付宝
        self.channelNameLabel.text = @"支付宝充值";
    } else if (model.method == 2) {  /// 微信
        self.channelNameLabel.text = @"微信充值";
    } else if (model.method == 3) {  /// 银行卡
        self.channelNameLabel.text = @"银行卡充值";
    } else if (model.method == 4) {  /// 人工充值
        self.channelNameLabel.text = @"人工充值";
    } else if (model.method == 5) {  /// 赠送彩金
        self.channelNameLabel.text = @"赠送彩金";
    } else {
        self.channelNameLabel.text = @"其它";
    }
    
    
    if (model.type == BillType_RenGongShangFen_Topup) {  // 人工
        self.bgImgView.image = [UIImage imageNamed:@"pay_rg_bg"];
    } else if (model.type == BillType_WangGuan_Topup) {  // 网关
         self.bgImgView.image = [UIImage imageNamed:@"pay_wg_bg"];
    } else if (model.type == BillType_YS_Topup) {  // 盈商
        self.bgImgView.image = [UIImage imageNamed:@"pay_ys_bg"];
    } else if (model.type == BillType_Vip_Topup) {   // VIP
        self.bgImgView.image = [UIImage imageNamed:@"pay_vip_bg"];
    } else if (model.type == BillType_Lottery_Topup) {  // 赠送彩金
        self.bgImgView.image = [UIImage imageNamed:@"pay_rg_bg"];
    } else {
        self.bgImgView.image = [UIImage imageNamed:@"pay_rg_bg"];
    }
}

#pragma mark ----- subView
- (void)setupSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(2);
        make.right.equalTo(self.contentView.mas_right).offset(-2);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
    }];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"pay_vip_bg"];
    [backView addSubview:bgImgView];
    _bgImgView = bgImgView;
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(backView);
    }];
    
    
    _typeName = [UILabel new];
    _typeName.textAlignment = NSTextAlignmentCenter;
    [bgImgView addSubview:_typeName];
    _typeName.font = [UIFont systemFontOfSize:12];
    _typeName.textColor = [UIColor whiteColor];
    
    [_typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImgView.mas_left).offset(10);
        make.top.equalTo(bgImgView.mas_top).offset(13);
        make.width.mas_equalTo(70);
    }];
    
    _date = [UILabel new];
    [bgImgView addSubview:_date];
    _date.textColor = [UIColor colorWithHex:@"#999999"];
    _date.font = [UIFont systemFontOfSize2:11];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImgView.mas_right).offset(-20);
        make.top.equalTo(bgImgView.mas_top).offset(20);
    }];
    
    /// 充值渠道
    UILabel *channelNameLabel = [[UILabel alloc] init];
    channelNameLabel.text = @"dfsfdsd";
    channelNameLabel.font = [UIFont systemFontOfSize:16];
    channelNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [bgImgView addSubview:channelNameLabel];
    _channelNameLabel = channelNameLabel;
    
    [channelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgImgView.mas_bottom).offset(-20);
        make.left.equalTo(bgImgView.mas_left).offset(20);
    }];
    
    _money = [UILabel new];
    _money.textAlignment = NSTextAlignmentRight;
    [bgImgView addSubview:_money];
    _money.font = [UIFont systemFontOfSize2:18];
    _money.textColor = HexColor(@"#369b3c");
    
    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImgView.mas_right).offset(-20);
        make.bottom.equalTo(bgImgView.mas_bottom).offset(-20);
    }];
    
}

/// 查看详情
- (void)onSeeDetails {
    if (self.onSeeDetailsBlock) {
        self.onSeeDetailsBlock(self.model);
    }
}



@end
