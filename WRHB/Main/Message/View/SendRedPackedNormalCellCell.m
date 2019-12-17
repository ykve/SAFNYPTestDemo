//
//  SendRedPackedNormalCellCell.m
//  WRHB
//
//  Created by AFan on 2019/11/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SendRedPackedNormalCellCell.h"


#define kTableViewMarginWidth 20

@interface SendRedPackedNormalCellCell ()

@end

@implementation SendRedPackedNormalCellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRedPackedNormalCellCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRedPackedNormalCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.right.equalTo(self.mas_right).offset(-kTableViewMarginWidth);
        make.height.mas_equalTo(55);
    }];
    
    _deTextField = [UITextField new];
    _deTextField.placeholder = @"恭喜发财，大吉大利";
    //    _deTextField.layer.cornerRadius = width/2;
    //    _deTextField.layer.masksToBounds = YES;
    //    _deTextField.backgroundColor = [UIColor redColor];
    _deTextField.font = [UIFont systemFontOfSize2:15];
    _deTextField.keyboardType = UIKeyboardTypeDefault;
    _deTextField.textAlignment = NSTextAlignmentLeft;
    _deTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    //    [_deTextField addTarget:self action:@selector(onNoButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_deTextField];
    
    [_deTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.right.equalTo(backView.mas_right).offset(-5);
        make.centerY.equalTo(backView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end





