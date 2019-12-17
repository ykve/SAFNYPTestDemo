//
//  WithdrawalAlertViewController.m
//  WRHB
//
//  Created by AFan on 2019/11/22.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "WithdrawalAlertViewController.h"
#import "VVAlertModel.h"
#import "WitAlertHeaderView.h"
#import "NSString+Size.h"
#import "WitAlertTextCell.h"

@interface WithdrawalAlertViewController () <UITableViewDataSource,UITableViewDelegate, WitAlertHeaderViewDelegate>
{
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *backImageView;

@end

@implementation WithdrawalAlertViewController


+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    
    WithdrawalAlertViewController *instance = [WithdrawalAlertViewController new];
    instance.titleStr = title;
    instance.dataArray = dataArray;
    if(dataArray.count == 1){
        VVAlertModel *model = dataArray[0];
        model.expend = YES;
    }
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    
    _contentMargin = UIEdgeInsetsMake(25, 20, 0, 20);
    _contentViewWidth = kSCREEN_WIDTH -30*2;
    _buttonHeight = 45;
    _firstDisplay = YES;
    //    _messageAlignment = NSTextAlignmentCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.bgView];
    
    //创建对话框
    [self creatShadowView];
    [self creatContentView];
    [self setTableViewUI];
    
    
    self.titleLabel.text = self.titleStr;
    
    [self.tableView registerClass:[WitAlertTextCell class] forCellReuseIdentifier:@"WitAlertTextCell"];
}



//#pragma mark - TableView
- (void)setTableViewUI {
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //        self.tableView.tableHeaderView = self.headView;
    //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        if (@available(iOS 11.0, *)) {
    //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //        } else {
    //            // Fallback on earlier versions
    //        }
    _tableView.sectionHeaderHeight = 44;
    //        _tableView.estimatedRowHeight = 0;
    //        _tableView.estimatedSectionHeaderHeight = 0;
    //        _tableView.estimatedSectionFooterHeight = 0;
    [self.backImageView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.backImageView.mas_left).offset(10);
        make.right.equalTo(self.backImageView.mas_right).offset(-10);
        make.bottom.equalTo(self.backImageView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark - UITableViewDataSource
// //返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    VVAlertModel *model = self.dataArray[section];
    return model.isExpend ? model.friends.count : 0;
    
}

// //配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VVAlertModel *model = self.dataArray[indexPath.section];
    static NSString *cellId = @"WitAlertTextCell";
    WitAlertTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
        cell = [WitAlertTextCell cellWithTableView:tableView reusableId:cellId];
    //SystemAlertTextCell *cell = [SystemAlertTextCell cellWithTableView:tableView reusableId:@"SystemAlertTextCell"];
    //
    cell.model = model.friends[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate

// 设置节数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VVAlertModel *model = self.dataArray[indexPath.section];
    
    CGFloat height =  [model.friends[indexPath.row] heightWithFont:[UIFont vvFontOfSize:15] constrainedToWidth:kSCREEN_WIDTH -30*2 -(30 + 10 + 1)];
    height = height + 10 *2;
    if (height > 40) {
        return height;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    VVAlertModel *model = self.dataArray[section];
    
    NSString *nameStr = [NSString stringWithFormat:@"%zd. %@",section+1, model.name];
    CGFloat height =  [nameStr heightWithFont:[UIFont vvFontOfSize:14] constrainedToWidth:kSCREEN_WIDTH -30*2 -20*2];
    height = height + 10 *2;
    if (height > 44) {
        return height;
    }
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    WitAlertHeaderView *headerView = [WitAlertHeaderView VVAlertGroupHeaderViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.index = section +1;
    VVAlertModel *model = self.dataArray[section];
    headerView.groupModel = model;
    headerView.tag = section;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)WitAlertHeaderViewDidClickBtn:(WitAlertHeaderView *)headerView {
    
    for (NSInteger index = 0; index < self.dataArray.count; index++) {
        VVAlertModel *model = self.dataArray[index];
        if (headerView.tag == index) {
            if (model.expend == YES) {
                model.expend = NO;
            } else {
                model.expend = YES;
            }
        } else {
            model.expend = NO;
        }
    }
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.dataArray.count)];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];
    //显示弹出动画
    [self showAppearAnimation];
}


#pragma mark - 显示弹出动画
- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.bgView.alpha = 0.0;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.shadowView.transform = CGAffineTransformIdentity;
            self.shadowView.alpha = 1;
            self.bgView.alpha = 1.0;
        } completion:nil];
    }
}

#pragma mark - 事件响应
- (void)didClickCloseBtn:(UIButton *)sender {
    //    CKAlertAction *action = self.actions[sender.tag-10];
    //    if (action.actionHandler) {
    //        action.actionHandler(action);
    //    }
    
    [self hidDisappearAnimation];
}


#pragma mark - 消失动画
- (void)hidDisappearAnimation {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.shadowView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.contentView.alpha = 0;
        self.bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)onShadowViewDisappear {
    [self hidDisappearAnimation];
}

#pragma mark - 创建内部视图

//阴影层
- (void)creatShadowView {
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    self.shadowView.layer.masksToBounds = NO;
    self.shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    self.shadowView.layer.shadowRadius = 20;
    self.shadowView.layer.shadowOpacity = 1;
    [self.bgView addSubview:self.shadowView];
    
    //添加手势事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShadowViewDisappear)];
    //将手势添加到需要相应的view中去
    [self.shadowView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
}

//内容层
- (void)creatContentView {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, kSCREEN_WIDTH -30*2, 500)];
    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.backgroundColor = [UIColor clearColor];
    //    _contentView.layer.cornerRadius = 10;
    //    _contentView.clipsToBounds = YES;
    _contentView.layer.masksToBounds = YES;
    //    _contentView.backgroundColor = [UIColor redColor];
    [self.shadowView addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shadowView.mas_centerY);
        make.left.equalTo(self.shadowView.mas_left).offset(30);
        make.right.equalTo(self.shadowView.mas_right).offset(-30);
        make.height.mas_equalTo(460);
    }];
    
    //    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]; // nav_sysnotiTopBack
    //    [_contentView addSubview:topView];
    //    topView.userInteractionEnabled = YES;
    //    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.equalTo(self->_contentView);
    //        make.height.mas_equalTo(50);
    //    }];
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"common_gonggao_bg"];
    backImageView.userInteractionEnabled = YES;
    [_contentView addSubview:backImageView];
    _backImageView = backImageView;
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self->_contentView);
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor clearColor];
    [backImageView addSubview:topView];
    _topView = topView;
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(90);
        make.left.equalTo(backImageView.mas_left).offset(10);
        make.right.equalTo(backImageView.mas_right).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont systemFontOfSize:26];
    titleLabel.textColor = [UIColor colorWithHex:@"#E14D46"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    
    
    //    UIButton *closeBtn = [[UIButton alloc] init];
    //    [closeBtn addTarget:self action:@selector(didClickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    //    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    //    [closeBtn setImage:[UIImage imageNamed:@"message_close"] forState:UIControlStateNormal];
    //    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
    //    [topView addSubview:closeBtn];
    //
    //    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(topView);
    //        make.left.equalTo(topView.mas_left).offset(6);
    //        make.size.mas_equalTo(CGSizeMake(45, 45));
    //    }];
}


@end

