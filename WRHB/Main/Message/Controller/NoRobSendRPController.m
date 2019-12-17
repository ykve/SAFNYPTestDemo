//
//  NoRobSendRPController.m
//  Project
//
//  Created by AFan on 2019/3/2.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "NoRobSendRPController.h"
#import "EnvelopeMessage.h"
#import "EnvelopeNet.h"
#import "MessageItem.h"
#import "NSString+RegexCategory.h"
#import "SelectMineNumCell.h"
#import "SendRedPackedTextCell.h"
#import "SendRPNumTableViewCell.h"
#import "ChatsModel.h"


#define kTableViewMarginWidth 20

@interface NoRobSendRPController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *rowList;
@property (nonatomic ,strong) UILabel *moneyLabel;
@property (nonatomic ,strong) UIButton *submit;
@property (nonatomic ,assign) NSInteger textFieldObjectIndex;

@property (nonatomic ,strong) NSMutableArray *selectNumArray;
// 红包个数
@property (nonatomic ,strong) NSString *redpbNum;
// NO 禁抢   YES 不中
@property (nonatomic ,assign) BOOL isNotPlaying;
// 总金额
@property (nonatomic ,strong) NSString *totalMoneyString;


@end

@implementation NoRobSendRPController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isNotPlaying = NO;
    
    [self setupSubViews];
    [self initNotif];
    [self initData];
    
    self.selectNumArray = [[NSMutableArray alloc] init];
    
    [self.tableView registerClass:[SelectMineNumCell class] forCellReuseIdentifier:@"SelectMineNumCell"];
    
    [self.tableView registerClass:[SendRedPackedTextCell class] forCellReuseIdentifier:@"SendRedPackedTextCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark ----- Data
- (void)initData {
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    if (self.chatsModel.play_type == RedPacketType_BanRob) { // 禁抢
        
        _rowList =@[
                    @{@"title":@"",@"right":@""},
                    @{@"title":@"总 金 额",@"right":@"元",@"placeholder":[NSString stringWithFormat:@"%@-%@",minMoney,maxMoney]},
                    @{@"title":@"红包个数",@"right":@"包"},
                    @{@"title":@"雷   号",@"":@""}];
    }
    
    [self.tableView reloadData];
    
}


- (void)initNotif {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}



#pragma mark ----- subView
- (void)setupSubViews {
    
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"发红包";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [btn addTarget:self action:@selector(action_cancle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Height_NavBar, kSCREEN_WIDTH, kSCREEN_HEIGHT -Height_NavBar -kiPhoneX_Bottom_Height) style:UITableViewStylePlain];
    tableView.sectionFooterHeight = 4.0f;
    
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    //    tableView.scrollEnabled =NO;  // 设置tableview 不能滚动
    //    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    //    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    tableView.rowHeight = 60;
    //    _tableView.contentInset = UIEdgeInsetsMake(30, 0, 20, -50);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.000];
    //    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    fotView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = fotView;
    
//    UIImageView *backImageView = [[UIImageView alloc] init];
//    backImageView.image = [UIImage imageNamed:@"redp_send_bg"];
//    //    backImageView.contentMode = UIViewContentModeTop;
//    backImageView.userInteractionEnabled = YES;
////        backImageView.backgroundColor = [UIColor blueColor];
//    [fotView addSubview:backImageView];
//
//    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(fotView.mas_top);
//        make.left.equalTo(fotView.mas_left).offset(kTableViewMarginWidth);
//        make.right.equalTo(fotView.mas_right).offset(-kTableViewMarginWidth);
//        make.bottom.equalTo(fotView.mas_bottom);
//    }];
    
    UIButton *submitBtn = [UIButton new];
    submitBtn.layer.cornerRadius = 50/2;
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize2:18];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.backgroundColor = [UIColor clearColor];
    [submitBtn setTitle:@"发红包" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"cm_btn_press"] forState:UIControlStateHighlighted];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(action_sendRedpacked) forControlEvents:UIControlEventTouchUpInside];
    [fotView addSubview:submitBtn];
    [submitBtn delayEnable];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.centerY.equalTo(fotView.mas_centerY).offset(-10);
        make.left.equalTo(fotView.mas_left).offset(20);
        make.right.equalTo(fotView.mas_right).offset(-20);
    }];
}



#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 162;
    } else if (indexPath.row == 1) {
        return 65;
    } else if (indexPath.row == 2) {
        return 110;
    }
    return CD_Scal(10, 812);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    if (indexPath.row == 0) {
        SendRedPackedTextCell *cell = [SendRedPackedTextCell cellWithTableView:tableView reusableId:@"SendRedPackedTextCell"];
//            cell.backgroundColor = [UIColor blueColor];
        cell.deTextField.placeholder = [NSString stringWithFormat:@"%@-%@", minMoney, maxMoney];
        cell.titleLabel.text = @"总 金 额";
        cell.unitLabel.text = @"元";
        
        
        cell.object = self;
        return cell;
    } else if (indexPath.row == 1) {
        SendRPNumTableViewCell *cell = [SendRPNumTableViewCell cellWithTableView:tableView reusableId:@"SendRPNumTableViewCell"];
        // 分割字符串  切割
        NSArray *packetArray = [self.chatsModel.packet_range componentsSeparatedByString:@","];
//        cell.backgroundColor = [UIColor greenColor];
        cell.model = [[FunctionManager sharedInstance] orderBombArray: packetArray];
        cell.selectNumBlock = ^(NSArray *items) {
            NSIndexPath *indexPath = (NSIndexPath *)items.firstObject;
            self.isNotPlaying = NO;
            self.redpbNum = [[FunctionManager sharedInstance] orderBombArray: packetArray][indexPath.row];
            NSIndexPath *ip=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:ip,nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.selectNumArray removeAllObjects];
        };
        return cell;
    } else if (indexPath.row == 2) {
        SelectMineNumCell *cell = [SelectMineNumCell cellWithTableView:tableView reusableId:@"SelectMineNumCell"];
        NSArray *dataArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
//        cell.backgroundColor = [UIColor cyanColor];
        
        NSInteger minCount = 2;
        NSInteger maxCount = self.redpbNum.integerValue;
        
        if (self.redpbNum.integerValue == 10) {
            minCount = 3;
        }
        
        if (self.redpbNum.integerValue == 8 || self.redpbNum.integerValue == 9 || self.redpbNum.integerValue == 10) {
            maxCount = 7;
        }
        
        cell.maxNum = maxCount;
        
        cell.model = dataArray;
        cell.selectNumBlock = ^(NSArray *items) {
            
            [self.selectNumArray removeAllObjects];
            for (NSInteger index = 0; index < items.count; index++) {
                NSIndexPath *indexPath = (NSIndexPath *)items[index];
                NSString *num = dataArray[indexPath.row];
                [self.selectNumArray addObject:num];
            }
            NSLog(@"%@", self.selectNumArray);
        };
        cell.selectNoPlayingBlock = ^(BOOL isSelect) {
            self.isNotPlaying =  isSelect;
        };
        cell.selectMoreMaxBlock = ^(BOOL isMoreMax) {
            if (self.redpbNum != nil) {
                
                NSInteger maxCount = self.redpbNum.integerValue;
                if (self.redpbNum.integerValue == 8 || self.redpbNum.integerValue == 9 || self.redpbNum.integerValue == 10) {
                    maxCount = 7;
                }
                NSString *str = [NSString stringWithFormat:@"%@包多雷最多雷数不能超过%ld个", self.redpbNum,maxCount];
                [MBProgressHUD showTipMessageInWindow:str];
            } else {
                [MBProgressHUD showTipMessageInWindow:@"请先选择红包个数"];
            }
        };
        cell.mineCellSubmitBtnBlock = ^(void){
            [self action_sendRedpacked];
        };
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark action
- (void)action_cancle {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToBottom" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//#pragma mark action
//- (void)doneSend:(EnvelopeMessage *)message{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [ChatViewController sendCustomMessage:message];
//    });
//}


#pragma mark - 红包金额验证
- (BOOL)moneyCheck:(CGFloat)money {
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    NSInteger max = 0;
    NSInteger min = 0;
    max = [maxMoney integerValue];
    min = [minMoney integerValue];
    
    if ((money > max) | (money < min)) {
        NSString *str = [NSString stringWithFormat:@"红包发包范围:%@-%@", minMoney,maxMoney];
        [MBProgressHUD showErrorMessage:str];
        
        return NO;
    } else {
        return YES;
    }
}



#pragma mark - 发红包
- (void)action_sendRedpacked {
    
    NSString * regex        = @"(^[0-9]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (self.totalMoneyString.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入总金额"];
        return;
    }
    
    if (![self moneyCheck:self.totalMoneyString.floatValue]) {
        return;
    }
    
    if (self.redpbNum.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请选择包数"];
        return;
    }
    
    if(![pred evaluateWithObject:self.redpbNum]){
        [MBProgressHUD showTipMessageInWindow:@"红包个数请输入整数"];
        return;
    }
    
    if(![pred evaluateWithObject:self.totalMoneyString]){
        [MBProgressHUD showTipMessageInWindow:@"金额请输入整数"];
        return;
    }
    
    NSMutableString *mines = [NSMutableString string];
    if (self.chatsModel.play_type == RedPacketType_BanRob) {  // 禁抢
        if (self.selectNumArray.count == 0) {
            [MBProgressHUD showTipMessageInWindow:@"选择雷号"];
            return;
        }
        
        for (NSInteger index = 0; index < self.selectNumArray.count; index++) {
            if (index == self.selectNumArray.count -1) {
                [mines appendString:[NSString stringWithFormat:@"%@", self.selectNumArray[index]]];
            } else {
                [mines appendString:[NSString stringWithFormat:@"%@,", self.selectNumArray[index]]];
            }
        }
        NSInteger minCount = 2;
        NSInteger maxCount = self.redpbNum.integerValue;
        
        if (self.redpbNum.integerValue == 10) {
            minCount = 3;
        }
        
        if (self.redpbNum.integerValue == 8 || self.redpbNum.integerValue == 9 || self.redpbNum.integerValue == 10) {
            maxCount = 7;
        }
        
        if (self.selectNumArray.count < minCount) {
            NSString *strMess = [NSString stringWithFormat:@"%@包多雷玩法最少%ld雷", self.redpbNum, minCount];
            [MBProgressHUD showTipMessageInWindow:strMess];
            return;
        }
        if (self.selectNumArray.count > maxCount) {
            NSString *strMess = [NSString stringWithFormat:@"%@包多雷玩法最多%ld雷", self.redpbNum, maxCount];
            [MBProgressHUD showTipMessageInWindow:strMess];
            return;
        }
    }
    
    _submit.enabled = NO;
    [self redpackedRequest:self.totalMoneyString packetNum:self.redpbNum mines:mines];
    
}

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum mines:(NSString *)mines {
    
    
    
    NSDictionary *parameters = @{
                                 @"session":@(self.chatsModel.sessionId),   // 会话编号
                                 @"play_type":@(self.chatsModel.play_type),  // 玩法类型 1 单雷 2 禁抢玩法
                                 @"piece":packetNum,   // 份数
                                 @"mime":mines,   // 雷号 多雷号以逗号分割
                                 @"coin":@"GOLD",     // 红包资产类型 默认给GOLD
                                 @"number":money
                                 };
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"redpacket/gen/mime"];
    
    entity.needCache = NO;
    entity.parameters = parameters;
    
//    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
//        [MBProgressHUD hideHUD];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        
        
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showSuccessMessage:@"发送成功"];
            if ([strongSelf.delegate respondsToSelector:@selector(sendRedPacketMessageModel:)]) {
                YPMessage *message = [[YPMessage alloc] init];
                message.messageType = MessageType_RedPacket;
                
                EnvelopeMessage *model = [EnvelopeMessage mj_objectWithKeyValues:response[@"data"]];
                model.sender = [AppModel sharedInstance].user_info.userId;
                model.total = (int)packetNum.integerValue;
                model.mime = mines;
                model.remain = (int)packetNum.integerValue;
                
                message.redPacketInfo = model;
                [strongSelf.delegate sendRedPacketMessageModel:message];
            }
            [strongSelf action_cancle];
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
        strongSelf.submit.enabled = YES;
    } failureBlock:^(NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.submit.enabled = YES;
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}

#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    UITextField *textFieldObj = (UITextField *)notiObject.object;
    //    NSInteger mObjectInte = [textFieldObj.text integerValue];
    
    self.totalMoneyString = textFieldObj.text;
    NSLog(@"1");
}

- (BOOL)money:(CGFloat)money {
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    NSInteger max = 0;
    NSInteger min = 0;
    max = [maxMoney integerValue];
    min = [minMoney integerValue];
    
    if ((money > max) | (money < min)) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)count:(CGFloat)count {
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    NSInteger max = 0;
    NSInteger min = 0;
    max = [maxMoney integerValue];
    min = [minMoney integerValue];
    
    if ((count > max) | (count < min)) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)leiNum:(CGFloat)number {
    CGFloat max = 9;
    CGFloat min = 0;
    if ((number > max) | (number < min)) {
        return NO;
    } else {
        return YES;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

