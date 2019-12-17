//
//  ClubMDetailsTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/12/6.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMDetailsTableViewCell.h"
#import "ClubMemberDetailsListModel.h"
#import "NSDate+DaboExtension.h"

@interface ClubMDetailsTableViewCell ()

///
@property (nonatomic, strong) UIButton *operationTypeBtn;
/// 玩法
@property (nonatomic, strong) UILabel *wfLabel;
/// 操作
@property (nonatomic, strong) UILabel *czLabel;
/// 操作金额
@property (nonatomic, strong) UILabel *czjeLabel;
/// 盈利
@property (nonatomic, strong) UILabel *ylLabel;
/// 时间
@property (nonatomic, strong) UILabel *dateLabel;


@end

@implementation ClubMDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubMDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setModel:(ClubMemberDetailsListModel *)model {
    _model = model;
    
    self.wfLabel.text = model.play_type;
    self.czLabel.text = model.type;
    self.czjeLabel.text = model.operate_number;
    self.ylLabel.text = model.number;
    self.dateLabel.text = [NSDate getDateStringWithTimeInterval:[NSString stringWithFormat:@"%f",model.created_at*1000] DataFormatterString:@"yyyy-MM-dd HH:mm:ss"];
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
    
    UIButton *operationTypeBtn = [[UIButton alloc] init];
    //    operationTypeBtn.backgroundColor = [UIColor redColor];
    [operationTypeBtn setBackgroundImage:[UIImage imageNamed:@"club_member_det_icon"] forState:UIControlStateNormal];
//    [operationTypeBtn addTarget:self action:@selector(onOperationTypeBtn) forControlEvents:UIControlEventTouchUpInside];
    operationTypeBtn.tag = 1000;
    [backView addSubview:operationTypeBtn];
    [operationTypeBtn delayEnable];
    _operationTypeBtn = operationTypeBtn;
    
    [operationTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 19));
    }];
    
    // ****** 时间 ******
    UILabel *dateLabel = [[UILabel alloc] init];
//        dateLabel.backgroundColor = [UIColor redColor];
    dateLabel.text = @"-";
    dateLabel.font = [UIFont systemFontOfSize:10];
    dateLabel.textColor = [UIColor colorWithHex:@"#343434"];
    dateLabel.numberOfLines = 2;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(operationTypeBtn.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
    
    // ****** 盈利 ******
    UILabel *ylLabel = [[UILabel alloc] init];
//        ylLabel.backgroundColor = [UIColor yellowColor];
    ylLabel.text = @"-";
    ylLabel.font = [UIFont systemFontOfSize:fontSize];
    ylLabel.textColor = [UIColor colorWithHex:@"#343434"];
    ylLabel.numberOfLines = 1;
    ylLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:ylLabel];
    _ylLabel = ylLabel;
    
    [ylLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dateLabel.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    // ****** 玩法 ******
    UILabel *wfLabel = [[UILabel alloc] init];
    //        wfLabel.backgroundColor = [UIColor cyanColor];
    wfLabel.text = @"-";
    wfLabel.font = [UIFont systemFontOfSize:fontSize];
    wfLabel.textColor = [UIColor colorWithHex:@"#343434"];
    wfLabel.numberOfLines = 1;
    [backView addSubview:wfLabel];
    _wfLabel = wfLabel;
    
    [wfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    
    // ****** 操作 ******
    UILabel *czLabel = [[UILabel alloc] init];
//        czLabel.backgroundColor = [UIColor redColor];
    czLabel.text = @"-";
    czLabel.font = [UIFont systemFontOfSize:fontSize];
    czLabel.textColor = [UIColor colorWithHex:@"#343434"];
    czLabel.numberOfLines = 1;
    czLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:czLabel];
    _czLabel = czLabel;
    
    [czLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wfLabel.mas_right).offset(spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    // ****** 操作金额 ******
    UILabel *czjeLabel = [[UILabel alloc] init];
    //        czjeLabel.backgroundColor = [UIColor greenColor];
    czjeLabel.text = @"-";
    czjeLabel.font = [UIFont systemFontOfSize:fontSize];
    czjeLabel.textColor = [UIColor colorWithHex:@"#343434"];
    czjeLabel.numberOfLines = 1;
    czjeLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:czjeLabel];
    _czjeLabel = czjeLabel;
    
    [czjeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ylLabel.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(czLabel.mas_right).offset(spacingWidht);
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

