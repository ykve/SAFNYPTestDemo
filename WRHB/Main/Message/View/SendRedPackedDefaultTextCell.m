//
//  SendRedPackedDefaultTextCell.m
//  WRHB
//
//  Created by AFan on 2019/10/19.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SendRedPackedDefaultTextCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRedPacketController.h"


#define kTableViewMarginWidth 20

@interface SendRedPackedDefaultTextCell ()

@end

@implementation SendRedPackedDefaultTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRedPackedDefaultTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRedPackedDefaultTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"-";
    _titleLabel.font = [UIFont systemFontOfSize2:15];
    _titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    
    _deTextField = [UITextField new];
    //    _deTextField.layer.cornerRadius = width/2;
    //    _deTextField.layer.masksToBounds = YES;
    //    _deTextField.backgroundColor = [UIColor redColor];
    _deTextField.font = [UIFont systemFontOfSize2:16];
    _deTextField.keyboardType = UIKeyboardTypeNumberPad;
    _deTextField.textAlignment = NSTextAlignmentRight;
    _deTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    //    [_deTextField addTarget:self action:@selector(onNoButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_deTextField];
    
    [_deTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-(5 + kTableViewMarginWidth));
        make.centerY.equalTo(backView.mas_centerY);
        make.left.equalTo(backView.mas_left).offset(90);
        make.height.mas_equalTo(35);
    }];
    
    _unitLabel = [UILabel new];
    _unitLabel.text = @"-";
    _unitLabel.font = [UIFont systemFontOfSize2:15];
    _unitLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView addSubview:_unitLabel];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-8);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
}






- (void)layoutSubviews {
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end




