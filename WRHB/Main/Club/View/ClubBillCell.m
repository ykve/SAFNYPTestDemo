//
//  ClubBillCell.m
//  WRHB
//
//  Created by AFan on 2019/12/5.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubBillCell.h"
#import "ClubBillModel.h"
#import "NSDate+DaboExtension.h"

@interface ClubBillCell ()

///  日期
@property (nonatomic, strong) UILabel *dateLabel;
/// 上线玩家
@property (nonatomic, strong) UILabel *wjNumLabel;
/// 流水
@property (nonatomic, strong) UILabel *LSLabel;
/// 余额
@property (nonatomic, strong) UILabel *fyLabel;


@end

@implementation ClubBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubBillCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubBillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setModel:(ClubBillModel *)model {
    _model = model;
    
    self.dateLabel.text = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%f",model.date*1000] DataFormatterString:@"YYYY-MM-dd"];
    self.wjNumLabel.text = [NSString stringWithFormat:@"%zd", model.users];
    self.LSLabel.text = model.capital;
    self.fyLabel.text = model.commission;
    
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
    
    // ****** 返佣 ******
    UILabel *fyLabel = [[UILabel alloc] init];
//        fyLabel.backgroundColor = [UIColor redColor];
    fyLabel.text = @"-";
    fyLabel.font = [UIFont systemFontOfSize:fontSize];
    fyLabel.textColor = [UIColor colorWithHex:@"#343434"];
    fyLabel.numberOfLines = 1;
    fyLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:fyLabel];
    _fyLabel = fyLabel;
    
    // ****** 日期 ******
    UILabel *dateLabel = [[UILabel alloc] init];
//        dateLabel.backgroundColor = [UIColor cyanColor];
    dateLabel.text = @"-";
    dateLabel.font = [UIFont systemFontOfSize:fontSize];
    dateLabel.textColor = [UIColor colorWithHex:@"#343434"];
    dateLabel.numberOfLines = 1;
    [backView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    
    
    // ****** 上线玩家 ******
    UILabel *wjNumLabel = [[UILabel alloc] init];
//    wjNumLabel.backgroundColor = [UIColor greenColor];
    wjNumLabel.text = @"-";
    wjNumLabel.font = [UIFont systemFontOfSize:fontSize];
    wjNumLabel.textColor = [UIColor colorWithHex:@"#343434"];
    wjNumLabel.numberOfLines = 1;
    wjNumLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:wjNumLabel];
    _wjNumLabel = wjNumLabel;
    
    // ****** 当日流水 ******
    UILabel *LSLabel = [[UILabel alloc] init];
//        LSLabel.backgroundColor = [UIColor yellowColor];
    LSLabel.text = @"-";
    LSLabel.font = [UIFont systemFontOfSize:fontSize];
    LSLabel.textColor = [UIColor colorWithHex:@"#343434"];
    LSLabel.numberOfLines = 1;
    LSLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:LSLabel];
    _LSLabel = LSLabel;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(wjNumLabel);
    }];
    
    [wjNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.mas_right).offset(spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(LSLabel);
    }];
    
    [LSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wjNumLabel.mas_right).offset(spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(fyLabel);
    }];
    
    [fyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LSLabel.mas_right).offset(spacingWidht);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.equalTo(dateLabel);
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

