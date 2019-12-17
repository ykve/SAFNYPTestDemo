//
//  SendRedPackedCell.m
//  Project
//
//  Created by AFan on 2019/2/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SelectMineNumCell.h"
#import "SendRPCollectionViewCell.h"
#import "SendRPCollectionView.h"

#define kColumn 5
#define kSpacingWidth 10
#define kTableViewMarginWidth 20
#define kBtnWidth 60

@interface SelectMineNumCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UILabel *moneyLabel;


@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *resultDataArray;
@property (nonatomic, strong) SendRPCollectionView *sendRPCollectionView;


@end

@implementation SelectMineNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    SelectMineNumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SelectMineNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
       
        //        [self setupSubViews];
    }
    return self;
}


- (void)setupUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(kTableViewMarginWidth);
        make.right.equalTo(self.mas_right).offset(-kTableViewMarginWidth);
        make.height.mas_equalTo(100);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"雷       号";
    _titleLabel.font = [UIFont systemFontOfSize2:15];
    _titleLabel.textColor = [UIColor colorWithHex:@"#343434"];
    [backView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).offset(10);
        make.top.equalTo(backView.mas_top).offset(CD_Scal(35, 812));
    }];
    
    
//    _noButton = [UIButton new];
//    _noButton.layer.cornerRadius = (kBtnWidth-15)/2;
//    _noButton.layer.masksToBounds = YES;
//    _noButton.layer.borderWidth = 1;
//    _noButton.layer.borderColor = [UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000].CGColor;
//    _noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.890 blue:0.847 alpha:1.000];
//    [_noButton setTitle:@"不" forState:UIControlStateNormal];
//    _noButton.titleLabel.font = [UIFont boldSystemFontOfSize2:30];
//    [_noButton setTitleColor:[UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000] forState:UIControlStateNormal];
//    [_noButton addTarget:self action:@selector(onNoButton:) forControlEvents:UIControlEventTouchUpInside];
//    _noButton.hidden = YES;
//    CGSize size = CGSizeMake(kBtnWidth-15, kBtnWidth-15);
//
//    //    [_noButton setBackgroundImage: [self createImageWithColor:[UIColor colorWithRed:0.725 green:0.761 blue:0.843 alpha:1.000] size:size]  forState:UIControlStateNormal];
//    //    [_noButton setBackgroundImage: [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.459 blue:0.796 alpha:1.000] size:size] forState:UIControlStateSelected];
//
//    [backView addSubview:_noButton];
    
//    [_noButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(backView.mas_right).offset(-10);
//        make.centerY.equalTo(sendRPCollectionView.mas_centerY);
//        make.size.mas_equalTo(size);
//    }];
    
    
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width -kTableViewMarginWidth*2 - kSendRPTitleCellWidth - (kColumn + 1) * kSpacingWidth) / kColumn;
    CGFloat height = itemWidth * 2 + kSpacingWidth * 3;
    
    CGFloat frameHeight = (CD_Scal(130, 812) - height) / 2;
    SendRPCollectionView *sendRPCollectionView = [[SendRPCollectionView alloc] initWithFrame:CGRectMake(kSendRPTitleCellWidth, frameHeight, [UIScreen mainScreen].bounds.size.width - kTableViewMarginWidth*2 - kSendRPTitleCellWidth, height)];
    //    sendRPCollectionView.backgroundColor = [UIColor redColor];
    sendRPCollectionView.collectionView.allowsMultipleSelection = YES;
    sendRPCollectionView.tag = 99;
    sendRPCollectionView.selectNumCollectionViewBlock = ^{
        if (self.selectNumBlock) {
            self.selectNumBlock(self.sendRPCollectionView.collectionView.indexPathsForSelectedItems);
        }
    };
    sendRPCollectionView.selectMoreMaxCollectionViewBlock = ^{
        if (self.selectMoreMaxBlock) {
            self.selectMoreMaxBlock(YES);
        }
    };
    [backView addSubview:sendRPCollectionView];
    _sendRPCollectionView = sendRPCollectionView;

}





/**
 设置颜色为背景图片
 
 @param color <#color description#>
 @param size <#size description#>
 @return <#return value description#>
 */
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)action_sendRedpacked {
    if (self.mineCellSubmitBtnBlock) {
        self.mineCellSubmitBtnBlock();
    }
}

- (void)onNoButton:(UIButton *)btn {
    btn.selected = !btn.selected;

    if (btn.selected) {
        self.noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000];
        [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.noButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.890 blue:0.847 alpha:1.000];
        [self.noButton setTitleColor:[UIColor colorWithRed:1.000 green:0.443 blue:0.247 alpha:1.000] forState:UIControlStateNormal];
    }
    
    if (self.selectNoPlayingBlock) {
        self.selectNoPlayingBlock(btn.selected);
    }
}


- (void)setModel:(id)model {
    
    self.resultDataArray = [NSMutableArray arrayWithArray:(NSArray *)model];
    self.sendRPCollectionView.model = self.resultDataArray;

    //    [self.collectionView reloadData];
    //    _titleLabel.text =  [dict objectForKey:@"pokerCount"];
    
}

- (void)setIsBtnDisplay:(BOOL)isBtnDisplay {
    self.noButton.hidden = !isBtnDisplay;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setMaxNum:(NSInteger)maxNum{
    _maxNum = maxNum;
    _sendRPCollectionView.maxNum = maxNum;
}
@end


