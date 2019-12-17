//
//  ClubManageTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubManageTableViewCell.h"

@interface ClubManageTableViewCell()



@end

@implementation ClubManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubManageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIImageView *headView = [[UIImageView alloc] init];
    headView.image = [UIImage imageNamed:@"imageName"];
    [backView addSubview:headView];
    _headView = headView;
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(18);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(33);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithHex:@"#666666"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(headView.mas_right).offset(15);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"common_right_arrow"];
    [backView addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.size.mas_equalTo(18);
    }];
    
    UILabel *messageNumLabel = [[UILabel alloc] init];
    messageNumLabel.hidden = YES;
    messageNumLabel.text = @"";
    messageNumLabel.font = [UIFont systemFontOfSize:13];
    messageNumLabel.textColor = [UIColor whiteColor];
    messageNumLabel.layer.cornerRadius = 20/2;
    messageNumLabel.layer.masksToBounds = YES;
    messageNumLabel.backgroundColor = [UIColor redColor];
    messageNumLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:messageNumLabel];
    _messageNumLabel = messageNumLabel;
    
    [messageNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(iconView.mas_left).offset(-10);
        make.size.mas_equalTo(20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





