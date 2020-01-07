//
//  FriendChatInfoHeadCell.m
//  WRHB
//
//  Created by AFan on 2019/6/25.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "FriendChatInfoHeadCell.h"
#import "UserInfo.h"

@interface FriendChatInfoHeadCell ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *headImage;

@end



@implementation FriendChatInfoHeadCell

- (void)awakeFromNib {
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    FriendChatInfoHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[FriendChatInfoHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    UIImageView *headImage = [[UIImageView alloc] init];
    headImage.layer.cornerRadius = 5;
    headImage.layer.masksToBounds = YES;
    headImage.image = [UIImage imageNamed:@"imageName"];
    [self addSubview:headImage];
    _headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(@(64));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(headImage.mas_right).offset(20);
    }];
}

- (void)setContacts:(YPContacts *)contacts {
    _contacts = contacts;
    
    if (contacts.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", contacts.avatar]];
        if (image) {
            self.headImage.image =  image;
        } else {
            self.headImage.image =  [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImage cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:contacts.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    self.nameLabel.text = contacts.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

