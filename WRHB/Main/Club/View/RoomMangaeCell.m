//
//  RoomMangaeCell.m
//  WRHB
//
//  Created by AFan on 2019/12/3.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "RoomMangaeCell.h"
#import "RoomMangaeModel.h"
#import "FLAnimatedImageView.h"
@interface RoomMangaeCell()

/// 图片
@property (nonatomic, strong) FLAnimatedImageView *headView;
/// title
@property (nonatomic, strong) UILabel *titleLabel;
/// 房间人数
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *closedButton;

@end

@implementation RoomMangaeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    RoomMangaeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[RoomMangaeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setModel:(RoomMangaeModel *)model {
    _model = model;
    
    if (model.avatar.length < kAvatarLength) {
        FLAnimatedImage *image = [[FunctionManager sharedInstance] gifFLAnimatedImageStr:[NSString stringWithFormat:@"chats_gif_%@", model.avatar]];
        if (image) {
            _headView.animatedImage =  image;
        } else {
            
            _headView.image =  [UIImage imageNamed:@"cm_default_image"];
        }
    } else {
        [_headView cd_setImageWithURL:[NSURL URLWithString:[NSString cdImageLink:model.avatar]] placeholderImage:[UIImage imageNamed:@"cm_default_image"]];
    }
    
    self.titleLabel.text = model.title;
    self.numLabel.text = [NSString stringWithFormat:@"房间人数: %zd", model.member_count];
    
    if (model.status == 1) {
        self.closedButton.backgroundColor = [UIColor redColor];
        [self.closedButton setTitle:@"关闭" forState:UIControlStateNormal];
    } else if (model.status == 2) {
        self.closedButton.backgroundColor = [UIColor colorWithHex:@"#21AD31"];
        [self.closedButton setTitle:@"开启" forState:UIControlStateNormal];
    }
    
}


- (void)onClosedButton:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"开启"]) {
        if (self.roomOpenBlock) {
            self.roomOpenBlock(self.model);
        }
    } else {
        if (self.roomClosedBlock) {
            self.roomClosedBlock(self.model);
        }
    }
}

- (void)onDeleteButton:(UIButton *)sender {
    if (self.roomDeleteBlock) {
        self.roomDeleteBlock(self.model);
    }
}


- (void)setupUI {

    self.backgroundColor = [UIColor clearColor];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    [self.contentView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    FLAnimatedImageView *headView = [[FLAnimatedImageView alloc] init];
    headView.layer.cornerRadius = 5;
    headView.layer.masksToBounds = YES;
    [backView addSubview:headView];
    _headView = headView;

    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(12);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(60);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    _titleLabel = titleLabel;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top);
        make.left.equalTo(headView.mas_right).offset(10);
        make.right.equalTo(backView.mas_right).offset(-90);
    }];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"-";
    numLabel.numberOfLines = 1;
    numLabel.font = [UIFont systemFontOfSize:16];
    numLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [backView addSubview:numLabel];
    _numLabel = numLabel;
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom);
        make.left.equalTo(headView.mas_right).offset(10);
        make.right.equalTo(backView.mas_right).offset(90);
    }];

    UIButton *closedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:closedButton];
//    _closedButton = addButton;
    closedButton.layer.cornerRadius = 5;
    closedButton.backgroundColor = [UIColor redColor];
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [closedButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closedButton setTintColor:[UIColor whiteColor]];
    closedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [closedButton addTarget:self action:@selector(onClosedButton:) forControlEvents:UIControlEventTouchUpInside];
    closedButton.tag = 2000;
    _closedButton = closedButton;
    
    [closedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView.mas_top).offset(-3);
        make.right.equalTo(backView.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:deleteButton];
    //    _closedButton = addButton;
    deleteButton.layer.cornerRadius = 5;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.borderColor = [UIColor colorWithHex:@"#666666"].CGColor;
//    deleteButton.backgroundColor = [UIColor redColor];
    //    doneButton.frame = CGRectMake(0, 0, 50, 30);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton addTarget:self action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.tag = 2000;
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headView.mas_bottom).offset(3);
        make.right.equalTo(backView.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
