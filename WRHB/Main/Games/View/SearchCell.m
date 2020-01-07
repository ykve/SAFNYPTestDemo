//
//  SearchCell.m
//  WRHB
//
//  Created by AFan on 2019/2/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SearchCell.h"
#import "YPContacts.h"

@interface SearchCell()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexIcon;
@property (nonatomic, strong) UILabel *iDLabel;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self setupSubViews];
    }
    return self;
}

#pragma mark ----- Data
- (void)initData{
    
}

#pragma mark ----- subView
- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    
    _icon = [UIImageView new];
    [self.contentView addSubview:_icon];
    _icon.layer.cornerRadius = 5;
    _icon.layer.masksToBounds = YES;
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(40));
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    
    _nameLabel = [UILabel new];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_icon.mas_right).offset(12);
        make.centerY.equalTo(self->_icon.mas_centerY);
    }];
    
    //    _iDLabel = [UILabel new];
    //    [self.contentView addSubview:_iDLabel];
    //    _iDLabel.font = [UIFont systemFontOfSize2:13];
    //    _iDLabel.textColor = Color_6;
    
    //    [_iDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self->_icon.mas_bottom).offset(-3);
    //        make.left.equalTo(self->_nameLabel.mas_left);
    //    }];
    
    //    UIView *sexBack =[UIView new];
    //    [self.contentView addSubview:sexBack];
    //    sexBack.layer.cornerRadius = 7;
    //    sexBack.layer.masksToBounds = YES;
    //    sexBack.backgroundColor = SexBack;
    //    [sexBack mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self->_nameLabel.mas_right).offset(6);
    //        make.centerY.equalTo(self->_nameLabel);
    //        make.width.height.equalTo(@(14));
    //    }];
    //
    //    _sexIcon = [UIImageView new];
    //    [self.contentView addSubview:_sexIcon];
    //
    //    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(sexBack);
    //    }];
    
    
    
    _addBtn = [UIButton new];
    [self.contentView addSubview:_addBtn];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.borderColor = [UIColor redColor].CGColor;
    _addBtn.layer.cornerRadius = 5;
    //    [_addBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(selectedBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //    _addBtn.image = [UIImage imageNamed:@"group_delete"];
    //    _addBtn.backgroundColor = [UIColor redColor];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(75, 28));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.7);
    }];
    
    
    
    
}

- (void)setModel:(BaseUserModel *)model {
    _model = model;
    
    if (model.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            _icon.image =  image;
        } else {
            _icon.image =  [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [_icon cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    
    
    NSString *userId = [NSString stringWithFormat:@"%ld_%ld",model.userId,[AppModel sharedInstance].user_info.userId];
    YPContacts *contact = [[AppModel sharedInstance].myFriendListDict objectForKey:userId];
    
    _addBtn.userInteractionEnabled = YES;
    [_addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _addBtn.layer.borderColor = [UIColor redColor].CGColor;
    
    if (model.userId == [AppModel sharedInstance].user_info.userId) {  // 自己
        _addBtn.userInteractionEnabled = NO;
        [_addBtn setTitle:@"自己" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    } else if (model.userId == contact.user_id) {  // 已添加
        _addBtn.userInteractionEnabled = NO;
        [_addBtn setTitle:@"已添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    
   
    
    //    _iDLabel.text = [NSString stringWithFormat:@"账号：%ld",model.userId];
    //    _sexIcon.image = (model.sex == UserGender_Female)?[UIImage imageNamed:@"female"]:[UIImage imageNamed:@"male"];
    
    //    if (self.isSelected) {
    //        [_addBtn setBackgroundImage:[UIImage imageNamed:@"group_selected"] forState:UIControlStateNormal];
    //    } else {
    //        [_addBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    //    }
}


- (void)selectedBtnAction {
    
    //    self.isSelected = !self.isSelected;
    //
    //    if (self.isSelected) {
    //        [_addBtn setBackgroundImage:[UIImage imageNamed:@"group_selected"] forState:UIControlStateNormal];
    //    } else {
    //        [_addBtn setBackgroundImage:[UIImage imageNamed:@"group_selected_no"] forState:UIControlStateNormal];
    //    }
    
    if (self.addBtnBlock) {
        self.addBtnBlock(self.model);
    }
    
    _addBtn.userInteractionEnabled = NO;
    [_addBtn setTitle:@"已发送" forState:UIControlStateNormal];
    [_addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


@end
