//
//  ClubApplicationListCell.m
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubApplicationListCell.h"
#import "UIButton+GraphicBtn.h"
#import "ClubInitiator.h"
#import "UIButton+Layout.h"

@interface ClubApplicationListCell ()

/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// ID
@property (nonatomic, strong) UILabel *IDLabel;
/// 头像
@property (nonatomic, strong)  UIImageView *headImgView;



@end

@implementation ClubApplicationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubApplicationListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubApplicationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setModel:(ClubInitiator *)model {
    _model = model;
    
    if (model.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            _headImgView.image = image;
        } else {
            _headImgView.image = [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [_headImgView cd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    self.nameLabel.text = model.name;
    self.IDLabel.text = [NSString stringWithFormat:@"ID:%zd", model.user_id];
    
    
}

- (void)onDoneButton:(UIButton *)sender {
    if (sender.tag == 3000) {
        if (self.memberRejectBlock) {
            self.memberRejectBlock(self.model);
        }
    } else {
        if (self.memberPassBlock) {
            self.memberPassBlock(self.model);
        }
    }
}


- (void)setupUI {
    
    CGFloat fontSize = 13;
    CGFloat spacingWidht = 2;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    
    UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:rejectBtn];
    _rejectBtn = rejectBtn;
    rejectBtn.layer.cornerRadius = 5;
    rejectBtn.backgroundColor = [UIColor redColor];
    rejectBtn.layer.borderWidth = 1;
    rejectBtn.layer.borderColor = [UIColor redColor].CGColor;
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [rejectBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    rejectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rejectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rejectBtn addTarget:self action:@selector(onDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    rejectBtn.tag = 3000;
    [rejectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
    UIButton *passButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:passButton];
    _passButton = passButton;
    passButton.layer.cornerRadius = 5;
    passButton.backgroundColor = [UIColor colorWithHex:@"#41A422"];
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [passButton setTitle:@"通过" forState:UIControlStateNormal];
    [passButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    passButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [passButton addTarget:self action:@selector(onDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    passButton.tag = 3001;
    [passButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(rejectBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(50, 26));
    }];
    
    
    // ****** ID ******
    UILabel *IDLabel = [[UILabel alloc] init];
    //    IDLabel.backgroundColor = [UIColor redColor];
    IDLabel.text = @"-";
    IDLabel.font = [UIFont systemFontOfSize:fontSize];
    IDLabel.textColor = [UIColor colorWithHex:@"#343434"];
    IDLabel.numberOfLines = 1;
    IDLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:IDLabel];
    _IDLabel = IDLabel;
    
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passButton.mas_left).offset(-20);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(80);
    }];
    
    UIImageView *headImgView = [[UIImageView alloc] init];
//    backImageView.image = [UIImage imageNamed:@"imageName"];
    headImgView.layer.cornerRadius = 5;
    headImgView.layer.masksToBounds = YES;
    [backView addSubview:headImgView];
    _headImgView = headImgView;
    
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(30);
    }];
    
    
    // ****** 昵称 ******
    UILabel *nameLabel = [[UILabel alloc] init];
    //    nameLabel.backgroundColor = [UIColor cyanColor];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:fontSize];
    nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    nameLabel.numberOfLines = 1;
    [backView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImgView.mas_right).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(IDLabel.mas_left).offset(-spacingWidht);
    }];
    
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.bottom.equalTo(backView);
        make.height.mas_equalTo(1);
    }];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

