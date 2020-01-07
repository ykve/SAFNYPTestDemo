//
//  RecommendCell.m
//  WRHB
//
//  Created by AFan on 2019/11/2.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "SubUserCell.h"
#import "UIView+AZGradient.h"  // 渐变色
#import "Sub_Users.h"
#import "Sub_Recharge.h"

@interface SubUserCell(){
    UIImageView *_headIcon;
    UIImageView *_sexIcon;
    UILabel *_name;
    UILabel *_iDLabel;
    UIImageView *_bgImgView;
    UIImageView *_agentImg;
}
@end

@implementation SubUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SubUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SubUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setModel:(Sub_Users *)model {
    _model = model;
    
    if (model.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            _headIcon.image =  image;
        } else {
            _headIcon.image =  [UIImage imageNamed:@"mes_group_head"];
        }
    } else {
        [_headIcon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"mes_group_head"]];
    }
    
    _agentImg.hidden = YES;
    if (model.is_agent) {
        _agentImg.hidden = NO;
    }
    
    _name.text = model.name;
    _iDLabel.text = [NSString stringWithFormat:@"ID:%zd", model.user_id];
    
    UIView *view1 = [_bgImgView viewWithTag:10];
    UILabel *label1 = [view1 viewWithTag:2];
    
    UIView *view2 = [_bgImgView viewWithTag:11];
    UILabel *label2 = [view2 viewWithTag:2];
    
    UIView *view3 = [_bgImgView viewWithTag:12];
    UILabel *label3 = [view3 viewWithTag:2];
    
    label1.text = model.recharge.number ? model.recharge.number : @"0";
    label2.text = model.capital ? model.capital : @"0";
    label3.text = model.commission ? model.commission : @"0";
}



#pragma mark ----- subView
- (void)setupSubViews{
    
    self.backgroundColor = BaseColor;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHex:@"#F2F2F2"];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.image = [UIImage imageNamed:@"sub_bg"];
    [backView addSubview:bgImgView];
    _bgImgView = bgImgView;
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(backView);
    }];
    
    
    _headIcon = [UIImageView new];
    [bgImgView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 60/2;
    _headIcon.layer.masksToBounds = YES;
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(10));
        make.size.mas_equalTo(60);
    }];
    
    UIImageView *agentImg = [[UIImageView alloc] init];
    agentImg.hidden = YES;
    agentImg.image = [UIImage imageNamed:@"sub_agent"];
    [bgImgView addSubview:agentImg];
    _agentImg = agentImg;
    
    [agentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self->_headIcon.mas_bottom).offset(5);
        make.centerX.equalTo(self->_headIcon.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(56, 17));
    }];
    
    _name = [UILabel new];
    [bgImgView addSubview:_name];
    _name.font = [UIFont boldSystemFontOfSize:18];
    _name.textColor = [UIColor colorWithHex:@"#333333"];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(10);
        make.top.equalTo(self->_headIcon.mas_top).offset(5);
    }];
    
    _iDLabel = [UILabel new];
    [bgImgView addSubview:_iDLabel];
    _iDLabel.font = [UIFont systemFontOfSize2:15];
    _iDLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [_iDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_name.mas_left);
        make.bottom.equalTo(self->_headIcon.mas_bottom).offset(-5);
    }];
    
    _detailButton = [UIButton new];
    [bgImgView addSubview:_detailButton];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize2:12];
    [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [_detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 3;
    [_detailButton az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF4444"],[UIColor colorWithHex:@"#FF8484"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgImgView).offset(-30);
        make.centerY.equalTo(self->_headIcon.mas_centerY);
        make.height.equalTo(@29);
        make.width.equalTo(@70);
    }];
    
    UIView *view1 = [self viewForNum:@"" title:@"总充值"];
    [bgImgView addSubview:view1];
    view1.tag = 10;
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImgView.mas_left);
        make.width.equalTo(bgImgView.mas_width).multipliedBy(0.333);
        make.height.equalTo(@45);
        make.centerY.equalTo(@30);
    }];
    
    UIView *view2 = [self viewForNum:@"" title:@"总流水"];
    [bgImgView addSubview:view2];
    view2.tag = 11;
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view1.mas_right);
        make.width.equalTo(bgImgView.mas_width).multipliedBy(0.333);
        make.height.equalTo(@45);
        make.centerY.equalTo(@30);
    }];
    
    UIView *view3 = [self viewForNum:@"" title:@"生成佣金"];
    [bgImgView addSubview:view3];
    view3.tag = 12;
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view2.mas_right);
        make.width.equalTo(bgImgView.mas_width).multipliedBy(0.333);
        make.height.equalTo(@45);
        make.centerY.equalTo(@30);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(UIView *)viewForNum:(NSString *)num title:(NSString *)title{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:15];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(-10);
    }];
    titleLabel.text = num;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize2:13];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:titleLabel];
    titleLabel.tag = 3;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY).offset(10);
    }];
    titleLabel.text = title;
    
    return view;
}

@end
