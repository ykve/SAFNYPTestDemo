//
//  PayTopupItemTableViewCell.m
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopupItemTableViewCell.h"
#import "PayTopupItemCollectionView.h"
#import "PayTopupModel.h"
#import "YCShadowView.h"

@interface PayTopupItemTableViewCell ()

/// 限额CollectionView
@property (nonatomic, strong) PayTopupItemCollectionView *topupItemCollectionView;

@end

@implementation PayTopupItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    PayTopupItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PayTopupItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    self.topupItemCollectionView.model = dataArray;
    
}

- (void)setModel:(PayTopupModel *)model {
    _model = model;
    self.topupItemCollectionView.model = model.amounts;
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
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    PayTopupItemCollectionView *limitCollectionView = [[PayTopupItemCollectionView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width -15*2, 200)];
    limitCollectionView.layer.masksToBounds = YES;
    [backView addSubview:limitCollectionView];
    _topupItemCollectionView = limitCollectionView;
    
    //    __weak __typeof(self)weakSelf = self;
    //    limitCollectionView.headClickBlock = ^(CGFloat money) {
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        //        strongSelf.rechargeMoneyTextField.text = [NSString stringWithFormat:@"%0.lf", money];
    //        //        [strongSelf.tableView reloadData];
    //    };
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

