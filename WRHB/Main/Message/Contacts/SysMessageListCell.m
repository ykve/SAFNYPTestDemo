//
//  SysMessageListCell.m
//  WRHB
//
//  Created by AFan on 2019/12/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SysMessageListCell.h"
#import "SysMessageListModel.h"
#import "NSDate+DaboExtension.h"


@interface SysMessageListCell ()

///
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation SysMessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SysMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SysMessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setModel:(SysMessageListModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.dateLabel.text = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%ld",(long)model.updateTime*1000] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
    
    self.circleView.hidden = NO;
    if (model.isReaded) {
        self.circleView.hidden = YES;
    }
    
    if (model.isSelected) {
        self.selectImgView.image = [UIImage imageNamed:@"mes_sys_select"];
    } else {
        self.selectImgView.image = [UIImage imageNamed:@"mes_sys_noselect"];
    }
}

- (void)setIsShowSelectImg:(BOOL)isShowSelectImg {
    _isShowSelectImg = isShowSelectImg;
    
    if (isShowSelectImg) {
        self.selectImgView.hidden = NO;
        self.maskView.backgroundColor = [UIColor whiteColor];
        self.maskView.alpha = 0.5;
    } else {
        self.maskView.alpha = 1;
        self.maskView.backgroundColor = [UIColor clearColor];
        self.selectImgView.hidden = YES;
    }
    
}

- (void)setupSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(90);
    }];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:maskView];
    _maskView = maskView;
    
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(6);
        make.left.equalTo(backView.mas_left).offset(20);
    }];
    
    UIView *circleView = [[UIView alloc] init];
    circleView.layer.cornerRadius = 10/2;
    circleView.layer.masksToBounds = YES;
    circleView.backgroundColor = [UIColor redColor];
    [backView addSubview:circleView];
    _circleView = circleView;
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(5);
        make.size.mas_equalTo(10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"-";
    contentLabel.numberOfLines = 2;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"-";
    dateLabel.font = [UIFont systemFontOfSize:11];
    dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-20);
    }];
    
    
    UIImageView *selectImgView = [[UIImageView alloc] init];
    selectImgView.image = [UIImage imageNamed:@"mes_sys_noselect"];
    selectImgView.hidden = YES;
    [self.contentView addSubview:selectImgView];
    _selectImgView = selectImgView;
    
    [selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.equalTo(backView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(25);
    }];
    
    [self.contentView bringSubviewToFront:maskView];
    [self.contentView bringSubviewToFront:selectImgView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
