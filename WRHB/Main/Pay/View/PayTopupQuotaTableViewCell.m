//
//  PayTopupQuotaTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopupQuotaTableViewCell.h"
#import "LimitCollectionView.h"
#import "PayTopupModel.h"
#import "PayTopupItemCollectionView.h"
#import "UIView+AZGradient.h"   // 渐变色
#import "YCShadowView.h"

@interface PayTopupQuotaTableViewCell ()

/// 限额CollectionView
@property (nonatomic, strong) LimitCollectionView *limitCollectionView;
///
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation PayTopupQuotaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    PayTopupQuotaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PayTopupQuotaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        //注册一个监听器用于监听指定的key路径
        [self addTargetMethod];
    }
    return self;
}

#pragma mark - 直接添加监听方法
-(void)addTargetMethod{
    [self.textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFieldTextChange:(UITextField *)textField {
    [self setBtnStatsText:textField.text];
}

- (void)setBtnStatsText:(NSString *)text {
    if (text.length > 0) {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        // 渐变色
        [self.submitBtn az_setGradientBackgroundWithColors:@[[UIColor colorWithHex:@"#FF8888"],[UIColor colorWithHex:@"#FF4444"]] locations:0 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        self.submitBtn.userInteractionEnabled = YES;
    } else {
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
        self.submitBtn.userInteractionEnabled = NO;
    }
}

/// 前往支付
- (void)goto_payController {
    [self routerEventWithName:@"PayTopupQuotaTableViewCellBtnClick" user_info:nil];
}

- (void)setModel:(PayTopupModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.limitCollectionView.model = model.amounts;
    self.textField.userInteractionEnabled = model.can_enter_amount;
}


// Controller
- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
{
    if ([eventName isEqualToString:@"PayAmountCellSelected"]) {  // 金额选择
        NSInteger money = [user_info[@"money"] integerValue];
        self.textField.text = [NSString stringWithFormat:@"%zd", money];
        [self setBtnStatsText:self.textField.text];
    }
    
    [super routerEventWithName:eventName user_info:user_info];
}

/**
 *  周边加阴影，并且同时圆角
 */
- (UIView *)addShadowToView:(UIView *)view withOpacity:(float)shadowOpacity shadowRadius:(CGFloat)shadowRadius andCornerRadius:(CGFloat)cornerRadius {
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    UIView *shadowView = [[UIView alloc] init];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowOpacity = shadowOpacity;
    shadowView.layer.shadowRadius = shadowRadius;
    shadowView.layer.cornerRadius = cornerRadius;
    shadowView.clipsToBounds = NO;
    [shadowView addSubview:view];
    return shadowView;
}

- (void)setupUI {
    
    YCShadowView *backView = [[YCShadowView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    //    [backView yc_shaodw];
    [backView yc_shaodwRadius:5 shadowColor:[UIColor colorWithWhite:0 alpha:0.2] shadowOffset:CGSizeMake(0, 1) byShadowSide:YCShadowSideAllSides];
    [backView yc_cornerRadius:10];
    //    backView.layer.borderColor = [UIColor colorWithHex:@"#DFDFDF"].CGColor;
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(15);
        make.left.equalTo(backView.mas_left).offset(20);
    }];
    
    
    LimitCollectionView *limitCollectionView = [[LimitCollectionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width -15*2, 200)];
    limitCollectionView.layer.masksToBounds = YES;
    [backView addSubview:limitCollectionView];
    _limitCollectionView = limitCollectionView;
    
    __weak __typeof(self)weakSelf = self;
    limitCollectionView.headClickBlock = ^(CGFloat money) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        strongSelf.rechargeMoneyTextField.text = [NSString stringWithFormat:@"%0.lf", money];
        //        [strongSelf.tableView reloadData];
    };
    
    
    
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.userInteractionEnabled = NO;
    submitBtn.layer.cornerRadius = 40/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:16];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"前往支付" forState:UIControlStateNormal];
    //    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateNormal];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(goto_payController) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBtn];
    [submitBtn delayEnable];
    _submitBtn = submitBtn;
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(backView.mas_bottom).offset(-10);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
    }];
    
   
    
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = @"存款金额";
    titLabel.font = [UIFont systemFontOfSize:15];
    titLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:titLabel];
    
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(submitBtn.mas_top).offset(-23);
        make.left.equalTo(backView.mas_left).offset(20);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *yLabel = [[UILabel alloc] init];
    yLabel.text = @"元";
    yLabel.font = [UIFont systemFontOfSize:15];
    yLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [backView addSubview:yLabel];
    
    [yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.right.equalTo(backView.mas_right).offset(-25);
        make.width.mas_equalTo(20);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.tag = 3500;
//    textField.backgroundColor = [UIColor greenColor];  // 更改背景颜色
    textField.borderStyle = UITextBorderStyleNone;  //边框类型
    textField.font = [UIFont boldSystemFontOfSize:16.0];  // 字体
    textField.textColor = [UIColor colorWithHex:@"#333333"];  // 字体颜色
    textField.placeholder = @"请输入金额"; // 占位文字
    textField.textAlignment = NSTextAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeAlways; // 清空按钮
//    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad; // 键盘类型
        textField.returnKeyType = UIReturnKeyGo; // 返回按钮样式 有前往 搜索等
//    textField.borderStyle = UITextBorderStyleRoundedRect; // 光标过于靠前
    [backView addSubview:textField];
    _textField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titLabel.mas_centerY);
        make.left.equalTo(titLabel.mas_right).offset(10);
        make.right.equalTo(yLabel.mas_left).offset(-10);
        make.height.mas_equalTo(@(30));
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
