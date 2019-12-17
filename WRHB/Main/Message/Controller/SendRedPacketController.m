//
//  EnvelopeViewController.m
//  Project
//
//  Created by AFan on 2019/11/8.
//  Copyright © 2018年 AFan. All rights reserved.
//

#import "SendRedPacketController.h"
#import "EnvelopeMessage.h"
#import "EnvelopeNet.h"
#import "MessageItem.h"
#import "NSString+RegexCategory.h"
#import "SendRPTextCell.h"
#import "ChatsModel.h"
#import "SendRedPacketModel.h"

#import "SendRedPackedTextCell.h"
#import "SendRedPackedDefaultTextCell.h"
#import "SendRedPackedNormalCellCell.h"

#define kTableViewMarginWidth 20

@interface SendRedPacketController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField *_textField[3];
    UILabel *_titLabel[3];
    UILabel *_unitLabel[3];
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIButton *submit;

@property (nonatomic ,strong) UILabel *promptLabel;

@property (nonatomic ,assign) NSInteger textFieldObjectIndex;
/// 总金额
@property (nonatomic, strong) NSString *totalMoneyString;
/// 红包个数
@property (nonatomic, strong) NSString *countString;
/// 雷数
@property (nonatomic, strong) NSString *mineString;
/// 个人 和 普通群的 红包 title
@property (nonatomic, strong) NSString *desTitle;
/// 锁定金额
@property (nonatomic ,strong) UILabel *smoneyLabel;

@end

@implementation SendRedPacketController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BaseColor;
    self.navigationItem.title = @"发红包";
    
    self.desTitle = @"恭喜发财，大吉大利";
    [self setupSubViews];
    [self initNotif];
    
    [self.tableView registerClass:[SendRedPackedDefaultTextCell class] forCellReuseIdentifier:@"SendRedPackedDefaultTextCell"];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textField[0] becomeFirstResponder];
}


- (void)initNotif{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}



#pragma mark ----- subView
- (void)setupSubViews{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize2:15];
    [btn addTarget:self action:@selector(action_cancle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    UIBarButtonItem *l = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = l;
    
    _tableView = [UITableView groupTable];
    [self.view addSubview:_tableView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    _tableView.backgroundView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _tableView.separatorColor = [UIColor colorWithHex:@"#F7F7F7"];
    _tableView.rowHeight = 60;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    UIView *fotView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
    fotView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = fotView;
    
    
    
     if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
         UILabel *nameLabel = [[UILabel alloc] init];
         nameLabel.text = @"发包锁定金额";
         nameLabel.font = [UIFont systemFontOfSize:14];
         nameLabel.textColor = [UIColor colorWithHex:@"#343434"];
         [fotView addSubview:nameLabel];
         
         [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(fotView.mas_top).offset(10);
             make.left.equalTo(fotView.mas_left).offset(28);
         }];
         
         UILabel *yLabel = [[UILabel alloc] init];
         yLabel.text = @"元";
         yLabel.font = [UIFont systemFontOfSize:14];
         yLabel.textColor = [UIColor colorWithHex:@"#343434"];
         yLabel.textAlignment = NSTextAlignmentRight;
         [fotView addSubview:yLabel];
         
         [yLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(fotView.mas_top).offset(5);
             make.right.equalTo(fotView.mas_right).offset(-28);
         }];
         
         UILabel *smoneyLabel = [[UILabel alloc] init];
         smoneyLabel.text = @"0";
         smoneyLabel.font = [UIFont boldSystemFontOfSize:16];
         smoneyLabel.textColor = [UIColor redColor];
         smoneyLabel.textAlignment = NSTextAlignmentRight;
         [fotView addSubview:smoneyLabel];
         _smoneyLabel = smoneyLabel;
         
         [smoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(yLabel.mas_centerY);
             make.right.equalTo(yLabel.mas_left).offset(-10);
         }];
         
    }
    
    
    
    
    
    
//    UIImageView *backImageView = [[UIImageView alloc] init];
//    backImageView.image = [UIImage imageNamed:@"redp_send_bg"];
//    //    backImageView.contentMode = UIViewContentModeTop;
//    backImageView.userInteractionEnabled = YES;
//    //    backImageView.backgroundColor = [UIColor blueColor];
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
    
    
//    CGFloat submitWidth = kSCREEN_WIDTH*0.40;
    //    CGFloat bottomHeight = kSCREEN_HEIGHT/2/2;
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.centerY.equalTo(fotView.mas_centerY).offset(-10);
        make.left.equalTo(fotView.mas_left).offset(20);
        make.right.equalTo(fotView.mas_right).offset(-20);
    }];
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.chatsModel.play_type == RedPacketType_SingleMine || self.chatsModel.play_type == RedPacketType_Normal) {
        return 3;
    } else if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble || self.chatsModel.play_type == RedPacketType_Private) {
        return 2;
    }
    
    return 2;
}

// 设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 162;
    } else {
        return 65;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    if (indexPath.row == 0) {
        SendRedPackedTextCell *cell = [SendRedPackedTextCell cellWithTableView:tableView reusableId:@"SendRedPackedTextCell"];
        //    cell.backgroundColor = [UIColor blueColor];
        if (self.chatsModel.play_type != RedPacketType_Private) {
            cell.deTextField.placeholder = [NSString stringWithFormat:@"%@-%@", minMoney, maxMoney];
            cell.titleLabel.text = @"总 金 额";
        } else {
            cell.titleLabel.text = @"总额";
            cell.deTextField.placeholder = @"0.00";
        }
        cell.deTextField.tag = 3000;
        cell.deTextField.userInteractionEnabled = YES;
        
        cell.unitLabel.text = @"元";
        
        cell.object = self;
        return cell;
    } else if (indexPath.row == 1) {
        
        if (self.chatsModel.play_type == RedPacketType_Private) {
            
            SendRedPackedNormalCellCell *cell = [SendRedPackedNormalCellCell cellWithTableView:tableView reusableId:@"SendRedPackedNormalCellCell"];
            cell.deTextField.tag = 3200;
            return cell;
        }
        // 分割字符串  切割
        NSArray *packetArray = [self.chatsModel.packet_range componentsSeparatedByString:@","];
        NSString *minCount = (NSString *)packetArray.firstObject;
        NSString *maxCount = (NSString *)packetArray.lastObject;
        
        SendRedPackedDefaultTextCell *cell = [SendRedPackedDefaultTextCell cellWithTableView:tableView reusableId:@"SendRedPackedDefaultTextCell"];
        //            cell.backgroundColor = [UIColor blueColor];
        
         if (self.chatsModel.play_type == RedPacketType_Normal) {
            cell.deTextField.placeholder = @"0";
             cell.deTextField.userInteractionEnabled = YES;
         } else {
             if (minCount.integerValue == maxCount.integerValue) {
                 cell.deTextField.placeholder = maxCount;
                 cell.deTextField.userInteractionEnabled = NO;
                 self.countString = maxCount;
             } else {
                 cell.deTextField.placeholder = [NSString stringWithFormat:@"%@-%@", minCount, maxCount];
                 cell.deTextField.userInteractionEnabled = YES;
             }
         }
        
        cell.deTextField.tag = 3001;
        
        if (self.chatsModel.play_type == RedPacketType_SingleMine) {
            cell.titleLabel.text = @"红包个数";
        } else if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
            cell.titleLabel.text = @"牛牛红包个数";
        } else {
            cell.titleLabel.text = @"红包个数";
        }
        
        cell.unitLabel.text = @"个";
        
        cell.object = self;
        return cell;
    } else if (indexPath.row == 2) {
        
        if (self.chatsModel.play_type == RedPacketType_Normal) {
            
            SendRedPackedNormalCellCell *cell = [SendRedPackedNormalCellCell cellWithTableView:tableView reusableId:@"SendRedPackedNormalCellCell"];
            cell.deTextField.tag = 3200;
            return cell;
        }
        SendRedPackedDefaultTextCell *cell = [SendRedPackedDefaultTextCell cellWithTableView:tableView reusableId:@"SendRedPackedDefaultTextCell"];
        //            cell.backgroundColor = [UIColor greenColor];
        cell.deTextField.placeholder = @"雷号范围0-9";
        cell.deTextField.tag = 3002;
        cell.deTextField.userInteractionEnabled = YES;
        cell.titleLabel.text = @"雷号";
        cell.unitLabel.text = @"";
        
        cell.object = self;
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BaseColor;
    return view;
}

#pragma mark action
- (void)action_cancle {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollToBottom" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 发红包
- (void)action_sendRedpacked {
    
    //    NSString *bombNum = [self.mineString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * regex        = @"(^[0-9]{0,15}$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (self.totalMoneyString.length == 0) {
        [MBProgressHUD showTipMessageInWindow:@"请输入总金额"];
        return;
    }
    
    if(![pred evaluateWithObject:self.totalMoneyString]){
        [MBProgressHUD showTipMessageInWindow:@"金额请输入整数"];
        return;
    }
    
    
    if (self.chatsModel.play_type != RedPacketType_Private) {   // 个人不检查
        if (![self moneyAction:[self.totalMoneyString floatValue]]) {
            return;
        }
        
        if (self.countString.length == 0) {
            [MBProgressHUD showTipMessageInWindow:@"请输入红包个数"];
            return;
        }
        
        if (self.chatsModel.play_type != RedPacketType_Normal) {
            if(![pred evaluateWithObject:self.countString]) {
                [MBProgressHUD showTipMessageInWindow:@"红包个数请输入整数"];
                return;
            }
            
            if (![self countAction:[self.countString integerValue]]) {
                return;
            }
            
            if (self.chatsModel.play_type == RedPacketType_SingleMine) {
                if (self.mineString.length == 0) {
                    [MBProgressHUD showTipMessageInWindow:@"请输入雷数"];
                    return;
                }
                if(![pred evaluateWithObject:self.mineString]){
                    [MBProgressHUD showTipMessageInWindow:@"雷数请输入整数"];
                    return;
                }
            }
        }
    } else {
        self.countString = @"1";
    }
    
    
    if (self.desTitle.length > 24) {
        [MBProgressHUD showTipMessageInWindow:@"红包标题过长"];
        return;
    }
    
    _submit.enabled = NO;
    [self redpackedRequest:self.totalMoneyString packetNum:self.countString mineNum:self.mineString];
    
}

- (void)redpackedRequest:(NSString *)money packetNum:(NSString *)packetNum mineNum:(NSString *)mineNum {
    
    NSDictionary *parameters = @{
                                 @"session":@(self.chatsModel.sessionId),   // 会话编号
                                 @"play_type":@(self.chatsModel.play_type),    // 玩法类型 1 单雷 2 禁抢玩法
                                 @"piece":packetNum,  // 份数
                                 @"mime":mineNum ? mineNum : @"",  // 雷号 多雷号以逗号分割
                                 @"coin":@"GOLD",     // 红包资产类型 默认给GOLD
                                 @"number":money,     // 红包金额
                                 @"title":self.desTitle ? self.desTitle : @""     // 红包标题
                                 };
    
    NSString *apiUrl = @"";
    if (self.chatsModel.play_type == RedPacketType_SingleMine) {
        apiUrl = @"redpacket/gen/mime";     // 带雷
    } else if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
        apiUrl = @"redpacket/gen/nn";       // 牛牛
    } else if (self.chatsModel.play_type == RedPacketType_Private) {
        apiUrl = @"redpacket/gen/personal";    // 个人
    } else if (self.chatsModel.play_type == RedPacketType_Normal) {
        apiUrl = @"redpacket/gen/normal";     // 普通群
    }
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,apiUrl];
    entity.needCache = NO;
    entity.parameters = parameters;
    
    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        if ([response objectForKey:@"status"] && [[response objectForKey:@"status"] integerValue] == 1) {
            NSLog(@"=================== 红包发送成功 ===================");
            
            if ([strongSelf.delegate respondsToSelector:@selector(sendRedPacketMessageModel:)]) {
                [MBProgressHUD showSuccessMessage:@"发送成功"];
                YPMessage *message = [[YPMessage alloc] init];
                message.messageType = MessageType_RedPacket;
                
                EnvelopeMessage *model = [EnvelopeMessage mj_objectWithKeyValues:response[@"data"]];
                model.sender = [AppModel sharedInstance].user_info.userId;
                model.mime = mineNum;
                model.total = (int)packetNum.integerValue;
                model.remain = (int)packetNum.integerValue;
                model.redpacketType = strongSelf.chatsModel.play_type;
                
                message.redPacketInfo = model;
                [strongSelf.delegate sendRedPacketMessageModel:message];
            }
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kSendRedPacketNotification object:nil];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == (1000+0)) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (textField.text.length >= 1) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
    }
    return YES;
}

#pragma mark -  输入字符判断
- (void)textFieldDidChangeValue:(NSNotification *)notiObject {
    
    UITextField *textFieldObj = (UITextField *)notiObject.object;
    
    if (textFieldObj.tag == 3000) {
        self.totalMoneyString = textFieldObj.text;
    } else if (textFieldObj.tag == 3001) {
        self.countString = textFieldObj.text;
    } else if (textFieldObj.tag == 3002) {
        self.mineString = textFieldObj.text;
    } else if (textFieldObj.tag == 3200) {
        self.desTitle = textFieldObj.text;
    }
    
    
   // 牛牛玩法 计算锁定金额
    if (self.chatsModel.play_type == RedPacketType_CowCowNoDouble || self.chatsModel.play_type == RedPacketType_CowCowDouble) {
        
        if (self.totalMoneyString.length > 0 && self.countString.length > 0) {
             NSInteger moneys = 0;
            if (self.chatsModel.play_type == RedPacketType_CowCowDouble) {
                moneys = [self.totalMoneyString integerValue] * ([self.countString integerValue]-1) * 3;
            } else {
                moneys = [self.totalMoneyString integerValue] * ([self.countString integerValue] -1);
            }
            self.smoneyLabel.text = [NSString stringWithFormat:@"%zd", moneys];
        }
        
    }
    
   
    
}

- (BOOL)moneyAction:(CGFloat)money {
    
    NSInteger max = 0;
    NSInteger min = 0;
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    if (self.chatsModel.play_type == RedPacketType_Fu) {
        min = [minMoney floatValue];
        max = [maxMoney floatValue];
    } else {
        min = [minMoney floatValue];
        max = [maxMoney floatValue];
    }
    
    NSString *promptString = @"";
    if ((money > max) | (money < min)) {
        if (self.chatsModel.play_type == RedPacketType_Fu) {
            //                self.promptLabel.text = [NSString stringWithFormat:@"红包发包范围:%@-%@", minMoney,maxMoney];
            promptString = [NSString stringWithFormat:@"红包发包范围:%@-%@", minMoney,maxMoney];
        } else {
            //                self.promptLabel.text = [NSString stringWithFormat:@"红包发包范围:%@-%@", minMoney,maxMoney];
            promptString = [NSString stringWithFormat:@"红包发包范围:%@-%@", minMoney,maxMoney];
        }
        [MBProgressHUD showTipMessageInWindow:promptString];
        return NO;
    } else {
        //        self.promptString = @"";
        return YES;
    }
}

- (BOOL)countAction:(NSInteger)count {
    
    // 分割字符串  切割
    NSArray *limitArray = [self.chatsModel.number_limit componentsSeparatedByString:@","];
    NSString *minMoney = (NSString *)limitArray.firstObject;
    NSString *maxMoney = (NSString *)limitArray.lastObject;
    
    // 分割字符串  切割
    NSArray *packetArray = [self.chatsModel.packet_range componentsSeparatedByString:@","];
    NSString *minCount = (NSString *)packetArray.firstObject;
    NSString *maxCount = (NSString *)packetArray.lastObject;
    
    NSInteger max = 0;
    NSInteger min = 0;
    if (self.chatsModel.play_type == RedPacketType_Fu) {
        max = [maxCount integerValue];
        min = [minCount integerValue];
    } else {
        max = [maxCount integerValue];
        min = [minCount integerValue];
    }
    
    NSString *promptString = @"";
    if ((count > max) | (count < min)) {
        
        if (self.chatsModel.play_type == RedPacketType_Fu) {
            promptString = [NSString stringWithFormat:@"红包个数范围:%@-%@", minCount,maxCount];
        } else {
            promptString = [NSString stringWithFormat:@"红包个数范围:%@-%@", minCount,maxCount];
        }
        [MBProgressHUD showTipMessageInWindow:promptString];
        return NO;
    } else {
        //        self.promptLabel.text = @"";
        return YES;
    }
}

- (BOOL)leiNum:(CGFloat)number {
    CGFloat max = 9;
    CGFloat min = 0;
    if ((number > max) | (number < min)) {
        if (self.textFieldObjectIndex == 1000) {
            self.promptLabel.text = @"雷数范围:0-9";
        }
        return NO;
    } else {
        if (self.textFieldObjectIndex == 2) {
            self.promptLabel.text = @"";
        }
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
