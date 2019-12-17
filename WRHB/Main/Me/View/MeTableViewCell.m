//
//  MeTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/10/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "MeTableViewCell.h"

@interface MeTableViewCell ()

/// <#strong注释#>
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIButton *icopyButton;


@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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



- (void)setModel:(id)model {
    if ([model isKindOfClass:[NSDictionary class]]) {
        _model = model;
        
        self.headImageView.image = [UIImage imageNamed:model[@"img"]];
        self.nameLabel.text = model[@"title"];
        
        if (self.unusualMarkIndex -100 == 0) {
            self.desLabel.text = [NSString stringWithFormat:@"%ld", [AppModel sharedInstance].user_info.userId];
        }
        
        
    } else {
        return;
    }
}

- (void)setUnusualMarkIndex:(NSInteger)unusualMarkIndex {
    _unusualMarkIndex = unusualMarkIndex;
    if (unusualMarkIndex - 100 == 0) {
        self.selectImageView.hidden = YES;
        self.icopyButton.hidden = NO;
        self.desLabel.hidden = NO;
    }
}

- (void)setupUI {
    
    CGFloat marginWidth = 15;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"me_cell_bg"];
    [self addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, marginWidth, 8, marginWidth));
    }];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"imageName"];
    [self addSubview:headImageView];
    _headImageView = headImageView;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(marginWidth +15);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(33);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHex:@"#666666"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(headImageView.mas_right).offset(20);
    }];
    
    UIImageView *selectImageView = [[UIImageView alloc] init];
    selectImageView.image = [UIImage imageNamed:@"me_cell_select"];
    [self addSubview:selectImageView];
    _selectImageView = selectImageView;
    
    [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(marginWidth +20));
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(15);
    }];
    
    
    UIButton *copyButton = [UIButton new];
    copyButton.hidden = YES;
    copyButton.backgroundColor = [UIColor redColor];
    copyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyButton.layer.masksToBounds = YES;
    copyButton.layer.cornerRadius = 28/2;
    [copyButton addTarget:self action:@selector(onCopyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copyButton];
    _icopyButton = copyButton;
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-(marginWidth +20));
        make.size.mas_equalTo(CGSizeMake(55, 28));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.hidden = YES;
    desLabel.text = @"-";
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor colorWithHex:@"#999999"];
    desLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:desLabel];
    _desLabel = desLabel;
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-110);
    }];
}

- (void)onCopyBtn {
    NSString *s = self.desLabel.text;
    if(s.length == 0) {
         s = @"";
    }
    
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = s;
    [MBProgressHUD showSuccessMessage:@"复制成功"];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
