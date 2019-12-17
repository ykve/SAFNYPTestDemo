//
//  SendRedPackedTextCell.m
//  Project
//
//  Created by AFan on 2019/2/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SendRedPackedTextCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRedPacketController.h"


#define kTableViewMarginWidth 20

@interface SendRedPackedTextCell ()

/// <#assign注释#>
@property (nonatomic, assign) UILabel *moneyLabel;

@end

@implementation SendRedPackedTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SendRedPackedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SendRedPackedTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
         [self initNotif];
    }
    return self;
}

- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    UITextField *textFieldObj = (UITextField *)notiObject.object;
    if (textFieldObj.tag == 3000) {
        NSInteger mObjectInte = [textFieldObj.text integerValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%ld",mObjectInte];
        self.money = textFieldObj.text;
    }
}


- (void)setModel:(id)model {
    //    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", self.money];
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(100);
    }];
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"redp_money"];
    [topView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(20);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(38, 30));
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.text = @"￥0";
    moneyLabel.font = [UIFont boldSystemFontOfSize:24];
    moneyLabel.textColor = [UIColor colorWithHex:@"#343434"];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:moneyLabel];
    _moneyLabel = moneyLabel;
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_bottom).offset(7);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
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



