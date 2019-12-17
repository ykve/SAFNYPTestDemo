//
//  ClubMemberCell.m
//  WRHB
//
//  Created by AFan on 2019/12/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubMemberCell.h"
#import "UIButton+GraphicBtn.h"
#import "ClubMemberModel.h"
#import "UIButton+Layout.h"

@interface ClubMemberCell ()

/// 昵称
@property (nonatomic, strong) UILabel *nameLabel;
/// ID
@property (nonatomic, strong) UILabel *IDLabel;
/// 余额
@property (nonatomic, strong) UILabel *yuELabel;
/// 流水
@property (nonatomic, strong) UILabel *LSLabel;



@end

@implementation ClubMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


- (void)setModel:(ClubMemberModel *)model {
    _model = model;
 
    self.nameLabel.text = model.name;
    self.IDLabel.text = [NSString stringWithFormat:@"%zd", model.ID];
    self.yuELabel.text = model.over_num;
    self.LSLabel.text = model.capital;
    
    if (model.role == 1) {
        [self.IDTypeBtn setTitle:@"会员" forState:UIControlStateNormal];
//        [self.IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
//        [self.IDTypeBtn setImagePosition:WPGraphicBtnTypeRight spacing:10];
    } else  if (model.role == 2) {
        [self.IDTypeBtn setTitle:@"管理员" forState:UIControlStateNormal];
//        [self.IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
        
//        [self.IDTypeBtn setImagePosition:WPGraphicBtnTypeRight spacing:10];
    } else  if (model.role == 3) {
        [self.IDTypeBtn setTitle:@"群主" forState:UIControlStateNormal];
//        [self.IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
//        [self.IDTypeBtn setImagePosition:WPGraphicBtnTypeRight spacing:10];
    }
        
    if (model.can_speak == 1) {
        // 不禁言
    } else  if (model.role == 2) {
       // 禁言
    }
}

/// 操作
- (void)onOperationTypeBtn {
    if (self.memberOperationTypeBlock) {
        self.memberOperationTypeBlock(self.model,self);
    }
}
/// 身份类型选择
- (void)onIDTypeBtn {
    if (self.memberIDTypeBlock) {
        self.memberIDTypeBlock(self.model, self);
    }
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
    [operationTypeBtn setBackgroundImage:[UIImage imageNamed:@"club_operation_set"] forState:UIControlStateNormal];
    [operationTypeBtn addTarget:self action:@selector(onOperationTypeBtn) forControlEvents:UIControlEventTouchUpInside];
    operationTypeBtn.tag = 1000;
    [backView addSubview:operationTypeBtn];
    [operationTypeBtn delayEnable];
    _operationTypeBtn = operationTypeBtn;
    
    [operationTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-15);
        make.centerY.equalTo(backView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 19));
    }];
    
    
    UIButton *IDTypeBtn = [[UIButton alloc] init];
//    IDTypeBtn.backgroundColor = [UIColor greenColor];
//    [IDTypeBtn setTitle:@"会员" forState:UIControlStateNormal];
//     [IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
    [IDTypeBtn addTarget:self action:@selector(onIDTypeBtn) forControlEvents:UIControlEventTouchUpInside];
    [IDTypeBtn setTitleColor:[UIColor colorWithHex:@"#343434"] forState:UIControlStateNormal];
    IDTypeBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [IDTypeBtn setImage:[UIImage imageNamed:@"club_red_down"] forState:UIControlStateNormal];
    IDTypeBtn.titleRect = CGRectMake(0, 0, 50, 20);
    IDTypeBtn.imageRect = CGRectMake(52, 8, 13, 6);
    
//    [IDTypeBtn setImagePosition:WPGraphicBtnTypeRight spacing:10];
    IDTypeBtn.tag = 1001;
    IDTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [backView addSubview:IDTypeBtn];
    _IDTypeBtn = IDTypeBtn;
    
    [IDTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(operationTypeBtn.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    
    
    // ****** 流水 ******
    UILabel *LSLabel = [[UILabel alloc] init];
//    LSLabel.backgroundColor = [UIColor yellowColor];
    LSLabel.text = @"-";
    LSLabel.font = [UIFont systemFontOfSize:fontSize];
    LSLabel.textColor = [UIColor colorWithHex:@"#343434"];
    LSLabel.numberOfLines = 1;
    LSLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:LSLabel];
    _LSLabel = LSLabel;
    
    [LSLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(IDTypeBtn.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    // ****** 余额 ******
    UILabel *yuELabel = [[UILabel alloc] init];
//    yuELabel.backgroundColor = [UIColor greenColor];
    yuELabel.text = @"-";
    yuELabel.font = [UIFont systemFontOfSize:fontSize];
    yuELabel.textColor = [UIColor colorWithHex:@"#343434"];
    yuELabel.numberOfLines = 1;
    yuELabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:yuELabel];
    _yuELabel = yuELabel;
    
    [yuELabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(LSLabel.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    // ****** ID ******
    UILabel *IDLabel = [[UILabel alloc] init];
//    IDLabel.backgroundColor = [UIColor redColor];
    IDLabel.text = @"-";
    IDLabel.font = [UIFont systemFontOfSize:fontSize];
    IDLabel.textColor = [UIColor colorWithHex:@"#343434"];
    IDLabel.numberOfLines = 1;
    IDLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:IDLabel];
    _IDLabel = IDLabel;
    
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yuELabel.mas_left).offset(-spacingWidht);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    
    // ****** 昵称 ******
    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.backgroundColor = [UIColor cyanColor];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:fontSize];
    nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
    nameLabel.numberOfLines = 1;
    [backView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(15);
        make.centerY.equalTo(backView.mas_centerY);
        make.right.equalTo(IDLabel.mas_left).offset(-spacingWidht);
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
