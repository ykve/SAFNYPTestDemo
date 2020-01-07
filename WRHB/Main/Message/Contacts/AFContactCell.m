//
//  ContactCell.m
//  WRHB
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AFContactCell.h"

@interface AFContactCell ()

@property (strong, nonatomic) UIImageView *headImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *onlineOfflineLabel;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *deniedButton;
@property (strong, nonatomic) UIImageView *selectedImage;
@property (strong, nonatomic) UIView *cellMaskView;

@end



@implementation AFContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    AFContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[AFContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self.contentView addSubview:headImage];
    _headImage = headImage;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(@(40));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_top).offset(2);
        make.left.equalTo(headImage.mas_right).offset(10);
    }];
    
    UILabel *onlineOfflineLabel = [[UILabel alloc] init];
    onlineOfflineLabel.text = @"-";
    onlineOfflineLabel.font = [UIFont systemFontOfSize:13];
    onlineOfflineLabel.textColor = [UIColor colorWithHex:@"#999999"];
    onlineOfflineLabel.numberOfLines = 0;
    onlineOfflineLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:onlineOfflineLabel];
    _onlineOfflineLabel = onlineOfflineLabel;
    
    [onlineOfflineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImage.mas_bottom).offset(-2);
        make.left.equalTo(nameLabel.mas_left);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#EBEBEB"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImage.mas_right).offset(10);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.7);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:addButton];
    _addButton = addButton;
    addButton.layer.cornerRadius = 26/2;
    addButton.backgroundColor = [UIColor redColor];
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [addButton setTitle:@"通过" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    doneButton.imageEdgeInsets = UIEdgeInsetsMake(10, -12, 10, 10);
    //    doneButton.titleEdgeInsets = UIEdgeInsetsMake(10, -18, 10, 10);
    [addButton addTarget:self action:@selector(onDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = 1000;
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(55, 26));
    }];
    
    
    UIButton *deniedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:deniedButton];
    _deniedButton = deniedButton;
    deniedButton.layer.cornerRadius = 26/2;
//    deniedButton.backgroundColor = [UIColor redColor];
    deniedButton.layer.borderWidth = 1;
    deniedButton.layer.borderColor = [UIColor redColor].CGColor;
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [deniedButton setTitle:@"拒绝" forState:UIControlStateNormal];
    //    [doneButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    deniedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [deniedButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deniedButton addTarget:self action:@selector(onDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    deniedButton.tag = 1001;
    [deniedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(addButton.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(55, 26));
    }];
    
    
    UIImageView *selectedImage = [[UIImageView alloc] init];
    selectedImage.image = [UIImage imageNamed:@"mes_selected_normal"];
    [self.contentView addSubview:selectedImage];
    _selectedImage = selectedImage;
    
    [selectedImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(@(20));
    }];
    
    UIView *cellMaskView = [[UIView alloc] init];
    cellMaskView.backgroundColor = [UIColor whiteColor];
    cellMaskView.alpha = 0.7;
    cellMaskView.hidden = YES;
    [self.contentView addSubview:cellMaskView];
    _cellMaskView = cellMaskView;
    
    [cellMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
}

- (void)onDoneButton:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(cellAddFriendBtnIndex:model:)]) {
        [self.delegate cellAddFriendBtnIndex:index model:self.model];
    }
}


- (void)setModel:(YPContacts *)model {
    _model = model;
    
    if (model.avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", model.avatar]];
        if (image) {
            self.headImage.image =  image;
        } else {
            self.headImage.image =  [UIImage imageNamed:@"cm_default_avatar"];
        }
    } else {
        [self.headImage cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    
    YPUserStateModel *stateModel = [AppModel sharedInstance].userStateDict[@(model.user_id)];
   
    self.nameLabel.text = model.name;
    self.onlineOfflineLabel.text = [NSString stringWithFormat:@"%@", [self stringState:stateModel.state]];
    
    UIColor *color = nil;
    if (stateModel.state == UserState_Online) {
        color = [UIColor colorWithHex:@"2E8B57"];
    } else if (stateModel.state == UserState_Background) {
        color = [UIColor orangeColor];
    } else {
        color = [UIColor grayColor];
    }
    self.onlineOfflineLabel.textColor = color;
    
    
    self.addButton.hidden = YES;
    self.deniedButton.hidden = YES;
    if (model.contactsType == FriendType_Request) {
        self.addButton.hidden = NO;
        self.deniedButton.hidden = NO;
    }
    
    if ([model.name isEqualToString:@"在线客服"]) {
        self.headImage.image =  [UIImage imageNamed:model.avatar];
        self.onlineOfflineLabel.text = @"有问题，找客服";
    }
    
    self.selectedImage.hidden = YES;
    if (self.isShowSelectView) {
        self.selectedImage.hidden = NO;
        
        self.selectedImage.image = [UIImage imageNamed:@"mes_selected_normal"];
        if (model.isSelected) {
            self.selectedImage.image = [UIImage imageNamed:@"mes_selected"];
        }
        self.cellMaskView.hidden = YES;
        if (model.isAdded) {
            self.cellMaskView.hidden = NO;
        }
    }
    
    
}

- (NSString *)stringState:(YPUserState)state {
    switch (state) {
        case UserState_Offline:
            return @"离线";
            break;
        case UserState_Online:
            return @"在线";
            break;
        case UserState_Background:
            return @"离开";
            break;
        default:
            return @"离线";
            break;
    }
}




//-(void)layoutSubviews
//{
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (self.selected) {
//                        img.image=[UIImage imageNamed:@"mes_selected"];
//                    }else
//                    {
//                        img.image=[UIImage imageNamed:@"mes_selected_normal"];
//                    }
//                }
//            }
//        }
//    }
//    [super layoutSubviews];
//}
//
//
////适配第一次图片为空的情况
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *v in control.subviews)
//            {
//                if ([v isKindOfClass: [UIImageView class]]) {
//                    UIImageView *img=(UIImageView *)v;
//                    if (!self.selected) {
//                        img.image=[UIImage imageNamed:@"mes_selected_normal"];
//                    }
//                }
//            }
//        }
//    }
//
//}



@end
