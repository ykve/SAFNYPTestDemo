//
//  BillTableViewCell.m
//  Project
//
//  Created by AFan on 2019/11/14.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "BillTableViewCell.h"
#import "BillItem.h"
#import "BillItemModel.h"
#import "UIButton+GraphicBtn.h"

@interface BillTableViewCell()
/// 时间
@property (nonatomic, strong) UILabel *date;
/// 账单类型名称
@property (nonatomic, strong) UILabel *typeName;
/// 数目
@property (nonatomic, strong) UILabel *money;

@end

@implementation BillTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BillTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}




- (void)setModel:(BillItemModel *)model {
    _model = model;
   
    BOOL b = [model.number containsString:@"-"];
    self.money.textColor = (b)?HexColor(@"#ff4646"):HexColor(@"#369b3c");
    self.money.text = STR_TO_AmountFloatSTR(model.number);
    
    self.date.text = dateString_stamp(model.created_at, CDDateDay);
    self.typeName.text = model.title;

}

#pragma mark ----- subView
- (void)setupSubViews {
    
    _typeName = [UILabel new];
    [self.contentView addSubview:_typeName];
    _typeName.font = [UIFont systemFontOfSize:12];
    _typeName.numberOfLines = 0;
    _typeName.textColor = [UIColor colorWithHex:@"#343434"];
    
    [_typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(12);
    }];
    
    _date = [UILabel new];
    [self.contentView addSubview:_date];
    _date.textColor = [UIColor colorWithHex:@"#999999"];
    _date.font = [UIFont systemFontOfSize2:11];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_typeName.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
    _money = [UILabel new];
    _money.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_money];
    _money.font = [UIFont systemFontOfSize2:18];
    _money.textColor = HexColor(@"#369b3c");

    [_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-18);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#EDEDED"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.7);
    }];
  
    UIButton *seeDetBtn = [UIButton new];
    [seeDetBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    seeDetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [seeDetBtn setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    [seeDetBtn setImage:[UIImage imageNamed:@"me_bill_arrow_right"] forState:UIControlStateNormal];
    [seeDetBtn addTarget:self action:@selector(onSeeDetails) forControlEvents:UIControlEventTouchUpInside];
    [seeDetBtn setImagePosition:WPGraphicBtnTypeRight spacing:2];
    [self.contentView addSubview:seeDetBtn];
    _seeDetBtn = seeDetBtn;
    
    [seeDetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
}

/// 查看详情
- (void)onSeeDetails {
    if (self.onSeeDetailsBlock) {
        self.onSeeDetailsBlock(self.model);
    }
}



@end
