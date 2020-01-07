//
//  YSTopupListCell.m
//  WRHB
//
//  Created by AFan on 2019/12/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "YSTopupListCell.h"
#import "YSTopupListModel.h"
#import "UIView+AZGradient.h"   // 渐变色


@interface YSTopupListCell()
/// 头像
@property (nonatomic, strong) UIImageView *headView;
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// vip等级
@property (nonatomic, strong) UILabel *vipLabel;
/// 评分
@property (nonatomic, strong) UILabel *pfLabel;
/// 评分星星背景View
@property (nonatomic, strong) UIView *pfBackView;
/// 支付类型
@property (nonatomic, strong) UIImageView *payTypeImg;
/// 支持支付银行背景View
@property (nonatomic, strong) UIView *topView;

@end

@implementation YSTopupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    YSTopupListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[YSTopupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}



/**
 充值
 */
- (void)onSubmitBtn {
    
}

- (void)setModel:(YSTopupListModel *)model {
    _model = model;
    
    NSString *title= [NSString stringWithFormat:@"%@（%@）", model.name, model.is_online == 1 ? @"在线" : @"离线"];
    self.titleLabel.text = title;
    
    for (NSInteger index= 1; index <= model.account_types.count; index++) {
        NSInteger type = [model.account_types[index-1] integerValue];
        UIImageView *imageView = [[UIImageView alloc] init];
        // 图片不会被拉伸，位于控件中间,如果图片尺寸大于控件尺寸，内容会超出边框
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(kSCREEN_WIDTH - 15*2 - (30+10)*index, 5, 30, 30);
        if (type == 1) {    /// 支付宝
            //            [imageView setImage:[UIImage imageNamed:@"pay_alipay"] forState:UIControlStateNormal];
            imageView.image = [UIImage imageNamed:@"pay_alipay"];
        } else if (type == 2) {  /// 微信
            //            [imageView setImage:[UIImage imageNamed:@"pay_alipay"] forState:UIControlStateNormal];
            imageView.image = [UIImage imageNamed:@"pay_wxpay"];
        } else {
            //            [imageView setImage:[UIImage imageNamed:@"pay_alipay"] forState:UIControlStateNormal];
            imageView.image = [UIImage imageNamed:@"pay_bank_iocn"];
        }
        [self.topView addSubview:imageView];
    }
    
    
    if (model.avatar.length < kAvatarLength) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            self.headView.image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        } else {
            self.headView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
        
    } else {
        [self.headView cd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    self.vipLabel.text = [NSString stringWithFormat:@"VIP%zd", model.level_id];
    
    
    NSString *scoreStr = [NSString stringWithFormat:@"%.1f",model.score];
    self.pfLabel.text = scoreStr;
    BOOL isMid = scoreStr.length > 1 ? YES : NO;
    for (NSInteger index= 0; index < 5; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((15+3)*index, 0, 15, 15);
        if (isMid && index == 4) {
            imageView.image = [UIImage imageNamed:@"pay_xxmid"];
        } else {
            imageView.image = [UIImage imageNamed:@"pay_xxall"];
        }
        [self.pfBackView addSubview:imageView];
    }
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIView *topView = [[UIView alloc] init];
    // 渐变色
    [topView az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#EF7060"],[UIColor colorWithHex:@"#FDAAA1"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [backView addSubview:topView];
    _topView = topView;
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.height.mas_equalTo(40);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [topView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).offset(10);
    }];
    
    
    UIImageView *headView = [[UIImageView alloc] init];
    headView.layer.cornerRadius = 5;
    headView.layer.masksToBounds = YES;
    headView.image = [UIImage imageNamed:@""];
    [backView addSubview:headView];
    _headView = headView;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.size.mas_equalTo(60);
    }];
    
    /// 官方认证
    UIImageView *gfrzView = [[UIImageView alloc] init];
    gfrzView.image = [UIImage imageNamed:@"pay_gfrz"];
    [backView addSubview:gfrzView];
    
    [gfrzView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_right).offset(15);
        make.top.equalTo(headView.mas_top).offset(2);
        make.size.mas_equalTo(20);
    }];
    
    UILabel *gfLabel = [[UILabel alloc] init];
    gfLabel.text = @"官方认证";
    gfLabel.font = [UIFont systemFontOfSize:15];
    gfLabel.textColor = [UIColor colorWithHex:@"#5BB878"];
    [backView addSubview:gfLabel];
    
    [gfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gfrzView.mas_centerY);
        make.left.equalTo(gfrzView.mas_right).offset(8);
    }];
    
    /// vip
    UIImageView *vipImgView = [[UIImageView alloc] init];
    vipImgView.image = [UIImage imageNamed:@"pay_vip"];
    [backView addSubview:vipImgView];
    
    [vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gfrzView.mas_centerY);
        make.left.equalTo(gfLabel.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(21, 19));
    }];
    
    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.text = @"-";
    vipLabel.font = [UIFont systemFontOfSize:15];
    vipLabel.textColor = [UIColor colorWithHex:@"#FFC000"];
    [backView addSubview:vipLabel];
    _vipLabel = vipLabel;
    
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gfrzView.mas_centerY);
        make.left.equalTo(vipImgView.mas_right).offset(10);
    }];
    
    /// 评分View
    UIView *pfBackView = [[UIView alloc] init];
//    pfBackView.backgroundColor = [UIColor greenColor];
    [backView addSubview:pfBackView];
    _pfBackView = pfBackView;
    
    [pfBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom).offset(-2);
        make.left.equalTo(headView.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake((15+3)*5, 15));
    }];
    
    
    
    UILabel *pfLabel = [[UILabel alloc] init];
    pfLabel.text = @"-";
    pfLabel.font = [UIFont systemFontOfSize:16];
    pfLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:pfLabel];
    _pfLabel = pfLabel;
    
    [pfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom).offset(-2);
        make.left.equalTo(pfBackView.mas_right).offset(10);
    }];
    
    
    UILabel *cczLabel = [[UILabel alloc] init];
    cczLabel.text = @"充值";
    cczLabel.font = [UIFont systemFontOfSize:16];
    cczLabel.textAlignment = NSTextAlignmentCenter;
    cczLabel.textColor = [UIColor whiteColor];
    cczLabel.layer.cornerRadius = 5;
    cczLabel.backgroundColor = [UIColor colorWithHex:@"#EF7060"];
    cczLabel.layer.masksToBounds = YES;
    [backView addSubview:cczLabel];
    
    [cczLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    
//    UIButton *submitBtn = [[UIButton alloc] init];
//    [submitBtn setTitle:@"充值" forState:UIControlStateNormal];
//    submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [submitBtn addTarget:self action:@selector(onSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
//    submitBtn.backgroundColor = [UIColor colorWithHex:@"#EF7060"];
//    submitBtn.layer.cornerRadius = 5;
//    submitBtn.layer.masksToBounds = YES;
//    submitBtn.tag = 3330;
//    [backView addSubview:submitBtn];
//    [submitBtn delayEnable];
//
//    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(headView.mas_bottom);
//        make.right.equalTo(backView.mas_right).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(70, 30));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

