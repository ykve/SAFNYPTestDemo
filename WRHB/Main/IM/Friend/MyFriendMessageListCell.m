//
//  MyFriendMessageListCell.m
//  Project
//
//  Created by AFan on 2019/6/21.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MyFriendMessageListCell.h"
#import "YPContacts.h"
#import "PushMessageNumModel.h"
#import "MessageSingle.h"


@interface MyFriendMessageListCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation MyFriendMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    MyFriendMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MyFriendMessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    [self setupSubViews];
    [self initLayout];
}

#pragma mark ----- Layout
- (void)initLayout{
    
    [_headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@(50));
    }];
    
    [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(12));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_headIcon.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self->_headIcon.mas_top).offset(3);
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
    
    _dotView = [UIView new];
    [self.contentView addSubview:_dotView];
    _dotView.backgroundColor = [UIColor redColor];
    _dotView.layer.cornerRadius = 6;
    _dotView.layer.masksToBounds = YES;
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 1;
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize2:16];
    _titleLabel.textColor = Color_0;
    //    _titleLabel.text = @"通知消息";
    
    _descLabel = [UILabel new];
    [self.contentView addSubview:_descLabel];
    _descLabel.font = [UIFont systemFontOfSize:13];
    _descLabel.textColor = COLOR_X(140, 140, 140);
    //    _descLabel.text = @"点击查看";
    _descLabel.numberOfLines = 1;
    
    _dateLabel = [UILabel new];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = [UIFont systemFontOfSize2:12];
    _dateLabel.textColor = [UIColor lightGrayColor];
    //    _dateLabel.text = @"1-01 11:33";
    
}

- (void)setModel:(YPContacts *)model {
    _model = model;
     _titleLabel.text = model.name;
    
    if ([model.name isEqualToString:@"在线客服"] || model.contactsType == 3) {
        if (model.contactsType == 3) {
            [_headIcon cd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"msg3"]];
        } else {
            _headIcon.image = [UIImage imageNamed:model.avatar];
        }
        _descLabel.text = @"有问题，找客服";
        _dotView.hidden = YES;
        return;
    } else {
         [_headIcon cd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"msg3"]];
    }
   
    
    NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",self.sessionId,[AppModel sharedInstance].user_info.userId];
    PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
    
    if (pmModel.number > 0) {
        
        _descLabel.text = (pmModel.number>99) ? @"[99+未读]" : [NSString stringWithFormat:@"[%ld条未读]%@",pmModel.number,pmModel.lastMessage];
        
        _dotView.hidden = NO;
    } else {
        if (pmModel.lastMessage.length >0) {
            
            _descLabel.text = pmModel.lastMessage;
        } else {
            _descLabel.text = @"暂无未读消息";
        }
        _dotView.hidden = YES;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
