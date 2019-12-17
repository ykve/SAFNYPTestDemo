//
//  LocalAvatarController.m
//  WRHB
//
//  Created by AFan on 2019/11/16.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "LocalAvatarController.h"
#import "AvatarCollectionViewCell.h"

static NSString * kAvatarCollectionViewCellId = @"AvatarCollectionViewCell";
#define kHeadViewHeight 60

@interface LocalAvatarController ()<UICollectionViewDelegate, UICollectionViewDataSource>
///
@property (nonatomic, strong) UISegmentedControl *segment;
///
@property (nonatomic, strong) UICollectionView *collectionView;
/// 0 男 1  女
@property (nonatomic, assign) NSInteger segmentedControlIndex;
///
@property (nonatomic, strong) NSArray *dataArray;
/// 男 头像
@property (nonatomic, strong) NSMutableArray *maleArray;
/// 女 头像
@property (nonatomic, strong) NSMutableArray *femaleArray;

///
@property (nonatomic, copy) NSString *selectedImgName;

@end

@implementation LocalAvatarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"本地头像";
    self.view.backgroundColor = [UIColor colorWithHex:@"#FBFBFB"];
    
    self.segmentedControlIndex = 0;
    
    [self initUI];
    
    [self initData];
}

- (void)initData {
    _maleArray = [[NSMutableArray alloc] init];
    _femaleArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 1; index <= 30; index++) {
        [_femaleArray addObject:[NSString stringWithFormat:@"group_av_%zd",300 + index]];
        if (index > 25) {
            continue;
        }
        [_maleArray addObject:[NSString stringWithFormat:@"group_av_%zd",200 + index]];
        
    }
    [self.collectionView reloadData];
}

- (void)initUI {
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar +10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(kHeadViewHeight -30);
        make.width.mas_equalTo(100);
    }];
    
    [self initSubviews];
    
    
    UIButton *savebtn = [UIButton new];
    [self.view addSubview:savebtn];
    savebtn.titleLabel.font = [UIFont boldSystemFontOfSize2:17];
    [savebtn setTitle:@"保存" forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(on_saveBtn) forControlEvents:UIControlEventTouchUpInside];
    [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [savebtn setBackgroundImage:[UIImage imageNamed:@"reg_btn"] forState:UIControlStateNormal];
    savebtn.layer.cornerRadius = 5.0f;
    savebtn.layer.masksToBounds = YES;
    savebtn.backgroundColor = [UIColor redColor];
    [savebtn delayEnable];
    [savebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.equalTo(self.view.mas_top).offset(Height_NavBar + 450);
        make.height.equalTo(@(50));
    }];
}


- (void)on_saveBtn {
    if ([_target respondsToSelector:_action])
    {
        [_target performSelector:_action withObject:self.selectedImgName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UISegmentedControl *)segment{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"男生",@"女生"]];
        _segment.tintColor = [UIColor redColor];
        _segment.selectedSegmentIndex = 0;//选中第几个segment 一般用于初始化时选中
        [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        [_segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        _segment.selectedSegmentIndex = 0;
        _segment.layer.masksToBounds = YES;
        _segment.layer.cornerRadius = 3;
        [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segment;
}

- (void)segmentValueChanged:(UISegmentedControl *)sec {
    
    self.segmentedControlIndex = sec.selectedSegmentIndex;
    [self.collectionView reloadData];
}


#pragma mark -- UICollectionViewDataSource 数据源

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentedControlIndex == 0) {
         return self.maleArray.count;
    } else {
         return self.femaleArray.count;
    }
   
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AvatarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAvatarCollectionViewCellId forIndexPath:indexPath];
    
    NSString *strImg = nil;
    if (self.segmentedControlIndex == 0) {
       strImg = self.maleArray[indexPath.row];;
    } else {
        strImg = self.femaleArray[indexPath.row];;
    }
    cell.headImageView.image =  [UIImage imageNamed:strImg];
    if ([self.selectedImgName isEqualToString:strImg]) {
        cell.selectedImageView.hidden = NO;
    } else {
        cell.selectedImageView.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strImg = nil;
    if (self.segmentedControlIndex == 0) {
        strImg = self.maleArray[indexPath.row];;
    } else {
        strImg = self.femaleArray[indexPath.row];;
    }
    self.selectedImgName = strImg;
    [self.collectionView reloadData];
}


#pragma mark - 首先创建一个collectionView
- (void)initSubviews {
    
    //    首先创建一个collectionView
    //    创建的时候UICollectionViewFlowLayout必须创建
    //    layout.itemSize必须设置
    //    必须注册一个collectionView的自定义cell
    /**
     创建layout(布局)
     UICollectionViewFlowLayout 继承与UICollectionLayout
     对比其父类 好处是 可以设置每个item的边距 大小 头部和尾部的大小
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat ssWidth = ([UIScreen mainScreen].bounds.size.width - 25*2 - 50 * 5)/ 4-0.5;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(50, 50);
    
    // 设置列间距
    layout.minimumInteritemSpacing = ssWidth;
    
    // 设置行间距
    layout.minimumLineSpacing = 10;
    
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(0, 25, 8, 25);
    //
    // 设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    //layout.estimatedItemSize = CGSizeMake(CGFloat width, <#CGFloat height#>);
    
    // 设置布局方向(滚动方向)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置头视图尺寸大小
    //layout.headerReferenceSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
    
    // 设置尾视图尺寸大小
    //layout.footerReferenceSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
    //
    // 设置分区(组)的EdgeInset（四边距）
    //layout.sectionInset = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
    //
    // 设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    //        layout.sectionFootersPinToVisibleBounds = YES;
    //        layout.sectionHeadersPinToVisibleBounds = YES;
    
    /**
     初始化mainCollectionView
     设置collectionView的位置
     */
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, Height_NavBar + kHeadViewHeight, [UIScreen mainScreen].bounds.size.width, kSCREEN_HEIGHT-Height_NavBar -kHeadViewHeight) collectionViewLayout:layout];
    
    /** mainCollectionView 的布局(必须实现的) */
    collectionView.collectionViewLayout = layout;
    
    //mainCollectionView 的背景色
    collectionView.backgroundColor = [UIColor clearColor];
    
    //禁止滚动
    //_collectionView.scrollEnabled = NO;
    
    //设置代理协议
    collectionView.delegate = self;
    
    //设置数据源协议
    collectionView.dataSource = self;
    
    /**
     四./注册cell
     在重用池中没有新的cell就注册一个新的cell
     相当于懒加载新的cell
     定义重用标识符(在页面最上定义全局)
     用自定义的cell类,防止内容重叠
     注册时填写的重用标识符 是给整个类添加的 所以类里有的所有属性都有重用标识符
     */
    [collectionView registerClass:[AvatarCollectionViewCell class] forCellWithReuseIdentifier:kAvatarCollectionViewCellId];
    
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}



@end
