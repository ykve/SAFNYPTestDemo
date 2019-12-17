//
//  MessageTableViewCell.m
//  Project
//
//  Created by AFan on 2019/11/1.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MessageItem.h"
#import "SqliteManage.h"
#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "ChatsModel.h"
#import <SDWebImage/UIImage+GIF.h>
#import "NSDate+DaboExtension.h"
#import "NSString+AFString.h"


@interface MessageTableViewCell()
@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *dotView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *dateLabel;
/// 已读标识
@property (nonatomic, strong) UIImageView *readedImg;
@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        make.height.width.equalTo(@(50));
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
    
    
}

#pragma mark ----- subView
- (void)setupSubViews {
    
    _headIcon = [UIImageView new];
    [self.contentView addSubview:_headIcon];
    _headIcon.layer.cornerRadius = 6;
    _headIcon.layer.masksToBounds = YES;
    //    _headIcon.backgroundColor = [UIColor randColor];
    
    _dotView = [UILabel new];
    [self.contentView addSubview:_dotView];
    _dotView.backgroundColor = [UIColor redColor];
    _dotView.textColor = [UIColor whiteColor];
     _dotView.font = [UIFont systemFontOfSize:11];
    _dotView.layer.cornerRadius = 16/2;
    _dotView.layer.masksToBounds = YES;
    _dotView.textAlignment = NSTextAlignmentCenter;
    
    [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self->_headIcon.mas_top).offset(3);
        make.centerX.equalTo(self->_headIcon.mas_right).offset(-3);
        make.width.height.equalTo(@(16));
    }];
    
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
    _dateLabel.textAlignment = NSTextAlignmentRight;
    //    _dateLabel.text = @"1-01 11:33";
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self->_titleLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(35, 20));
    }];
    
//    _dateLabel.backgroundColor = [UIColor redColor];
    
    // 创建已读标识
    _readedImg = [UIImageView new];
    //    _readedImg.backgroundColor = [UIColor redColor];
    _readedImg.image = [UIImage imageNamed:@"mes_read_send"];
    //    _readedImg.bounds = CGRectMake(0, 0, YPChatReadedIconWidth, YPChatReadedIconHeight);
    [self.contentView addSubview:_readedImg];
//    _readedImg.backgroundColor = [UIColor greenColor];
    
    [_readedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_dateLabel.mas_left).offset(-1);
        make.centerY.equalTo(self->_dateLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(YPChatReadedIconWidth, YPChatReadedIconHeight));
    }];
    
    
    
    
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
    
    if ([model.avatar isEqual:[NSNull null]]) {
        model.avatar = [NSString noNullStringWith:model.avatar];
    }

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
    _descLabel.text = model.desc;
    
    
    if (model.isChatsList) {
      
        NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",model.sessionId,[AppModel sharedInstance].user_info.userId];
        PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
        _descLabel.text = pmModel.lastMessage;
        
        _dotView.hidden = YES;
        if (pmModel.number > 0) {
            _dotView.hidden = NO;
            _dotView.text = (pmModel.number>99) ? @"99+" : [NSString stringWithFormat:@"%ld",pmModel.number];
        }
        
        if ([model.name isEqualToString:@"在线客服"]) {
            if (pmModel.number == 0) {
                _descLabel.text = @"有问题，找客服";
            }
        }
        
        NSString *pageStr = [NSString stringWithFormat:@"%d,%d", 0,1];
        NSString *whereStr = [NSString stringWithFormat:@"sessionId = '%ld' and isDeleted = 0", model.sessionId];
        YPMessage *oldMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr order:@"by timestamp desc,create_time desc" limit:pageStr] firstObject];

        
         // 显示时间 和 自己的已读状态
        _dateLabel.text = [NSDate stringFromDate:oldMessage.create_time andNSDateFmt:NSDateFmtHHmm];
        if (pmModel.isYourselfSend) {
            _readedImg.hidden = NO;
             _readedImg.image = [UIImage imageNamed:@"mes_read_send"];
            if (oldMessage) {
                if (oldMessage.isRemoteRead) {
                     _readedImg.image = [UIImage imageNamed:@"mes_read"];
                }
            }
        } else {
            _readedImg.hidden = YES;
        }
        
    } else {
        _dotView.hidden = YES;
    }
    
}



@end
