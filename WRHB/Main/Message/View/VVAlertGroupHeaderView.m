//
//  VVAlertGroupHeaderView.m
//  WRHB
//
//  Created by AFan on 2019/3/18.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "VVAlertGroupHeaderView.h"
@interface VVAlertGroupHeaderView ()
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *iconImageView;


@end

@implementation VVAlertGroupHeaderView

///像 自定义cell一样 定义一个headerView
+ (instancetype)VVAlertGroupHeaderViewWithTableView:(UITableView *)tableView {
    static NSString *headerID = @"header";
    VVAlertGroupHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    
    return headerView;
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        //布局子控件
        [self setupChlidView];
    }
    
    return self;
}


- (void)setupChlidView{
    
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"-";
    numLabel.font = [UIFont systemFontOfSize:13];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.backgroundColor = [UIColor colorWithHex:@"#FD2929"];
    
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    numLabel.layer.cornerRadius = 18/2;
    numLabel.layer.masksToBounds = YES;
    _numLabel = numLabel;
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"-";
    nameLabel.font = [UIFont vvFontOfSize:14];
    nameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kSCREEN_WIDTH -30*2 -15*2);
        make.left.equalTo(numLabel.mas_right).offset(10);
    }];
    
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerBtnClick)];
    [self addGestureRecognizer:tapGesturRecognizer];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_X(240, 240, 240);
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    //    iconImageView.hidden = YES;
//    iconImageView.image = [UIImage imageNamed:@"cm_gg_select_down"];
    [self.contentView addSubview:iconImageView];
//    iconImageView.backgroundColor = [UIColor greenColor];
    _iconImageView = iconImageView;
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(13, 8));
    }];
    
    
}

- (void)headerBtnClick {
//    self.groupModel.expend = !self.groupModel.expend;
    
    if (!self.groupModel.isExpend) {
        //没有展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        
    }else {
        //展开
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }
    
    if ([self.delegate respondsToSelector:@selector(VVAlertGroupHeaderViewDidClickBtn:)]) {
        
        [self.delegate VVAlertGroupHeaderViewDidClickBtn:self];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    self.headerBtn.frame = self.bounds;
//
//    CGFloat countX = self.bounds.size.width - 160;

}


- (void)setGroupModel:(VVAlertModel *)groupModel {
    _groupModel = groupModel;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@", groupModel.name];
    self.numLabel.text = [NSString stringWithFormat:@"%zd",self.index];
//    [self.headerBtn setTitle:[NSString stringWithFormat:@"%zd. %@",self.index, groupModel.name] forState:0];
    
    if (!self.groupModel.isExpend) {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.iconImageView.image = [UIImage imageNamed:@"cm_gg_select_down"];
    } else {
        self.headerBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        self.iconImageView.image = [UIImage imageNamed:@"cm_gg_select_up"];
    }
    
}

@end
