//
//  PayTopUpController.m
//  WRHB
//
//  Created by AFan on 2019/11/4.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopUpController.h"
#import "PayTopupModel.h"
#import "LimitCollectionView.h"
#import "PayItemCell.h"
#import "PayAmountCell.h"
#import "PayHeaderView.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "TopupAmountsModel.h"
#import "PayTopupItemTableViewCell.h"
#import "PayTopupQuotaTableViewCell.h"
#import "PayTopupWebViewCell.h"
#import "TopupBankCardDetailsVC.h"
#import "NSString+RegexCategory.h"
#import "PayTopupModels.h"


#define COLOR_WITH_RGB(R,G,B,A) [UIColor colorWithRed:R green:G blue:B alpha:A]

static const float WKJTopUpViewControllerFontOfSize = 15;
static const float WKJTopUpViewControllerBackViewHeight = 145;
@interface PayTopUpController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
/// 充值额度数组
@property (strong, nonatomic) NSMutableArray *quotaArray;
/// 网关充值数据
@property (strong, nonatomic) NSMutableArray *onlinePayItemsArray;


@property (copy, nonatomic) NSString *paytype;
@property (copy, nonatomic) NSString *wayId;
@property (strong, nonatomic) UIButton *chargeBtn;
/// 在线充值限额数组
@property (strong, nonatomic) NSMutableArray *quotaList;
@property (assign, nonatomic) CGFloat maxMoney;
@property (assign, nonatomic) CGFloat minMoney;

@property (nonatomic, strong) PayTopupModels *selectPayModels;
///
@property (nonatomic, strong) PayTopupModel *selectPayModel;
/// 失败重试次数
@property (nonatomic, assign) NSInteger failureRetryCount;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

/// 充值金额
@property (copy, nonatomic) NSString *topupMoney;


@end


@implementation PayTopUpController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%s dealloc",object_getClassName(self));
    
}

- (UIView *)listView {
    return self.view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    _failureRetryCount = 3;
    [self goto_Login];
    //    [self loadPayListData];
    //    [self loadQueryQuotaList];
    
    //    [self getPersonData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    [self.tableView registerClass:[PayTopupItemTableViewCell class] forCellReuseIdentifier:@"PayTopupItemTableViewCell"];
    
    // 下拉刷新
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getTopupData];
    }];
}


// Controller
- (void)routerEventWithName:(NSString *)eventName user_info:(NSDictionary *)user_info
{
    // 充值Item选中
    if ([eventName isEqualToString:@"PayItemCellSelected"]) {
        PayTopupModel *model = user_info[@"model"];
        self.selectPayModel = model;
        
        NSIndexPath *ip=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:ip,nil] withRowAnimation:UITableViewRowAnimationNone];
        return;
    } else if ([eventName isEqualToString:@"PayAmountCellSelected"]) {  // 金额选择
        NSInteger money = [user_info[@"money"] integerValue];
        self.topupMoney = [NSString stringWithFormat:@"%zd", money];
    } else if ([eventName isEqualToString:@"PayTopupQuotaTableViewCellBtnClick"]) {  // 前往支付
        [self topupBtnClick:nil];
    }
    
    [super routerEventWithName:eventName user_info:user_info];
}


#pragma mark - vvUITableView
- (UITableView *)tableView {
    if (!_tableView) {
        
        CGFloat height = kSCREEN_HEIGHT- Height_NavBar -Height_TabBar - 50;
        if (self.isHidTabBar) {
            height = kSCREEN_HEIGHT- Height_NavBar - 50;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F7F7F7"];
        //        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //        self.tableView.tableHeaderView = self.headView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
        //        _tableView.rowHeight = 44;   // 行高
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 去掉分割线
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
//返回列表每个分组section拥有cell行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? 3 : 0;
}

//配置每个cell，随着用户拖拽列表，cell将要出现在屏幕上时此方法会不断调用返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PayTopupItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTopupItemTableViewCell"];
        if(cell == nil) {
            cell = [PayTopupItemTableViewCell cellWithTableView:tableView reusableId:@"PayTopupItemTableViewCell"];
        }
        
        cell.dataArray = self.dataArray;
        return cell;
        
    } else if (indexPath.row == 1) {
        
        PayTopupQuotaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTopupQuotaTableViewCell"];
        if(cell == nil) {
            cell = [PayTopupQuotaTableViewCell cellWithTableView:tableView reusableId:@"PayTopupQuotaTableViewCell"];
        }
        PayTopupModel *model = self.selectPayModel;
        cell.model = model;
        
        //        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    } else {
        
        PayTopupWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTopupWebViewCell"];
        if(cell == nil) {
            cell = [PayTopupWebViewCell cellWithTableView:tableView reusableId:@"PayTopupWebViewCell"];
        }
        //        cell.dataArray = self.dataArray[indexPath.row];
//        [cell.webView loadHTMLString:self.selectPayModels.tips baseURL:nil];
        [cell.webView ba_web_loadHTMLString:self.selectPayModels.tips];
        
//        cell.backgroundColor = [UIColor cyanColor];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && self.dataArray.count > 0) {
        NSInteger yuNum = self.dataArray.count % 3 == 0 ? 0 : 1;
        CGFloat height = (self.dataArray.count / 3 + yuNum) * 80 + 30;
        return height;
    } else if (indexPath.row == 1 && self.dataArray.count > 0) {
        PayTopupModel *model = self.dataArray.firstObject;
        NSInteger yuNum = model.amounts.count % 3 == 0 ? 0 : 1;
        CGFloat height = (model.amounts.count / 3 + yuNum) * 50 + 180;
        return height;
    } else if (indexPath.row == 2) {
        return kTopupWebCellHeight;
    }
    
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSDictionary *dict = self.dataArray[indexPath.row];
    
}








- (void)goto_Login {
    if ([AppModel sharedInstance].user_info.isGuestLogin) {
        [self onLogin];
        return;
    } else {
        [self judge];
    }
}
- (void)onLogin {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)judge {
    [self getTopupData];
}
-(void)myAccount {
    __weak __typeof(self)weakSelf = self;
    //    [WebTools postWithURL:@"/memberInfo/myAccount.json" params:nil success:^(BaseData *data) {
    //        __strong __typeof(weakSelf)strongSelf = weakSelf;
    //        [[Person person] setupWithDic:data.data];
    //        [strongSelf getTopupData];
    //    } failure:^(NSError *error) {
    //
    //    } showHUD:NO];
}



#pragma mark - 获取充值数据
- (void)getTopupData {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"recharge/channel"];
    entity.needCache = NO;
    
    id cacheJson = [XHNetworkCache cacheJsonWithURL:entity.urlString params:nil];
    if (cacheJson) {
        NSArray *payArray = [PayTopupModels mj_objectArrayWithKeyValuesArray:cacheJson];
        
        for (NSInteger index = 0; index < payArray.count; index++) {
            PayTopupModels *models = (PayTopupModels *)payArray[index];
            if (models.type == 1 && self.controllerIndex == 1) {  // 官方充值
                self.selectPayModels = models;
                self.dataArray = [models.items copy];
                PayTopupModel *model = (PayTopupModel *)models.items.firstObject;
                self.selectPayModel = model;
                break;
            } else if (models.type == 2 && self.controllerIndex == 0) {  // 网关充值
                self.selectPayModels = models;
                self.dataArray = [models.items copy];
                PayTopupModel *model = (PayTopupModel *)models.items.firstObject;
                self.selectPayModel = model;
                break;
            } else if (models.type == 3) {  //盈商充值
                
            }
        }
        
        [self.tableView reloadData];
    } else {
        [MBProgressHUD showActivityMessageInWindow:nil];
    }
    
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            
            NSArray *payArray = [PayTopupModels mj_objectArrayWithKeyValuesArray:response[@"data"]];
            
            for (NSInteger index = 0; index < payArray.count; index++) {
                PayTopupModels *models = (PayTopupModels *)payArray[index];
                if (models.type == 1 && strongSelf.controllerIndex == 1) {  // 官方充值
                    strongSelf.selectPayModels = models;
                    strongSelf.dataArray = [models.items copy];
                    PayTopupModel *model = (PayTopupModel *)models.items.firstObject;
                    strongSelf.selectPayModel = model;
                    break;
                } else if (models.type == 2 && strongSelf.controllerIndex == 0) {  // 网关充值
                    strongSelf.selectPayModels = models;
                    strongSelf.dataArray = [models.items copy];
                    PayTopupModel *model = (PayTopupModel *)models.items.firstObject;
                    strongSelf.selectPayModel = model;
                    break;
                } else if (models.type == 3) {  //盈商充值
                    
                }
            }
            
            [strongSelf.tableView reloadData];
            
            [XHNetworkCache save_asyncJsonResponseToCacheFile:response[@"data"] andURL:entity.urlString params:nil completed:^(BOOL result) {
                NSLog(@"1");
            }];
            
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        // 结束刷新
        [strongSelf.tableView.mj_header endRefreshing];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
    
    return;
    
}



#pragma mark -  UITextFieldDelegate
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [self.tableView reloadData];
//    return YES;
//}
//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    [self.tableView reloadData];
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    if (textField == self.topupMoney) {
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        } else if (self.topupMoney.text.length >= 8) {
//            self.topupMoney.text = [textField.text substringToIndex:8];
//            return NO;
//        }
//    }
//
//    return YES;
//}
- (void)textFieldDidChangeValue:(NSNotification *)text {
    UITextField *textField = (UITextField *)text.object;
    self.topupMoney = textField.text;
    //    self.limitCollectionView.model = [self.quotaArray copy];
    //    [self.tableView reloadData];
}
#pragma mark -  充值
/**
 充值
 
 @param sender sender
 */
- (void)topupBtnClick:(UIButton *)sender {
    
    if (self.topupMoney <= 0) {
        [MBProgressHUD showTipMessageInWindow:@"请选择充值金额"];
        return;
    }
    
    if (![NSString checkIsInteger:self.topupMoney]) {
        [MBProgressHUD showTipMessageInWindow:@"请输入整数金额"];
        return;
    }
    
    if (!self.selectPayModel.name) {
        [MBProgressHUD showTipMessageInWindow:@"请选择充值方式"];
        return;
    }
    
    if([self.topupMoney integerValue] < self.selectPayModel.minMoney){
        [MBProgressHUD showTipMessageInWindow:@"充值金额不能小于最小额度"];
        return;
    }
    
    if([self.topupMoney integerValue]> self.selectPayModel.maxMoney && self.selectPayModel.maxMoney != 0){
        [MBProgressHUD showTipMessageInWindow:@"充值金额不能超过最大额度"];
        return;
    }
    
#pragma mark -  人工充值
    TopupBankCardDetailsVC *vc = [[TopupBankCardDetailsVC alloc] init];
    vc.selectPayModel = self.selectPayModel;
    vc.topupMoney = self.topupMoney;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    
    
    NSMutableDictionary *dictPar = [[NSMutableDictionary alloc]init];
    [dictPar setValue:@(self.selectPayModel.wayId) forKey:@"wayId"];
    [dictPar setValue:self.selectPayModel.name forKey:@"tranName"];
    [dictPar setValue:self.topupMoney forKey:@"price"];
    
    //    @weakify(self)
    //    [WebTools  postWithURL:@"/pay/paymentRequestByUser.json" params:dictPar success:^(BaseData *data) {
    //
    //        if (![data.status isEqualToString:@"1"]) {
    //            return ;
    //        }
    //        @strongify(self)
    //        NSString * pay_url = data.data[@"url"];
    //
    //        if([data.data[@"code"] isEqual:@(0)]){
    //            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:pay_url] entersReaderIfAvailable:YES];
    //            [self presentViewController:safari animated:YES completion:nil];
    //        }else if([data.data[@"code"] isEqual:@(1)]){
    //            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //            NSString *path = [docPath stringByAppendingPathComponent:@"webs.html"];
    //            NSError *error = NULL;
    //            BOOL success = [pay_url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //            if(success)
    //            {
    //                NSURL* url = [NSURL  fileURLWithPath:path];//创建URL
    //                CPTPayWebVCViewController * vc = [[CPTPayWebVCViewController alloc] init];
    //                vc.sfURL = url;
    //                vc.navView.hidden = YES;
    //                [self.navigationController pushViewController:vc animated:YES];
    //            }
    //
    //
    //        }else{
    //            UIImage * qec = [self createQRCodeWithUrlString:pay_url QRSize:250];
    //            __block UIImage *secondImage = [qec imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码支付" message:@"保存此二维码，打开APP扫码支付" preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@" " style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                @strongify(self)
    //                [self saveImage:qec];
    //
    //            }];
    //            [secondAction setValue:secondImage forKey:@"image"];
    //            [alert addAction:secondAction];
    //            [alert addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //                @strongify(self)
    //                [self saveImage:qec];
    //            }]];
    //            [self presentViewController:alert animated:true completion:^{
    //            }];
    //        }
    //    } failure:^(NSError *error) {
    //        [MBProgressHUD showError:@"充值失败,请重试"];
    //    } showHUD:YES];
    
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
- (UIImage*)createQRCodeWithUrlString:(NSString*)url QRSize:(CGFloat)qrSize
{
    // 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜默认属性，因为滤镜有可能保存了上一次的属性
    [filter setDefaults];
    // 将字符串转换成NSData
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 设置滤镜,传入Data，
    [filter setValue:data forKey:@"inputMessage"];
    // 生成二维码
    CIImage *qrCode = [filter outputImage];
    return [self adjustQRImageSize:qrCode QRSize:qrSize];
}
- (UIImage*)adjustQRImageSize:(CIImage*)ciImage QRSize:(CGFloat)qrSize
{
    // 获取CIImage图片的的Frame
    CGRect ciImageRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(qrSize / CGRectGetWidth(ciImageRect), qrSize / CGRectGetHeight(ciImageRect));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(ciImageRect) * scale;
    size_t height = CGRectGetHeight(ciImageRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:ciImageRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, ciImageRect, bitmapImage);
    
    // 保存Bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}
- (void)saveImage:(UIImage *)image
{
    
    //    //(1) 获取当前的授权状态
    //    PHAuthorizationStatus lastStatus = [PHPhotoLibrary authorizationStatus];
    //
    //    //(2) 请求授权
    //    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
    //        //回到主线程
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //            if(status == PHAuthorizationStatusDenied) //用户拒绝（可能是之前拒绝的，有可能是刚才在系统弹框中选择的拒绝）
    //            {
    //                if (lastStatus == PHAuthorizationStatusNotDetermined) {
    //                    //说明，用户之前没有做决定，在弹出授权框中，选择了拒绝
    //                    [MBProgressHUD showError:@"保存失败"];
    //                    return;
    //                }
    //                // 说明，之前用户选择拒绝过，现在又点击保存按钮，说明想要使用该功能，需要提示用户打开授权
    //                [MBProgressHUD showMessage:@"失败！请在系统设置中开启访问相册权限"];
    //
    //            }
    //            else if(status == PHAuthorizationStatusAuthorized) //用户允许
    //            {
    //                //保存图片---调用上面封装的方法
    //                [self saveImageToCustomAblumWithImage:image];
    //            }
    //            else if (status == PHAuthorizationStatusRestricted)
    //            {
    //                [MBProgressHUD showError:@"系统原因，无法访问相册"];
    //            }
    //        });
    //    }];
    
}
- (void)saveImageToCustomAblumWithImage:(UIImage *)image
{
    //    //1 将图片保存到系统的【相机胶卷】中---调用刚才的方法
    //    PHFetchResult<PHAsset *> *assets = [self syncSaveImageWithPhotos:image];
    //    if (assets == nil)
    //    {
    //        [MBProgressHUD showError:@"保存失败"];
    //        return;
    //    }
    //
    //    //2 拥有自定义相册（与 APP 同名，如果没有则创建）--调用刚才的方法
    //    PHAssetCollection *assetCollection = [self getAssetCollectionWithAppNameAndCreateIfNo];
    //    if (assetCollection == nil) {
    //        [MBProgressHUD showError:@"相册创建失败"];
    //        return;
    //    }
    //
    //    //3 将刚才保存到相机胶卷的图片添加到自定义相册中 --- 保存带自定义相册--属于增的操作，需要在PHPhotoLibrary的block中进行
    //    NSError *error = nil;
    //    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
    //        //--告诉系统，要操作哪个相册
    //        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
    //        //--添加图片到自定义相册--追加--就不能成为封面了
    //        //--[collectionChangeRequest addAssets:assets];
    //        //--插入图片到自定义相册--插入--可以成为封面
    //        [collectionChangeRequest insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    //    } error:&error];
    //
    //
    //    if (error) {
    //        [MBProgressHUD showError:@"保存失败"];
    //        return;
    //    }
    //    [MBProgressHUD showSuccess:@"保存成功"];
}
//- (PHFetchResult<PHAsset *> *)syncSaveImageWithPhotos:(UIImage *)image
//{
//    //--1 创建 ID 这个参数可以获取到图片保存后的 asset对象
//    __block NSString *createdAssetID = nil;
//
//    //--2 保存图片
//    NSError *error = nil;
//    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//        //----block 执行的时候还没有保存成功--获取占位图片的 id，通过 id 获取图片---同步
//        createdAssetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
//    } error:&error];
//
//    //--3 如果失败，则返回空
//    if (error) {
//        return nil;
//    }
//
//    //--4 成功后，返回对象
//    //获取保存到系统相册成功后的 asset 对象集合，并返回
//    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetID] options:nil];
//    return assets;
//}
//- (PHAssetCollection *)getAssetCollectionWithAppNameAndCreateIfNo
//{
//    //1 获取以 APP 的名称
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *title = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    //2 获取与 APP 同名的自定义相册
//    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *collection in collections) {
//        //遍历
//        if ([collection.localizedTitle isEqualToString:title]) {
//            //找到了同名的自定义相册--返回
//            return collection;
//        }
//    }
//    //说明没有找到，需要创建
//    NSError *error = nil;
//    __block NSString *createID = nil; //用来获取创建好的相册
//    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//        //发起了创建新相册的请求，并拿到ID，当前并没有创建成功，待创建成功后，通过 ID 来获取创建好的自定义相册
//        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
//        createID = request.placeholderForCreatedAssetCollection.localIdentifier;
//    } error:&error];
//    if (error) {
//        [MBProgressHUD showError:@"创建失败"];
//        return nil;
//    }else{
//        [MBProgressHUD showSuccess:@"创建成功"];
//        //通过 ID 获取创建完成的相册 -- 是一个数组
//        return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createID] options:nil].firstObject;
//    }
//}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
//{
//    NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//    MBLog(@"%@",dic);
//
//    NSString *pay_url = dic[@"data"];
//
//    if ([dic[@"status"] integerValue] != 1) {
//
//        return;
//    }
//
//    SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:pay_url] entersReaderIfAvailable:YES];
//
//    [self presentViewController:safari animated:YES completion:nil];
//}
//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
//{
//
//}
////信任服务器
//-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//    NSLog(@"didReceiveChallenge");
//
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//
//        // 从受保护空间内获取到身份质询的证书
//        NSURLCredential * credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//
//        //completionHandler
//        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//    }
//}



- (NSMutableArray *)quotaArray {
    if (!_quotaArray) {
        _quotaArray = [[NSMutableArray alloc] init];
    }
    return _quotaArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
