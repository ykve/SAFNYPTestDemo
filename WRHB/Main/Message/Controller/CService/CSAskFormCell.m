//
//  CSAskFormCell.m
//  WRHB
//
//  Created by AFan on 2019/12/12.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "CSAskFormCell.h"

@interface CSAskFormCell()

@end


@implementation CSAskFormCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    CSAskFormCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CSAskFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

    self.backgroundColor = [UIColor clearColor];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.text = @"-";
    indexLabel.font = [UIFont systemFontOfSize:14];
    indexLabel.textColor = [UIColor colorWithHex:@"#404040"];
    [backView addSubview:indexLabel];
    _indexLabel = indexLabel;
    
    [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(20);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor colorWithHex:@"#404040"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(indexLabel.mas_right).offset(1);
    }];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"common_right_arrow"];
    [backView addSubview:iconView];

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.size.mas_equalTo(18);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#F1F1F1"];
    [backView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_bottom);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
