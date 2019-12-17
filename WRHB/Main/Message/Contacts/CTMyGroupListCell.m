//
//  CTMyGroupListCell.m
//  WRHB
//
//  Created by AFan on 2019/11/21.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CTMyGroupListCell.h"
#import "MessageItem.h"
#import "SqliteManage.h"
#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "ChatsModel.h"
#import <SDWebImage/UIImage+GIF.h>

@interface CTMyGroupListCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation CTMyGroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    CTMyGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CTMyGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
        [self initLayout];
    }
    return self;
}


#pragma mark ----- Layout
- (void)initLayout{
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@(40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self->_headIcon.mas_centerY);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_titleLabel.mas_left);
        make.top.equalTo(self->_titleLabel.mas_bottom).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self->_titleLabel.mas_top);
    }];
}

#pragma mark ----- subView
- (void)setupSubViews {
    
    _headIcon = [UIImageView new];
    [self.contentView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 6;
    _headIcon.layer.masksToBounds = YES;
    //    _headIcon.backgroundColor = [UIColor randColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    //    _titleLabel.text = @"通知消息";
    
    _descLabel = [UILabel new];
    [self.contentView addSubview:_descLabel];
    _descLabel.font = [UIFont systemFontOfSize:13];
    _descLabel.textColor = [UIColor colorWithHex:@"#999999"];
    //    _descLabel.text = @"点击查看";
    _descLabel.numberOfLines = 1;
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = [UIFont systemFontOfSize2:12];
    _dateLabel.textColor = [UIColor lightGrayColor];
    //    _dateLabel.text = @"1-01 11:33";
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#EBEBEB"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(10);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.7);
    }];
}

- (void)setModel:(ChatsModel *)model {
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
    
    
    _titleLabel.text = model.name;
//    _descLabel.text = model.desc;
 
}



@end

