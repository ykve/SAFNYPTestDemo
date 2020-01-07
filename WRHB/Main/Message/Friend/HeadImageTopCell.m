//
//  HeadImageTopCell.m
//  WRHB
//
//  Created by AFan on 2019/12/24.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "HeadImageTopCell.h"
#import "UserInfo.h"
#import "YPContacts.h"

@interface HeadImageTopCell ()

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *iDLabel;
@property (strong, nonatomic) UIImageView *genderImg;

@end



@implementation HeadImageTopCell

- (void)awakeFromNib {
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    HeadImageTopCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HeadImageTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setUserId:(NSInteger)userId {
    _userId = userId;
    
    NSString *userIdqe = [NSString stringWithFormat:@"%ld_%ld",userId,[AppModel sharedInstance].user_info.userId];
    YPContacts *contact = [[AppModel sharedInstance].myFriendListDict objectForKey:userIdqe];
    
    if (contact.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", contact.avatar]];
        if (image) {
            self.headImage.image =  image;
        } else {
            self.headImage.image =  [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImage cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:contact.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    self.nameLabel.text = contact.name;
    NSInteger sex = contact.sex;
    if(sex == 2) {
        self.genderImg.image = [UIImage imageNamed:@"me_male"];
    } else {
        self.genderImg.image = [UIImage imageNamed:@"me_female"];
    }
    
    self.nickLabel.text = [NSString stringWithFormat:@"昵称: %@", contact.nickName? contact.nickName : @""];
    self.iDLabel.text = [NSString stringWithFormat:@"ID: %zd",userId];
    
    
}


- (void)setupUI {
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    headImage.image = [UIImage imageNamed:@"cm_default_avatar"];
    [self.contentView addSubview:headImage];
    _headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(23);
        make.top.equalTo(self.mas_top).offset(20);
        make.size.mas_equalTo(@(64));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont boldSystemFontOfSize:22];
    nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_top).offset(-3);
        make.left.equalTo(headImage.mas_right).offset(20);
    }];
    
    UIImageView *genderImg = [[UIImageView alloc] init];
    genderImg.image = [UIImage imageNamed:@"me_gender_men"];
    [self.contentView addSubview:genderImg];
    _genderImg = genderImg;
    
    [genderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(8);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(@(12));
    }];
    
    UILabel *nickLabel = [[UILabel alloc] init];
    nickLabel.text = @"昵称:-";
    nickLabel.font = [UIFont systemFontOfSize:14];
    nickLabel.textColor = [UIColor colorWithHex:@"#777777"];
    [self.contentView addSubview:nickLabel];
    _nickLabel = nickLabel;
    
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImage.mas_centerY);
        make.left.equalTo(nameLabel.mas_left);
    }];
    
    UILabel *iDLabel = [[UILabel alloc] init];
    iDLabel.text = @"ID:-";
    iDLabel.font = [UIFont systemFontOfSize:14];
    iDLabel.textColor = [UIColor colorWithHex:@"#777777"];
    [self.contentView addSubview:iDLabel];
    _iDLabel = iDLabel;
    
    [iDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImage.mas_bottom);
        make.left.equalTo(nameLabel.mas_left);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


