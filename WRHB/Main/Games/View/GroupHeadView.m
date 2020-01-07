//
//  GroupHeadView.m
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "GroupHeadView.h"
#import "UserCollectionViewCell.h"
#import "SessionInfoModels.h"


@interface GroupHeadView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    UIButton *_allBtn;
}
@property (nonatomic ,strong) NSArray *dataList;
/// 显示多少行
@property (nonatomic, assign) NSInteger showRow;

@end

@implementation GroupHeadView

/// model   数据模型
/// showRow  0 默认3行
/// isGroupLord  是否群主
+ (GroupHeadView *)headViewWithModel:(SessionInfoModels *)model showRow:(NSInteger)showRow isGroupLord:(BOOL)isGroupLord {
   
    
    NSInteger lorow = 0;
    if (isGroupLord) {
        lorow = (model.group_users.count + 2 == 0)?0: (model.group_users.count + 2)/5 + ((model.group_users.count + 2) % 5 > 0 ? 1: 0);
    } else {
       lorow = (model.group_users.count == 0)?0: model.group_users.count/5 + (model.group_users.count % 5 > 0 ? 1: 0);
    }
    
    if (showRow == 0) {
        lorow = (lorow > 3) ? 3 : lorow;
    } else {
        lorow = (lorow > showRow) ? showRow : lorow;
    }
    
    CGFloat height = lorow*CD_Scal(82, 667)+50;
    GroupHeadView *view = [[GroupHeadView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height)];
    view.dataList = model.group_users;
    view.isGroupLord = isGroupLord;
    [view updateList:model showRow:showRow];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupSubViews];
        [self initLayout];
    }
    return self;
}

#pragma mark - Data
- (void)initData{
    
}

- (void)updateList:(SessionInfoModels *)model showRow:(NSInteger)showRow {
     _dataList = model.group_users;
    [_collectionView reloadData];
    
    if (showRow < 999) {
        NSString *count = [NSString stringWithFormat:@"全部群成员(%ld)>",model.group_users.count];
        
        //    if([AppModel sharedInstance].user_info.innerNumFlag || [AppModel sharedInstance].user_info.groupowenFlag){
        //    }else
        //    {
        //        count = [NSString stringWithFormat:@"全部群成员(%ld)",model.total];
        //        _allBtn.userInteractionEnabled = NO;
        //    }
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:count];
        NSRange rang = NSMakeRange(0, count.length);
        [AttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize2:13] range:rang];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#999999"] range:NSMakeRange(rang.location, rang.length)];
        //[AttributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(rang.location, rang.length-2)];
        [_allBtn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
    }
    
}


#pragma mark ----- Layout
- (void)initLayout{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self-> _collectionView.mas_bottom).offset(0);
        make.width.equalTo(self.mas_width).offset(-60);
        make.height.equalTo(@(50));
    }];
}

#pragma mark ----- subView
- (void)setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kSCREEN_WIDTH/5, CD_Scal(82, 667));
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:NSClassFromString(@"UserCollectionViewCell") forCellWithReuseIdentifier:@"UserCollectionViewCell"];
    
    _allBtn = [UIButton new];
    [self addSubview:_allBtn];
    _allBtn.titleLabel.font = [UIFont systemFontOfSize2:15];
    [_allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [_allBtn addTarget:self action:@selector(action_allClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.isGroupLord) {
         return _dataList.count + 2;
    }
    return _dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row > _dataList.count - 1) {
        [cell addOrDeleteIndex:indexPath.row - (self.dataList.count -1)];
    } else {
        [cell update:_dataList[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(self.isGroupLord) {
        if (self.headAddOrDeleteClick) {
            self.headAddOrDeleteClick(indexPath.row - self.dataList.count);
        }
    }
}

#pragma mark action
- (void)action_allClick{
    if (self.headAddOrDeleteClick) {
        self.headAddOrDeleteClick(-1);
    }
}

@end
