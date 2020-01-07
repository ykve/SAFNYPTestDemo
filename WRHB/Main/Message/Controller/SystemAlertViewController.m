//
//  VVAlertViewController.m
//  WRHB
//
//  Created by AFan on 2019/3/17.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "SystemAlertViewController.h"
#import "VVAlertModel.h"
#import "VVAlertGroupHeaderView.h"
#import "NSString+Size.h"
#import "SystemAlertTextCell.h"

static CGFloat const ContentWidht = 291;

@interface SystemAlertViewController () <UITableViewDataSource,UITableViewDelegate, VVAlertGroupHeaderViewDelegate>
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

@implementation SystemAlertViewController


+ (instancetype)alertControllerWithTitle:(NSString *)title dataArray:(NSArray *)dataArray {
    
    SystemAlertViewController *instance = [SystemAlertViewController new];
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
    
    [self.tableView registerClass:[SystemAlertTextCell class] forCellReuseIdentifier:@"SystemAlertTextCell"];
}



//#pragma mark - TableView
- (void)setTableViewUI {
    
        _tableView = [[UITableView alloc] init];
//        _tableView.backgroundColor = [UIColor redColor];
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
        make.left.equalTo(self.backImageView.mas_left).offset(20);
        make.right.equalTo(self.backImageView.mas_right).offset(-25);
        make.bottom.equalTo(self.backImageView.mas_bottom).offset(-8);
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
    static NSString *cellId = @"SystemAlertTextCell";
    SystemAlertTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
        cell = [SystemAlertTextCell cellWithTableView:tableView reusableId:cellId];
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

    CGFloat height =  [model.friends[indexPath.row] heightWithFont:[UIFont vvFontOfSize:12] constrainedToWidth:ContentWidht -22*2 -(20 *2)];
    height = height + 15;
    if (height > 44) {
        return height;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    VVAlertModel *model = self.dataArray[section];
    
    NSString *nameStr = [NSString stringWithFormat:@"%zd. %@",section+1, model.name];
    CGFloat height =  [nameStr heightWithFont:[UIFont vvFontOfSize:16] constrainedToWidth:ContentWidht -30*2 -15*2];
    height = height + 10 *2;
    if (height > 35) {
        return height;
    }
    return 35;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    VVAlertGroupHeaderView *headerView = [VVAlertGroupHeaderView VVAlertGroupHeaderViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.index = section +1;
    VVAlertModel *model = self.dataArray[section];
    headerView.groupModel = model;
    headerView.tag = section;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}







- (void)VVAlertGroupHeaderViewDidClickBtn:(VVAlertGroupHeaderView *)headerView {
    
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
        [UIView animateWithDuration:0.1 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
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

- (void)onCloseBtn {
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
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((kSCREEN_WIDTH-291)/2, Height_NavBar+15, 291, 417)];
//    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.backgroundColor = [UIColor clearColor];
//    _contentView.layer.cornerRadius = 10;
//    _contentView.clipsToBounds = YES;
    _contentView.layer.masksToBounds = YES;
    //    _contentView.backgroundColor = [UIColor redColor];
    [self.shadowView addSubview:_contentView];
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
//    backImageView.backgroundColor = [UIColor redColor];
    backImageView.image = [UIImage imageNamed:@"cc_gonggao_bg"];
    backImageView.userInteractionEnabled = YES;
    [_contentView addSubview:backImageView];
    _backImageView = backImageView;
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self->_contentView);
    }];
    
    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = [UIColor grayColor];
    [backImageView addSubview:topView];
    _topView = topView;
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView.mas_top).offset(180);
        make.left.equalTo(backImageView.mas_left).offset(20);
        make.right.equalTo(backImageView.mas_right).offset(-25);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"-";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
    }];
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cc_close"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = 2300;
    [self.shadowView addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(36);
        make.centerX.equalTo(self.shadowView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
}


@end
