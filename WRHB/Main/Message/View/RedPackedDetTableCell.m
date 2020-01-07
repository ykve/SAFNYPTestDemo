//
//  EnvelopTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/9/3.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "RedPackedDetTableCell.h"
#import "EnvelopeNet.h"

#import "GrabPackageInfoModel.h"

@interface RedPackedDetTableCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIImageView *sex;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *maxImgView;
@property (nonatomic, strong) UIImageView *mineImageView;
//
@property (nonatomic, strong) UIImageView *bankerImageView;
@property (nonatomic, strong) UIImageView *pointsNumImageView;
@property (nonatomic, strong) UILabel *pointLabel;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *mineMoneyLabel;



@end

@implementation RedPackedDetTableCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    RedPackedDetTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RedPackedDetTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    self.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    _backView = backView;
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView.mas_right);
        make.bottom.equalTo(backView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    
    _headImageView = [UIImageView new];
    [backView addSubview:_headImageView];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(15);
        make.centerY.equalTo(self.backView);
        make.height.width.equalTo(@(40));
    }];
    
    _name = [UILabel new];
    [backView addSubview:_name];
    _name.textColor = Color_3;
    _name.font = [UIFont systemFontOfSize2:15];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.top.equalTo(self.headImageView.mas_top);
    }];
    
    
    _bankerImageView = [[UIImageView alloc] init];
    _bankerImageView.image = [UIImage imageNamed:@"cow_banker"];
    _bankerImageView.hidden = YES;
    [backView addSubview:_bankerImageView];
    
    [_bankerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_right).offset(5);
        make.centerY.equalTo(self.name.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36, 18));
    }];
    
    _date = [UILabel new];
    [backView addSubview:_date];
    _date.textColor = Color_9;
    _date.font = [UIFont systemFontOfSize2:12];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(11);
        make.top.equalTo(self ->_name.mas_bottom).offset(6);
    }];
    
    _pointsNumImageView = [[UIImageView alloc] init];
//    _pointsNumImageView.backgroundColor = [UIColor greenColor];
    _pointsNumImageView.hidden = NO;
    [backView addSubview:_pointsNumImageView];
    
    [_pointsNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.top.equalTo(backView.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(11.5, 11));
    }];
    
    _pointLabel = [UILabel new];
    [_pointsNumImageView addSubview:_pointLabel];
    _pointLabel.textColor = [UIColor whiteColor];
    _pointLabel.font = [UIFont boldSystemFontOfSize:9];
    
    [_pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_pointsNumImageView.mas_centerY).offset(1);
        make.centerX.equalTo(self->_pointsNumImageView.mas_centerX);
    }];
    
    
    
    _moneyLabel = [UILabel new];
//    _moneyLabel.backgroundColor = [UIColor redColor];
    [backView addSubview:_moneyLabel];
    _moneyLabel.textColor = Color_3;
    _moneyLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.top.equalTo(backView.mas_top).offset(15);
    }];
    
    
    
    
    _mineImageView = [UIImageView new];
    _mineImageView.hidden = YES;
    [backView addSubview:_mineImageView];
    _mineImageView.image = [UIImage imageNamed:@"mess_bomb"];
    
    [_mineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-90);
        make.top.equalTo(self.backView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    
    _mineMoneyLabel = [UILabel new];
    [backView addSubview:_mineMoneyLabel];
    _mineMoneyLabel.textColor = Color_3;
    _mineMoneyLabel.font = [UIFont systemFontOfSize:14];
    
    [_mineMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_mineImageView.mas_centerX);
        make.top.equalTo(self->_mineImageView.mas_bottom).offset(2);
    }];
    
    UIView *maxBackView = [[UIView alloc] init];
    maxBackView.hidden = YES;
//    maxBackView.backgroundColor = [UIColor greenColor];
    [backView addSubview:maxBackView];
    _maxImgView = maxBackView;
    [maxBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.centerY.equalTo(self ->_date.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    
    UILabel *ccLabel = [[UILabel alloc] init];
    ccLabel.text = @"财气最旺";
    ccLabel.font = [UIFont systemFontOfSize:10];
    ccLabel.textColor = [UIColor colorWithHex:@"#FF9D3E"];
    ccLabel.textAlignment = NSTextAlignmentRight;
    [maxBackView addSubview:ccLabel];
    
    [ccLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(maxBackView.mas_centerY);
        make.right.equalTo(maxBackView.mas_right);
    }];
    
    UIImageView *maxImg = [UIImageView new];
    [maxBackView addSubview:maxImg];
    maxImg.image = [UIImage imageNamed:@"icon_luck_max"];

    [maxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ccLabel.mas_left).offset(-6);
        make.centerY.equalTo(self ->_date.mas_centerY);
    }];
    
    
    
}

- (void)setModel:(GrabPackageInfoModel *)model {
    _model = model;
    
    if (model.is_sender) {
        self.backView.backgroundColor = [UIColor colorWithHex:@"#FFE4E4"];
    }
    
    if (model.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            _headImageView.image = image;
        } else {
            _headImageView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [_headImageView cd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    NSString *money = model.value;
    NSString *nickname = model.name;
    
    _date.text = dateString_stamp(model.grab_at,nil);
    
    _name.textColor = Color_3;
    if ([nickname isEqualToString:@"免死"]) {
        _name.textColor = [UIColor colorWithHex:@"#FFD700"];
    }
    _name.text = (![nickname isKindOfClass:[NSNull class]]) ? nickname:@"-";
    _moneyLabel.text = (![money isKindOfClass:[NSNull class]]) ? money : @"-";
    
    if (self.redpacketType == RedPacketType_CowCowNoDouble || self.redpacketType == RedPacketType_CowCowDouble) { // 牛牛红包
        
        if (model.nn_type == 10) {
            self.pointsNumImageView.image = [UIImage imageNamed:@"cow_nn"];
            self.pointLabel.text = @"";
        } else if (model.nn_type > 0) {
            self.pointsNumImageView.image = [UIImage imageNamed:@"cow_num"];
            self.pointLabel.text = [NSString stringWithFormat:@"%ld", model.nn_type];
        } else {
            self.pointsNumImageView.image = [UIImage imageNamed:@"cow_num"];
            self.pointLabel.text = @"";
            self.pointsNumImageView.hidden = YES;
        }
        
        
        [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right).offset(-30);
            make.top.equalTo(self.backView.mas_top).offset(12);
        }];
        
        _bankerImageView.hidden = model.is_banker ? NO : YES;
        
        self.pointsNumImageView.hidden = NO;
        _mineImageView.hidden = YES;
        _maxImgView.hidden = YES;
    } else {
        
        [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backView.mas_right).offset(-15);
            make.top.equalTo(self.backView.mas_top).offset(15);
        }];
        
        self.pointsNumImageView.hidden = YES;
        _maxImgView.hidden = model.isLuck ? NO : YES;
        
        if (self.redpacketType == RedPacketType_SingleMine || self.redpacketType == RedPacketType_BanRob) {
            _mineImageView.hidden = model.got_mime ? NO : YES;
        }
        
        self.mineMoneyLabel.text = @"";
        if ([model.mime floatValue] != 0) {
            self.mineMoneyLabel.text = model.mime;
        }
        
    }
}


- (void)redXingWithLabel:(UILabel *)tempLabel atIndex:(NSInteger)tempIndex {
    NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString: tempLabel.text];
    [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(tempIndex, 1)];
    tempLabel.attributedText = tempString;
}
@end
