//
//  BanklistCell.m
//  LotteryProduct
//
//  Created by vsskyblue on 2019/10/10.
//  Copyright © 2018年 vsskyblue. All rights reserved.
//

#import "BanklistCell.h"

@implementation BanklistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [[UIImageView alloc]init];
        _backImage.userInteractionEnabled = YES;
        [self addSubview:_backImage];
    }
    return _backImage;
}

-(UIImageView *)bankIconImage {
    
    if (!_bankIconImage) {
        _bankIconImage = [[UIImageView alloc]init];
        [self addSubview:_bankIconImage];
    }
    return _bankIconImage;
}

-(UILabel *)banknamelab {
    
    if (!_banknamelab) {
        _banknamelab = [[UILabel alloc] init];
        _banknamelab.text = @"-";
        _banknamelab.font = [UIFont systemFontOfSize:15];
        _banknamelab.textColor = [UIColor whiteColor];
        _banknamelab.textAlignment = NSTextAlignmentLeft;
        [self.backImage addSubview:_banknamelab];
    }
    return _banknamelab;
}

-(UILabel *)banktypelab {
    
    if (!_banktypelab) {
        _banktypelab = [[UILabel alloc] init];
        _banktypelab.text = @"-";
        _banktypelab.font = [UIFont systemFontOfSize:20];
        _banktypelab.textColor = [UIColor whiteColor];
        _banktypelab.alpha = 0.5;
        _banktypelab.textAlignment = NSTextAlignmentLeft;
        [self.backImage addSubview:_banktypelab];
    }
    return _banktypelab;
}

-(UILabel *)bankCardNumLabel {
    
    if (!_bankCardNumLabel) {
        
        _bankCardNumLabel = [[UILabel alloc] init];
        _bankCardNumLabel.text = @"-";
        _bankCardNumLabel.font = [UIFont systemFontOfSize:24];
        _bankCardNumLabel.textColor = [UIColor whiteColor];
        _bankCardNumLabel.textAlignment = NSTextAlignmentLeft;
        [self.backImage addSubview:_bankCardNumLabel];
    }
    return _bankCardNumLabel;
}

-(UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] init];
        [_exitBtn addTarget:self action:@selector(exitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_exitBtn setImage:[UIImage imageNamed:@"me_pay_close"] forState:UIControlStateNormal];
        [self.backImage addSubview:_exitBtn];
    }
    return _exitBtn;
}

- (void)setModel:(WithdrawBankModel *)model {
    _model = model;
    
//    self.backImage.image = indexPath.row%2 == 0 ? [UIImage imageNamed:@"me_pay_bankcard_bg"] : [UIImage imageNamed:@"me_pay_bankcard_bg"];
    self.backImage.image =  [UIImage imageNamed:@"me_pay_bankcard_bg"];
    //    [cell.iconimgv sd_setImageWithURL:IMAGEPATH(model.icon) placeholderImage:IMAGE(@"wallet_card_icon") options:SDWebImageRefreshCached];
    self.bankIconImage.image = [UIImage imageNamed:@"me_pay_jianshe_icon"];
    
    self.banknamelab.text = model.bank_name == nil ? @"中国银行" : model.bank_name;
    
    self.banktypelab.text = model.banktype == nil ? @"储蓄卡" : model.banktype;
    
    self.bankCardNumLabel.text = [model.card stringByReplacingOccurrencesOfString:[model.card substringToIndex:model.card.length-4] withString:@"*** **** ***"];
}


#pragma mark -  删除银行卡
- (void)exitBtn:(UIButton *)sender {
    if (self.deleteBankCardBlock) {
        self.deleteBankCardBlock(self.model);
    }
}

-(void)layoutSubviews {
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backImage.mas_top).offset(30);
        make.right.equalTo(self.backImage.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.bankIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImage.mas_left).offset(35);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.top.equalTo(self.backImage.mas_top).offset(25);
    }];
    
    [self.banknamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankIconImage.mas_centerY);
        make.left.equalTo(self.bankIconImage.mas_right).offset(10);
    }];
    
    [self.banktypelab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bankIconImage.mas_left);
        make.top.equalTo(self.bankCardNumLabel.mas_bottom).offset(15);
    }];
    
    [self.bankCardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImage.mas_centerX);
        make.centerY.equalTo(self.backImage.mas_centerY).offset(-6);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
