//
//  WitAlertTextCell.m
//  WRHB
//
//  Created by AFan on 2019/11/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "WitAlertTextCell.h"

@interface WitAlertTextCell()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation WitAlertTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    WitAlertTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WitAlertTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    _contentLabel = [UILabel new];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = [UIFont vvFontOfSize:12];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithHex:@"#666666"];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    _contentLabel.backgroundColor = [UIColor greenColor];
    
    
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [UIColor colorWithHex:@"#FFEDED"];
//    [self addSubview:lineView];
//    _lineView = lineView;
//
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//        make.height.equalTo(@(0.7));
//    }];
    
}



- (void)setModel:(id)model {
    _contentLabel.text = model;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end



