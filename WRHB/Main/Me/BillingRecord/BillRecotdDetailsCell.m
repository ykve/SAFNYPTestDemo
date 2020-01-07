//
//  BillRecotdDetailsCell.m
//  WRHB
//
//  Created by AFan on 2019/12/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "BillRecotdDetailsCell.h"

@implementation BillRecotdDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    BillRecotdDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BillRecotdDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(15);
    }];

    UILabel *desLabel = [[UILabel alloc] init];
//    desLabel.backgroundColor = [UIColor greenColor];
    desLabel.text = @"-";
    desLabel.font = [UIFont boldSystemFontOfSize:15];
    desLabel.numberOfLines = 2;
    desLabel.textColor = [UIColor colorWithHex:@"#000000"];
    desLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:desLabel];
    _desLabel = desLabel;
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.left.equalTo(backView.mas_left).offset(100);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
