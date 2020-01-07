//
//  ListViewCell.m
//  WRHB
//
//  Created by AFan on 2019/10/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ListViewCell.h"
#import "WithdrawBankModel.h"

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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



-(void)setModel:(WithdrawBankModel *)model {
    _model = model;
    
    NSString *cNum = model.card;
    cNum = [cNum substringFromIndex:cNum.length- 4];

    if ([model.bank_name containsString:@"新卡"]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@", model.bank_name];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@（%@）", model.bank_name, cNum];
    }
    
    self.desLabel.text = model.desTime ? model.desTime : @"两个小时到账";
    
    if (model.isSelected) {
        self.selectImageView.hidden = NO;
    } else {
       self.selectImageView.hidden = YES;
    }
}


- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"me_pay_jianshe_icon"];
    [self.contentView addSubview:iconImageView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(32.5);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_top);
        make.left.equalTo(iconImageView.mas_right).offset(30);
    }];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"-";
    desLabel.font = [UIFont systemFontOfSize:12];
    desLabel.textColor = [UIColor colorWithHex:@"#999999"];
    desLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:desLabel];
    _desLabel = desLabel;
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImageView.mas_bottom);
        make.left.equalTo(titleLabel.mas_left);
    }];
    
    
    UIImageView *selectImageView = [[UIImageView alloc] init];
    selectImageView.image = [UIImage imageNamed:@"pay_select"];
    [self.contentView addSubview:selectImageView];
    _selectImageView = selectImageView;
    
    [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(16);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.8);
    }];
}






@end
