//
//  YPIMSessionViewController.m
//  WRHB
//
//  Created by AFan on 2019/4/1.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "IMSessionMessageController.h"

#import "SSAddImage.h"
#import "AFChatBaseCell.h"
#import "AFSystemBaseCell.h"
#import "YPChatLocationController.h"
#import "SSImageGroupView.h"
#import "YPChatMapController.h"

#import "YPChatDatas.h"

#import "AFSocketManager.h"
#import "WHC_ModelSqlite.h"
#import "NSTimer+SSAdd.h"

#import "ChatNotifiCell.h"
#import "PushMessageNumModel.h"
#import "MessageSingle.h"
#import "JJPhotoManeger.h"

#import "Msg.pbobjc.h"
#import "Common.pbobjc.h"
#import "EnvelopeMessage.h"
#import "CountDown.h"
#import "AFRedPacketCell.h"
#import "UploadFileModel.h"


#import "TZImagePickerController.h"
#import "TZImageUploadOperation.h"
#import "UIImage+Wechat.h"
#import "YQImageCompressTool.h"

#import "ImageModel.h"
#import "AudioModel.h"
#import "VideoModel.h"
#import "VideoService.h"
#import "YQImageTool.h"
#import "ChatsModel.h"
#import "LGSoundRecorder.h"
#import "XFCameraController.h"
#import "ZJCirclePieProgressView.h"



@interface IMSessionMessageController ()<YPChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,AFChatBaseCellDelegate, AFChatManagerDelegate,AFSystemBaseCellDelegate, JJPhotoDelegate, UIImagePickerControllerDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}

//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;

//访问相册 摄像头
@property (nonatomic, strong)SSAddImage *mAddImage;
@property (nonatomic ,assign) NSInteger page;
// 是否最底部
@property (nonatomic, assign) BOOL isTableViewBottom;
// 未查看消息数量
@property (nonatomic, assign) NSInteger notViewedMessagesCount;
//
@property (nonatomic, strong) UIButton *bottomMessageBtn;
@property (nonatomic, strong) UILabel *bottomMessageLabel;
@property (nonatomic, strong) UIView *topMessageView;
@property (nonatomic, strong) UILabel *topMessageLabel;
// top 未读消息条数
@property (nonatomic, assign) NSInteger unreadMessageNum;
/// 上面的未读消息数
@property (nonatomic, assign) NSInteger topNumIndex;
// 本地是否还有数据
@property (nonatomic, assign) BOOL isLocalData;

// ****** 相册相关 ******
@property (nonatomic, strong) NSArray *arrDataSources;
@property (nonatomic, strong) NSMutableArray *imagesSizeArr;

@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation IMSessionMessageController

//static IMSessionMessageController *_chatVC;

/*!
 初始化会话页面
 
 @param chatSessionType 会话类型
 @param targetId         目标会话ID
 
 @return 会话页面对象
 */
- (id)initWithConversationType:(ChatSessionType)chatSessionType targetId:(NSInteger)targetId {
    if(self = [super init]) {
        _chatSessionType = chatSessionType;
        _sessionId = targetId;
        _dataSource = [NSMutableArray array];
        _page = 1;
        _notViewedMessagesCount = 0;
        
        self.delegate = self;
    }
    //    _chatVC = self;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([IMMessageManager sharedInstance].delegate != self) {
        [IMMessageManager sharedInstance].delegate = self;
    }
    
}

//+ (IMSessionMessageController *)currentChat {
//    return _chatVC;
//}


//不采用系统的旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationItem.title = _titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [AppModel sharedInstance].chatSessionType = self.chatSessionType;
    self.reloadFinish = YES;
    // 初始化数据
    self.unreadMessageNum = 0;
    self.isLocalData = YES;
    self.imagesSizeArr = [[NSMutableArray alloc] init];
    
    _sessionInputView = [YPChatKeyBoardInputView new];
    _sessionInputView.delegate = self;
    [self.view addSubview:_sessionInputView];
    
    _backViewH = YPSCREEN_Height-YPChatKeyBoardInputViewH-Height_NavBar-kiPhoneX_Bottom_Height;
    
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, Height_NavBar, YPSCREEN_Width, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];
    
    
    [self initTableView];
    [self unreadMessageView];
    [self getUnreadMessageAction];
    
    [self scrollToBottom];
    
    
    // 通知 监听消息列表是否需要刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRefreshChatContentData:)
                                                 name:kRefreshChatContentNotification
                                               object:nil];
    
    self.countDown = [[CountDown alloc] init];
    __weak __typeof(self)weakSelf = self;
    ///每秒回调一次
    [self.countDown countDownWithPER_SECBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //        NSLog(@"每秒回调一次");
        [strongSelf updateTimeInVisibleCells];
    }];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<YPMessage *> *arr = nil;
        [self sendReadedArray:arr isAll:YES];
    });
}

- (void)setSessionId:(NSInteger)sessionId {
    _sessionId = sessionId;
    
    if (sessionId == 0) {
        return;
    }
    [self delayGetHistoricalData];
    //    [self performSelector:@selector(delayGetHistoricalData) withObject:nil afterDelay:2];
    
}

- (void)delayGetHistoricalData {
    NSInteger num = kMessagePageNumber -(self.unreadMessageNum % kMessagePageNumber);
    NSInteger numCount = self.unreadMessageNum + num;
    [self getHistoricalData:numCount > kMessagePageNumber ? numCount : kMessagePageNumber];
    NSInteger topNumIndex = num;
    _topNumIndex = topNumIndex;
}

#pragma mark - 已读设置 相关方法
/**
 发送已读
 @param unreadArray 未读数组
 @param isAll 是否这个会话全部设置已读
 */
- (void)sendReadedArray:(NSArray<YPMessage *> *)unreadArray isAll:(BOOL)isAll {
    
    [[IMMessageManager sharedInstance] sendReadedCmdSessionId:self.sessionId readArray:unreadArray isAll:isAll];
}

// 获取未读消息 发送已读
-(void)getUnreadMessageSetRead {
    
    NSMutableArray *unreadArray = [NSMutableArray array];
    NSArray  *cells = self.tableView.visibleCells; //取出屏幕可见ceLl
    for (id baseCell in cells) {
        
        AFRedPacketCell *cell =  (AFRedPacketCell *)baseCell;
        ChatMessagelLayout *model = self.dataSource[cell.tag];
        
        if (model.message.messageFrom == MessageDirection_RECEIVE && !model.message.isRemoteRead) {
            [unreadArray addObject:model.message];
            model.message.isRemoteRead = YES;
        }
    }
    if (unreadArray.count > 0) {
        //        [self sendReadedArray:unreadArray isAll:NO];
        
        self.notViewedMessagesCount = self.notViewedMessagesCount - unreadArray.count;
        
        if (self.notViewedMessagesCount <= 0) {
            self.notViewedMessagesCount = 0;
            self.bottomMessageBtn.hidden = YES;
        }
        NSString *mgsStr = [NSString stringWithFormat:@"%zd",self.notViewedMessagesCount];
        self.bottomMessageLabel.text = mgsStr;
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dic = @{@"messageArray":unreadArray};
            [self delaySendReadedDict:dic];
        });
    }
}

- (void)delaySendReadedDict:(NSDictionary *)dict {
    NSArray *array = dict[@"messageArray"];
    [self sendReadedArray:array isAll:NO];
}

/*!
 服务器返回的用户已读信息通知
 */
- (void)willSetReadMessages:(YPMessage *)message {
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        ChatMessagelLayout *tableViewLayout = self.dataSource[index];
        if (message.messageId == tableViewLayout.message.messageId) {
            tableViewLayout.message.isRemoteRead = YES;
            NSLog(@" ********* 已读 ********* ");
            break;
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
}


#pragma mark - 更新未读消息
/**
 更新未读消息
 */
- (void)updateUnreadMessage {
    
    PushMessageNumModel *curModel = [[PushMessageNumModel alloc] init];
    if (self.chatSessionType == ChatSessionType_CustomerService) {
        curModel.sessionId = kCustomerServiceID;
    } else {
        curModel.sessionId = self.sessionId;
    }
    curModel.number = 0;
    //    curModel.lastMessage = @"暂无未读消息";
    curModel.messageCountLeft = 0;
    
    [[YPIMManager sharedInstance] updateMessageNum:curModel left:0];
}

/**
 获取未读消息数量
 */
- (void)getUnreadMessageAction {
    
    NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",(long)self.sessionId,(long)[AppModel sharedInstance].user_info.userId];
    PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
    
    self.unreadMessageNum = pmModel.number;
    if (pmModel.number  > kMessagePageNumber) {
        //        self.topMessageView.hidden = NO;
        NSString *mgsStr = (pmModel.number - self.dataSource.count) > 99 ? @"99+条新消息" : [NSString stringWithFormat:@"%zd 条新消息",pmModel.number - self.dataSource.count];
        self.topMessageLabel.text = mgsStr;
    } else {
        //        self.topMessageView.hidden = YES;
        self.topMessageLabel.text = 0;
    }
}





-(void)updateTimeInVisibleCells {
    NSArray  *cells = self.tableView.visibleCells; //取出屏幕可见ceLl
    for (id baseCell in cells) {
        
        if ([baseCell isKindOfClass:[AFRedPacketCell class]]) {
            AFRedPacketCell *cell =  (AFRedPacketCell *)baseCell;
            ChatMessagelLayout *model = self.dataSource[cell.tag];
            
            if (model.message.messageType == MessageType_RedPacket) {
                if ((model.message.redPacketInfo.cellStatus == RedPacketCellStatus_Invalid || model.message.redPacketInfo.cellStatus == RedPacketCellStatus_Normal) && (model.message.redPacketInfo.redpacketType == RedPacketType_SingleMine || model.message.redPacketInfo.redpacketType == RedPacketType_BanRob || model.message.redPacketInfo.redpacketType == RedPacketType_CowCowNoDouble || model.message.redPacketInfo.redpacketType == RedPacketType_CowCowDouble)) {
                    
                    NSInteger time = [self getNowTimeWithCreate:(NSInteger)model.message.redPacketInfo.create expire:(NSInteger)model.message.redPacketInfo.expire];
                    if (time <= 0) {
                        if ([cell.countDownOrDescLabel.text containsString:@"剩:"]) {
                            model.message.redPacketInfo.expireMrak = @"1";
                            cell.countDownOrDescLabel.text = @"";
                            [cell reloadRedPackTimeOver:model];
                        }
                        
                    } else {
                        cell.countDownOrDescLabel.text = [NSString stringWithFormat:@"剩:%zds", time];
                    }
                }
            }
        }
    }
}

-(NSDate *)dateWithLongLong:(long long)longlongValue{
    NSNumber *time = [NSNumber numberWithLongLong:longlongValue];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

-(NSInteger)getNowTimeWithCreate:(NSInteger)create expire:(NSInteger)expire {
    
    NSTimeInterval starTimeStamp = [[NSDate date] timeIntervalSince1970];
    NSDate *startDate  = [self dateWithLongLong:starTimeStamp];
    
    NSInteger finishTime = create + expire;
    NSDate *finishDate = [self dateWithLongLong:finishTime];
    
    NSInteger timeInterval =[finishDate timeIntervalSinceDate:startDate];  //倒计时时间
    
    return timeInterval;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sessionInputView endEditing:YES];
    
    // 拦截返回事件
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //        _chatVC = nil;
    }
    
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"base");
}



#pragma mark - 获取历史消息
- (void)getHistoricalData:(NSInteger)count {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSString *pageStr = [NSString stringWithFormat:@"%zd,%zd", (strongSelf.page -1)*count,count];
        NSString *whereStr = [NSString stringWithFormat:@"userId = '%ld' and sessionId = '%ld' and isDeleted = 0",[AppModel sharedInstance].user_info.userId, strongSelf.sessionId];
        NSArray *messageArray = [WHC_ModelSqlite query:[YPMessage class] where:whereStr order:@"by timestamp desc,create_time desc" limit:pageStr];
        
        if (messageArray.count == 0) {
            [strongSelf->_tableView.mj_header endRefreshing];
            return;
        }
        if (count != messageArray.count) {
            strongSelf.isLocalData = NO;
        }
        
        [strongSelf controllerLoadData:messageArray];
        
    });
}

- (void)controllerLoadData:(NSArray *)messageArray {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSInteger indexCount = 0;
        for (NSInteger index = 0; index < messageArray.count; index++) {
            YPMessage *message = (YPMessage *)messageArray[index];
            
            if (strongSelf.dataSource.count == 0) {
                //                indexCount++;
                [strongSelf.dataSource insertObject:[YPChatDatas receiveMessage:message] atIndex:0];
            } else {
                // 去重复
                BOOL isRepeat = NO;
                for (ChatMessagelLayout *layout in strongSelf.dataSource) {
                    if(message.messageId == layout.message.messageId) {
                        isRepeat = YES;
                        break;
                    }
                }
                if (!isRepeat) {
                    indexCount++;
                    [strongSelf.dataSource insertObject:[YPChatDatas receiveMessage:message] atIndex:0];
                }
            }
        }
        
        if (strongSelf.page > 0 && strongSelf.dataSource.count > 0) {
            [strongSelf->_tableView.mj_header endRefreshing];
            
            [strongSelf->_tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexCount inSection:0];
            [strongSelf->_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else{
            [strongSelf->_tableView.mj_header endRefreshing];
        }
    });
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = YPChatCellColor;
    tableView.backgroundView.backgroundColor = YPChatCellColor;
    [_mBackView addSubview:tableView];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    
    // AFan这个会一直持有控制器 原因是使用了 self
    __weak __typeof(self)weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.page++;
        
        NSString *queryId = [NSString stringWithFormat:@"%ld_%ld",strongSelf.sessionId,[AppModel sharedInstance].user_info.userId];
        PushMessageNumModel *pmModel = (PushMessageNumModel *)[MessageSingle sharedInstance].unreadAllMessagesDict[queryId];
        if (pmModel.messageCountLeft > 0 || !strongSelf.isLocalData) {
            pmModel.messageCountLeft =  pmModel.messageCountLeft > 50 ? pmModel.messageCountLeft -50 : 0;
            [strongSelf->_tableView.mj_header endRefreshing];
            strongSelf->_tableView.mj_header.hidden = YES;
        } else {
            [strongSelf getHistoricalData:kMessagePageNumber];
        }
        
    }];
    
    [tableView registerClass:NSClassFromString(@"YPChatTextCell") forCellReuseIdentifier:YPChatTextCellId];
    [tableView registerClass:NSClassFromString(@"YPChatImageCell") forCellReuseIdentifier:YPChatImageCellId];
    [tableView registerClass:NSClassFromString(@"YPChatVoiceCell") forCellReuseIdentifier:YPChatVoiceCellId];
    [tableView registerClass:NSClassFromString(@"YPChatMapCell") forCellReuseIdentifier:YPChatMapCellId];
    [tableView registerClass:NSClassFromString(@"YPChatVideoCell") forCellReuseIdentifier:YPChatVideoCellId];
    [tableView registerClass:NSClassFromString(@"AFRedPacketCell") forCellReuseIdentifier:AFRedPacketCellId];
    [tableView registerClass:NSClassFromString(@"AFTransferCell") forCellReuseIdentifier:AFTransferCellId];
    [tableView registerClass:NSClassFromString(@"CowCowVSMessageCell") forCellReuseIdentifier:CowCowVSMessageCellId];
    [tableView registerClass:NSClassFromString(@"ChatNotifiCell") forCellReuseIdentifier:NotificationMessageCellId];
}




#pragma mark - 未读消息 和 未读新消息视图
- (void)unreadMessageView {
    
    /*  top 视图
     UIView *topMessageView = [[UIView alloc] init];
     topMessageView.backgroundColor = [UIColor whiteColor];
     topMessageView.layer.cornerRadius = 35/2;
     topMessageView.layer.borderWidth = 0.5;
     topMessageView.layer.borderColor = [UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1.000].CGColor;
     topMessageView.hidden = YES;
     
     UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewtapClick:)];
     [topMessageView addGestureRecognizer:gesture];
     
     [self.view addSubview:topMessageView];
     _topMessageView = topMessageView;
     
     [topMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.right.equalTo(self.tableView.mas_right).offset(35/2);
     make.top.equalTo(self.tableView.mas_top).offset(18);
     make.size.mas_equalTo(CGSizeMake(150, 35));
     }];
     
     UIImageView *backImageView = [[UIImageView alloc] init];
     backImageView.image = [UIImage imageNamed:@"mess_arrow"];
     [topMessageView addSubview:backImageView];
     
     [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.equalTo(topMessageView.mas_centerY);
     make.left.equalTo(topMessageView.left).offset(12);
     make.size.mas_equalTo(CGSizeMake(9.0, 8.5));
     }];
     
     UILabel *topMessageLabel = [[UILabel alloc] init];
     //    topMessageLabel.text = @"0 条新消息";
     topMessageLabel.font = [UIFont systemFontOfSize:14];
     topMessageLabel.textColor = [UIColor colorWithRed:0.059 green:0.608 blue:1.000 alpha:1.000];
     topMessageLabel.textAlignment = NSTextAlignmentCenter;
     [topMessageView addSubview:topMessageLabel];
     _topMessageLabel = topMessageLabel;
     
     [topMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(backImageView.mas_right).offset(15);
     make.centerY.equalTo(topMessageView.mas_centerY);
     }];
     
     */
    
    // ******************************
    
    UIButton *bottomMessageBtn = [[UIButton alloc] init];
    [bottomMessageBtn addTarget:self action:@selector(onNewMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessageBtn setBackgroundImage:[UIImage imageNamed:@"mess_bubble"] forState:UIControlStateNormal];
    [self.view addSubview:bottomMessageBtn];
    _bottomMessageBtn = bottomMessageBtn;
    bottomMessageBtn.hidden = YES;
    
    [bottomMessageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tableView.mas_right).offset(-10);
        make.bottom.equalTo(self.mBackView.mas_bottom).offset(-15);
        make.size.mas_equalTo(@(37.5));
    }];
    
    UILabel *bottomMessageLabel = [[UILabel alloc] init];
    //    bottomMessageLabel.text = @"1";
    bottomMessageLabel.font = [UIFont systemFontOfSize:14];
    bottomMessageLabel.textColor = [UIColor whiteColor];
    bottomMessageLabel.textAlignment = NSTextAlignmentCenter;
    [bottomMessageBtn addSubview:bottomMessageLabel];
    _bottomMessageLabel = bottomMessageLabel;
    
    [bottomMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomMessageBtn.mas_centerX);
        make.centerY.equalTo(bottomMessageBtn.mas_centerY).offset(-3);
    }];
}

- (void)onNewMessageBtnClick {
    [self scrollToBottom];
    //    [self hidBottomUnreadMessageView];
}

- (void)hidBottomUnreadMessageView {
    self.notViewedMessagesCount = 0;
    self.bottomMessageLabel.text = @"";
    self.bottomMessageBtn.hidden = YES;
}

#pragma mark - top未读消息点击事件
-(void)topViewtapClick:(UITapGestureRecognizer *)sender {
    
    if (self.dataSource.count > 0) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.topNumIndex >= 0 ? self.topNumIndex : 0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    self.topMessageView.hidden = YES;
    self.topMessageLabel.text = 0;
}

//处理监听触发事件
-(void)onRefreshChatContentData:(NSNotificationCenter *)notification {
    [self.dataSource removeAllObjects];
    [self->_tableView reloadData];
}



#pragma mark -  即将接收消息
- (YPMessage *)willAppendAndDisplayMessage:(YPMessage *)message {
    ///历史消息和推送历史消息去重复
    if (self.dataSource.count < 40) {
        if (self.dataSource.count > 0) {
            // 去重复
            BOOL isRepeat = NO;
            for (ChatMessagelLayout *layout in self.dataSource) {
                if(message.messageId == layout.message.messageId) {
                    isRepeat = YES;
                    break;
                }
            }
            if (isRepeat) {
                __weak __typeof(self)weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    // UI更新代码
                    [strongSelf delayReload];
                });
                return message;
            }
        }
    }
    // 更新数据源
    [self.dataSource addObject:[YPChatDatas receiveMessage:message]];
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // UI更新代码
        [strongSelf delayReload];
    });
    
    //    if(self.reloadFinish){
    //        self.reloadFinish = NO;
    //        [self performSelector:@selector(delayReload) withObject:nil afterDelay:0.2];
    //    }
    return message;
}



/*!
 即将在会话页面插入系统消息的回调
 
 @param message 消息实体
 @return        修改后的消息实体
 
 @discussion 此回调在消息准备插入数据源的时候会回调，您可以在此回调中对消息进行过滤和修改操作。
 如果此回调的返回值不为nil，SDK会将返回消息实体对应的消息Cell数据模型插入数据源，并在会话页面中显示。
 */
- (YPMessage *)willAppendAndDisplaySystemMessage:(YPMessage *)message redpId:(NSString *)redpId {
    ///历史消息和推送历史消息去重复
    if (self.dataSource.count < 40) {
        if (self.dataSource.count > 0) {
            // 去重复
            BOOL isRepeat = NO;
            for (ChatMessagelLayout *layout in self.dataSource) {
                if(message.messageId == layout.message.messageId) {
                    isRepeat = YES;
                    break;
                }
            }
            if (isRepeat) {
                return message;
            }
        }
    }
    
    // 获取红包的下标  把数据插入到红包的后面
    NSInteger insertIndex = 0;
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        ChatMessagelLayout *layout = (ChatMessagelLayout *)self.dataSource[index];
        
        if([redpId isEqualToString:layout.message.redPacketInfo.redp_id]) {
            insertIndex = index;
            break;
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        // 更新数据源
        [self.dataSource insertObject:[YPChatDatas receiveMessage:message] atIndex:insertIndex+1];
        // UI更新代码
        [strongSelf delayReload];
    });
    
    return message;
}

-(void)delayReload{
    ChatMessagelLayout *message = [self.dataSource lastObject];
    [self.tableView reloadData];
    if (message.message.messageSendId == [AppModel sharedInstance].user_info.userId || self.isTableViewBottom) {
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.05];
    }
    
    // 未读新消息
    if (!self.isTableViewBottom) {
        self.notViewedMessagesCount++;
        NSString *mgsStr = self.notViewedMessagesCount > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",self.notViewedMessagesCount];
        self.bottomMessageLabel.text = mgsStr;
        self.bottomMessageBtn.hidden = NO;
    } else {
        [self hidBottomUnreadMessageView];
    }
    self.reloadFinish = YES;
}






#pragma mark - 即将在会话页面确认自己发送的消息的回调
/**
 即将在会话页面确认自己发送的消息的回调
 
 @param reqId 消息ID
 @param sessionId 会话ID
 @param state 消息投递状态
 */
- (void)willConfirmSendMessageReqId:(NSString *)reqId sessionId:(NSInteger)sessionId messageId:(NSInteger)messageId state:(MessageDeliveryState)state {
    
    for (NSInteger index = 0; index < self.dataSource.count; index++) {
        ChatMessagelLayout *tableViewLayout = self.dataSource[index];
        if ([reqId doubleValue] == tableViewLayout.message.messageId) {
            if (state == MessageDeliveryState_Successful) {
                tableViewLayout.message.messageId = messageId;
            }
            tableViewLayout.message.isReceivedMsg = YES;
            tableViewLayout.message.deliveryState = state;
            NSLog(@"✅ ********* 消息确认发送成功 ********* ✅");
            break;
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
    
}



#pragma mark - 撤回消息 删除消息

/**
 开始撤回消息
 
 @param model 消息模型
 */
-(void)onWithdrawMessageCell:(YPMessage *)model {
    
    [[IMMessageManager sharedInstance] sendWithdrawMessage:model];
    
}

/**
 即将撤回消息（服务器已经发送回来撤回命令 客服端还未处理时）
 
 @param messageId  消息ID
 */
- (void)willRecallMessage:(NSInteger)messageId {
    if (messageId > 0) {
        [self onDeleteLocalMessage:messageId];
        
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        });
    }
}



// 删除消息
-(void)onDeleteMessageCell:(YPMessage *)model indexPath:(NSIndexPath *)indexPath {
    if (model.messageId > 0) {
        [self onDeleteLocalMessage:model.messageId];
        [self.tableView reloadData];
    }
}

/**
 删除本地消息方法
 
 @param messageId 消息ID
 */
- (void)onDeleteLocalMessage:(NSInteger)messageId {
    for (ChatMessagelLayout *modelLayout in self.dataSource) {
        if (messageId == modelLayout.message.messageId) {
            [self.dataSource removeObject:modelLayout];
            [self deleteMessageUpdateSql:messageId];
            break;
        }
    }
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    });
}

- (void)deleteMessageUpdateSql:(NSInteger)messageId {
    NSString *whereStr = [NSString stringWithFormat:@"userId = %ld and messageId='%ld'",[AppModel sharedInstance].user_info.userId, messageId];
    YPMessage *ypMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    ypMessage.isDeleted = YES;
    if (ypMessage) {
        [WHC_ModelSqlite update:ypMessage where:whereStr];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    
    if ((bottomOffset-150) <= height) {
        //在最底部
        self.isTableViewBottom = YES;
        [self hidBottomUnreadMessageView];
    } else {
        self.isTableViewBottom = NO;
    }
    
    [self getUnreadMessageSetRead];
}




#pragma mark - 发送文本消息代理
//发送文本 列表滚动至底部
-(void)onChatKeyBoardInputViewSendText:(NSString *)text {
    YPMessage *model = [[YPMessage alloc] init];
    model.userId = [AppModel sharedInstance].user_info.userId;
    model.messageType = MessageType_Text;
    model.sessionId = self.sessionId;
    model.messageId = [FunctionManager getNowTime];
    model.uniqeid = StringUniquId(model.userId, model.sessionId, model.messageId);
    
    model.deliveryState = MessageDeliveryState_Delivering;
    model.messageFrom = MessageDirection_SEND;
    model.chatSessionType = self.chatSessionType;
    
    model.messageSendId = [AppModel sharedInstance].user_info.userId;
    model.timestamp = model.messageId;
    model.create_time = [NSDate date];
    model.isReceivedMsg = NO;
    
    model.text = text;
    
    [self sendMessageAction:model];
}

#pragma mark - 发送语音代理
// 发送语音
-(void)YPChatKeyBoardInputViewBtnClick:(YPChatKeyBoardInputView *)view voicePath:(NSString *)voicePath sendVoice:(NSData *)voice time:(NSInteger)second {
    
    //    NSDictionary *dic = @{@"voice":voice,
    //                          @"second":@(second)};
    //    [self sendMessage:dic messageType:MessageType_Voice];
    
    AudioModel *audioModel = [[AudioModel alloc] init];
    audioModel.name = [NSString stringWithFormat:@"%.0f", [FunctionManager getNowTime]];
    audioModel.size = (int32_t)voice.length;
    audioModel.id_p = [NSString stringWithFormat:@"%.0f", [FunctionManager getNowTime]];
    audioModel.time = (int32_t)second;
    
    
    //    audioModel.voiceData = voice;
    audioModel.voiceLocalPath = voicePath;
    
    YPMessage *mMessage = [[YPMessage alloc] init];
    mMessage.userId = [AppModel sharedInstance].user_info.userId;
    mMessage.messageType = MessageType_Voice;
    mMessage.sessionId = self.sessionId;
    mMessage.messageId = [FunctionManager getNowTime];
    mMessage.uniqeid = StringUniquId(mMessage.userId, mMessage.sessionId, mMessage.messageId);
    mMessage.deliveryState = MessageDeliveryState_Delivering;
    mMessage.messageFrom = MessageDirection_SEND;
    mMessage.chatSessionType = self.chatSessionType;
    
    
    mMessage.messageSendId = [AppModel sharedInstance].user_info.userId;
    mMessage.timestamp = mMessage.messageId;
    mMessage.create_time = [NSDate date];
    mMessage.isReceivedMsg = NO;
    
    mMessage.audioModel = audioModel;
    
    
    [self sendMessageToLocal:mMessage];
    [self getUploadURL:mMessage];
}
#pragma mark -  发送视频
// 发送视频
-(void)sendVideoMessage:(NSURL *)videoPath videoTimeLength:(CGFloat)videoTimeLength thumbnailImage:(UIImage *)thumbnailImage{
    VideoModel *videoModel = [[VideoModel alloc] init];
    videoModel.name = @"aaa12345";
    videoModel.size = 1;
    videoModel.id_p = [NSString stringWithFormat:@"%.0f", [FunctionManager getNowTime]];
    
    //    NSURL *url = videoPath;
    //    videoModel.time = [VideoService getVideoDuration:url];
    videoModel.time = videoTimeLength;
    //    UIImage *image = [VideoService getImage:url];
    NSData *vimageData = [YQImageCompressTool CompressToDataWithImage:thumbnailImage
                                                             ShowSize:CGSizeMake(thumbnailImage.size.width,
                                                                                 thumbnailImage.size.height)
                                                             FileSize:100];
    
    //     UIImage *yqImage = [YQImageTool getThumbImageWithImage:image andSize:CGSizeMake(image.size.width, image.size.height)  Scale:NO];
    //    NSData *vimageData = UIImagePNGRepresentation(yqImage);
    
    videoModel.thumbnail = vimageData;
    
    NSString *urlStr = [videoPath absoluteString];
    videoModel.localPath = urlStr;
    
    YPMessage *vmessage = [[YPMessage alloc] init];
    vmessage.userId = [AppModel sharedInstance].user_info.userId;
    vmessage.messageType = MessageType_Video;
    vmessage.sessionId = self.sessionId;
    vmessage.messageId = [FunctionManager getNowTime];
    vmessage.uniqeid = StringUniquId(vmessage.userId, vmessage.sessionId, vmessage.messageId);
    
    vmessage.deliveryState = MessageDeliveryState_Delivering;
    vmessage.messageFrom = MessageDirection_SEND;
    vmessage.chatSessionType = self.chatSessionType;
    
    vmessage.messageSendId = [AppModel sharedInstance].user_info.userId;
    vmessage.timestamp = vmessage.messageId;
    vmessage.create_time = [NSDate date];
    vmessage.isReceivedMsg = NO;
    
    vmessage.videoModel = videoModel;
    
    [self sendMessageToLocal:vmessage];
    [self getUploadURL:vmessage];
}

- (void)sendSelectImage:(ImageModel *)imageModel {
    
    //    self.arrDataSources = images;
    YPMessage *mMessage = [[YPMessage alloc] init];
    mMessage.userId = [AppModel sharedInstance].user_info.userId;
    mMessage.messageType = MessageType_Image;
    mMessage.sessionId = self.sessionId;
    mMessage.messageId = [FunctionManager getNowTime];
    mMessage.uniqeid = StringUniquId(mMessage.userId, mMessage.sessionId, mMessage.messageId);
    mMessage.deliveryState = MessageDeliveryState_Delivering;
    mMessage.messageFrom = MessageDirection_SEND;
    mMessage.chatSessionType = self.chatSessionType;
    
    mMessage.messageSendId = [AppModel sharedInstance].user_info.userId;
    mMessage.timestamp = mMessage.messageId;
    mMessage.create_time = [NSDate date];
    mMessage.isReceivedMsg = NO;
    
    mMessage.imageModel = imageModel;
    
    
    [self sendMessageToLocal:mMessage];
    [self getUploadURL:mMessage];
}

#pragma mark - 发送消息-所有方法
/**
 发送消息-所有方法
 */
- (void)sendMessageAction:(YPMessage *)model {
    
    BaseUserModel *userInfo = [[BaseUserModel alloc] init];
    userInfo.userId = self.chatsModel.userId;   // 聊天对象
    userInfo.name = self.chatsModel.name;
    userInfo.avatar = self.chatsModel.avatar;;
    model.user = userInfo;
    model.toUserId = self.chatsModel.userId;
    
    if (model.messageType == MessageType_Text) {  // 文本
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(willSendMessage:)]) {
            model = [self.delegate willSendMessage:model];
        }
        [self sendMessageToLocal:model];
        [[IMMessageManager sharedInstance] sendTextMessage:model];
        
    } else if (model.messageType == MessageType_Image) {  // 图片
        
        [[IMMessageManager sharedInstance] sendImageMessage:model];
    } else if (model.messageType == MessageType_Voice) {   // 语音
        
        [[IMMessageManager sharedInstance] sendVoiceMessage:model];
    } else if (model.messageType == MessageType_Video) {   // 视频
        
        [[IMMessageManager sharedInstance] sendVideoMessage:model];
    } else {
        NSLog(@"***** 没有这个聊天类型 请查看 ******");
    }
    
}


// 注意：只能测试时用
- (void)testUse:(NSMutableDictionary *)muDict text:(NSString *)text {
    // 测试
    for (NSInteger index = 0; index < 100; index++) {
        [muDict setObject:[NSString stringWithFormat:@"%@-%zd", text,index] forKey:@"content"];
        //        [[IMMessageManager sharedInstance] sendMessageServer:muDict];
    }
}







#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.topNumIndex) {
        self.topMessageView.hidden = YES;
        self.topMessageLabel.text = 0;
    }
    ChatMessagelLayout *model = self.dataSource[indexPath.row];
    if (model.message.messageType == MessageType_CowCow_SettleRedpacket || model.message.messageFrom == ChatMessageFrom_System) {
        
        AFSystemBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:model.message.cellString];
        if (cell == nil) {
            cell = [[AFSystemBaseCell alloc]initWithStyle:0 reuseIdentifier:model.message.cellString];
        }
        cell.delegate = self;
        cell.model = model;
        //        cell.backgroundColor = [UIColor greenColor];
        return cell;
    } else {
        
        AFChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:model.message.cellString];
        if (cell == nil) {
            cell = [[AFChatBaseCell alloc]initWithStyle:0 reuseIdentifier:model.message.cellString];
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        
        cell.tag = indexPath.row;
        
        if (model.message.messageType == MessageType_RedPacket) {
            if ((model.message.redPacketInfo.cellStatus == RedPacketCellStatus_Invalid || model.message.redPacketInfo.cellStatus == RedPacketCellStatus_Normal)  && (model.message.redPacketInfo.redpacketType == RedPacketType_SingleMine || model.message.redPacketInfo.redpacketType == RedPacketType_BanRob || model.message.redPacketInfo.redpacketType == RedPacketType_CowCowNoDouble || model.message.redPacketInfo.redpacketType == RedPacketType_CowCowDouble)) {
                
                NSInteger time = [self getNowTimeWithCreate:(NSInteger)model.message.redPacketInfo.create expire:(NSInteger)model.message.redPacketInfo.expire];
                if (time <= 0) {
                    model.message.redPacketInfo.expireMrak = @"1";
                } else {
                    model.message.redPacketInfo.expireMrak = nil;
                    cell.countDownOrDescLabel.text = [NSString stringWithFormat:@"剩:%zds", time];
                }
            }
        }
        
        // 单聊 | 客服聊天用户信息处理
        if (model.message.messageFrom == MessageDirection_RECEIVE) {
            
            if (![model.message.user.name isEqualToString:self.chatsModel.name] || ![model.message.user.avatar isEqualToString:self.chatsModel.avatar]) {
                if (self.chatsModel && (self.chatsModel.sessionType == ChatSessionType_Private || self.chatsModel.sessionType == ChatSessionType_CustomerService)) {
                    model.message.user.avatar = self.chatsModel.avatar;
                    model.message.user.name = self.chatsModel.name;
                } else {
                    NSString *queryId = [NSString stringWithFormat:@"%zd_%zd", model.message.sessionId, model.message.messageSendId];
                    BaseUserModel *userModel = [AppModel sharedInstance].myGroupFriendListDict[queryId];
                    if (userModel!=nil) {
                        model.message.user.name = userModel.name;
                        model.message.user.avatar = userModel.avatar;
                    }
                }
                
            }
        }
        
        cell.model = model;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(ChatMessagelLayout *)self.dataSource[indexPath.row] cellHeight];
}

//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];
    
    [_sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}






-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIMenuController *menu=[UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:NO];
    [_sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}



#pragma YPChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)YPChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
    
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, Height_NavBar, YPSCREEN_Width, height);
        self.tableView.frame = self.mBackView.bounds;
        
        [self updateTableView:YES];
        
    } completion:^(BOOL finished) {
    }];
    
}

// 滚动到最底部  https://www.jianshu.com/p/03c478adcae7
-(void)scrollToBottom {
    
    if (self.dataSource.count > 0) {
        if ([self.tableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    //    self.notViewedMessagesCount = 0;
    self.isTableViewBottom = YES;
}


#pragma mark - 多功能视图点击回调
//多功能视图点击回调  图片10  视频11  位置12
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)tag {
    
    if(tag==10 || tag==11){
        if(!_mAddImage) {
            _mAddImage = [[SSAddImage alloc]init];
        }
        
        if (tag==10) {
            [self loadImage];
        } else if (tag==11) {
            
            XFCameraController *cameraController = [XFCameraController defaultCameraController];
            
            __weak XFCameraController *weakCameraController = cameraController;
            __weak __typeof(self)weakSelf = self;
            
            cameraController.takePhotosCompletionBlock = ^(UIImage *image, NSError *error) {
                NSLog(@"takePhotosCompletionBlock");
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [weakCameraController dismissViewControllerAnimated:YES completion:nil];
                
                NSData *imageData = UIImagePNGRepresentation(image);
                NSInteger length = imageData.length; // 图片大小，单位B
                // 压缩
                UIImage *ssImage = [image wcSessionCompress];
                
                ImageModel *imageModel = [[ImageModel alloc] init];
                imageModel.name = @"imgName";
                imageModel.size = (int32_t)length;
                imageModel.id_p = [NSString stringWithFormat:@"%.0f", [FunctionManager getNowTime]];
                imageModel.height = ssImage.size.height;
                imageModel.width = ssImage.size.width;
                
                //            imageModel.imageData = UIImagePNGRepresentation(ssImage);
                //            UIImage *yqImage = [YQImageTool getThumbImageWithImage:ssImage andSize:CGSizeMake(ssImage.size.width, ssImage.size.height)  Scale:NO];
                NSData *yqimageData = [YQImageCompressTool CompressToDataWithImage:ssImage
                                                                          ShowSize:CGSizeMake(ssImage.size.width,
                                                                                              ssImage.size.height)
                                                                          FileSize:100];
                
                //            NSData *yqimageData = UIImagePNGRepresentation(yqImage);
                imageModel.thumbnail = yqimageData;
                imageModel.imageData = yqimageData;
                
                [strongSelf sendSelectImage:imageModel];
            };
            
            cameraController.shootCompletionBlock = ^(NSURL *videoUrl, CGFloat videoTimeLength, UIImage *thumbnailImage, NSError *error) {
                NSLog(@"shootCompletionBlock");
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                // 发送视频
                [strongSelf sendVideoMessage:videoUrl videoTimeLength:videoTimeLength thumbnailImage:thumbnailImage];
                
                [weakCameraController dismissViewControllerAnimated:YES completion:nil];
            };
            
            [self presentViewController:cameraController animated:YES completion:nil];
            
        }
        
    } else {
        YPChatLocationController *vc = [YPChatLocationController new];
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            //            [self sendMessage:locationDic messageType:MessageType_Map];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}




#pragma - AFChatBaseCellDelegate

#pragma 点击Cell消息背景视图
- (void)didTapMessageCell:(YPMessage *)model {
    NSLog(@"****** 点击Cell ******");
    
    //    if (model.messageType == MessageType_Voice) {
    //        [self.tableView reloadData];
    //    }
}


#pragma mark -  点击图片 点击短视频
-(void)didChatImageVideoCellIndexPatch:(NSIndexPath *)indexPath layout:(ChatMessagelLayout *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    UIImageView *seleedView;
    
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *picUrlArr = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.dataSource.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        AFChatBaseCell *cell = [_tableView cellForRowAtIndexPath:ip];
        ChatMessagelLayout *mLayout = self.dataSource[i];
        
        if (cell == nil) {
            continue;
        }
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == MessageType_Image){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = cell.mImgView.image;
            
            [imageArr addObject:cell.mImgView];
            if (mLayout.message.imageModel.URL) {
                [picUrlArr addObject:mLayout.message.imageModel.URL];
            }
        } else if (mLayout.message.messageType == MessageType_Video){
            item.imageType = SSImageGroupVideo;  //  短视频
            //            item.videoPath = mLayout.message.videoLocalPath;
            if (mLayout.message.messageFrom == MessageDirection_SEND) {
                item.videoPath = mLayout.message.videoModel.localPath;
            } else {
                item.videoPath = mLayout.message.videoModel.localPath;
            }
            item.fromImgView = cell.mImgView;
            
            // 图片转二进制  二进制转图片
            ///   UIImage *image = [UIImage imageNamed:@"sea"];     NSData *imageData = UIImagePNGRepresentation(image);
            ///  UIImage *image = [UIImage imageWithData:imageData];
            item.fromImage = [UIImage imageWithData:mLayout.message.videoModel.thumbnail];
        } else {
            continue;
        }
        
        
        //        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout]) {
            currentIndex = groupItems.count;
            seleedView = cell.mImgView;
            
            if (mLayout.message.messageType == MessageType_Video){
                [groupItems addObject:item];
                break;
            }
        }
        if (mLayout.message.messageType == MessageType_Image){
            [groupItems addObject:item];
        }
        
    }
    
    if(layout.message.messageType == MessageType_Image){
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showNetworkPhotoViewer:imageArr urlStrArr:picUrlArr selecView:seleedView];
    } else if(layout.message.messageType == MessageType_Video){
        
        if (layout.message.videoModel.isDownload || layout.message.messageFrom == MessageDirection_SEND) {
            SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
            [self.navigationController.view addSubview:imageGroupView];
            
            __block SSImageGroupView *blockView = imageGroupView;
            blockView.dismissBlock = ^{
                [blockView removeFromSuperview];
                blockView = nil;
            };
        } else {
            SSImageGroupItem *item = groupItems.firstObject;
            [self downLoadVideo:layout.message cellView:item.fromImgView];
        }
    }
    
    [self.sessionInputView SetSSChatKeyBoardInputViewEndEditing];
}

#pragma mark - 下载视频
/**
 下载视频
 */
- (void)downLoadVideo:(YPMessage *)message cellView:(UIView *)cellView {
    
    UIImageView *videoImage = (UIImageView *)[cellView viewWithTag:3000];
    videoImage.hidden = YES;
    ZJCirclePieProgressView *videoProgressView = (ZJCirclePieProgressView *)[cellView viewWithTag:3100];
    videoProgressView.hidden = NO;
    //        UIButton *downloadBtn = (UIButton *)sender;
    
    NSString *filePath = [CDFunction videoPath];
    NSArray *arr = [message.videoModel.URL componentsSeparatedByString:@"/"];  // 切割后返回一个数组
    NSString *lastName = arr.lastObject;
    NSString *path1 = [NSString stringWithFormat:@"%@/%@.mp4",filePath, lastName];
    
    /*! 查找路径中是否存在"半塘.mp4"，是，返回真；否，返回假。 */
    //    BOOL result2 = [path1 hasSuffix:@"半塘.mp4"];
    //    NSLog(@"%d", result2);
    
    /*!
     下载前先判断该用户是否已经下载，目前用了两种方式：
     1、第一次下载完用变量保存，
     2、查找路径中是否包含改文件的名字
     如果下载完了，就不要再让用户下载，也可以添加alert的代理方法，增加用户的选择！
     */
    //    if (isFinishDownload || result2)
    //    {
    //        [[[UIAlertView alloc] initWithTitle:@"温馨提示：" message:@"您已经下载该视频！" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil] show];
    //        return;
    //    }
    //    BAWeak;
    
    BAFileDataEntity *fileEntity = [BAFileDataEntity new];
    fileEntity.urlString = message.videoModel.URL;
    fileEntity.filePath = path1;
    
    __weak __typeof(self)weakSelf = self;
    
    [BANetManager ba_downLoadFileWithEntity:fileEntity successBlock:^(id response) {
        NSLog(@"视频下载完成，路径为：%@", response);
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        message.videoModel.isDownload = YES;
        message.videoModel.localPath = response;
        
        [strongSelf downloadUpdateSqlMessage:message];
        
    } failureBlock:^(NSError *error) {
        message.videoModel.isDownload = NO;
        NSLog(@"下载视频失败");
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        //            self.downloadLabel.text = [NSString stringWithFormat:@"下载进度：%.2lld%%",100 * bytesProgress/totalBytesProgress];
        //            [downloadBtn setTitle:@"下载中..." forState:UIControlStateNormal];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //              NSString *testss =   [NSString stringWithFormat:@"%.2lld",100 * bytesProgress/totalBytesProgress];
            
            double numProgress = 100 * bytesProgress/totalBytesProgress/100.0;
            
            if (numProgress >= 1 || numProgress <= 0) {
                videoImage.hidden = NO;
                videoProgressView.hidden = YES;
            }
            videoProgressView.progress = numProgress;
            
            //                NSLog(@" **************************进度 %f  哈哈%@  **************************",numProgress, testss);
            // 改变进度
            //                self.videoProgressView.progress = slider.value;
            //                NSLog(@"1");
            //                cellView
        });
        
    }];
}


- (void)downloadUpdateSqlMessage:(YPMessage *)message {
    NSString *whereStr = [NSString stringWithFormat:@"userId = %ld and sessionId = %ld and messageId='%ld'",[AppModel sharedInstance].user_info.userId,(long)message.sessionId, (long)message.messageId];
    YPMessage *sqlMessage = [[WHC_ModelSqlite query:[YPMessage class] where:whereStr] firstObject];
    sqlMessage.videoModel.isDownload = YES;
    sqlMessage.videoModel.localPath = message.videoModel.localPath;
    if (sqlMessage) {
        BOOL isS =  [WHC_ModelSqlite update:sqlMessage where:whereStr];
        NSLog(@"是否更新成功:%x", isS);
    }
}



//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    //    UIImageView *view = (UIImageView *)tap.view;
    //    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    //    mg.delegate = self;
    //    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

#pragma AFChatBaseCellDelegate 点击定位
-(void)didChatMapCellIndexPath:(NSIndexPath *)indexPath layout:(ChatMessagelLayout *)layout{
    
    YPChatMapController *vc = [YPChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}





#pragma mark -  点击重发消息
/**
 点击重发
 
 @param model 消息模型
 */
-(void)onErrorBtnCell:(YPMessage *)model {
    model.deliveryState = MessageDeliveryState_Delivering;
    model.messageId = [FunctionManager getNowTime];
    model.timestamp = model.messageId;
    
    [self onDeleteLocalMessage:model.messageId];
    
    if (model.messageType == MessageType_Image || model.messageType == MessageType_Voice || model.messageType == MessageType_Video) {
        [self sendMessageToLocal:model];
        [self uploadFile:model];
    } else {
        [self sendMessageAction:model];
    }
    
}

#pragma mark -  发送消息 本地显示
// 发送消息
-(void)sendMessageToLocal:(YPMessage *)message {
    
    [[IMMessageManager sharedInstance] sendMessageToLocalNumSave:message];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [WHC_ModelSqlite insert:message];
    });
    
    ChatMessagelLayout *model = [YPChatDatas getMessageWithData:message];
    [self.dataSource addObject:model];
    [self updateTableView:YES];
}

-(void)updateTableView:(BOOL)animation{
    
    /*! 回到主线程刷新UI */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.dataSource.count > 0) {
            NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.dataSource.count-1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    });
    
}



#pragma mark - 相册
- (void)loadImage {
    
    [self pushTZImagePickerController];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.barItemTextColor = [UIColor redColor];
    // imagePickerVc.naviBgColor = [UIColor whiteColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    //    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location:%@",phAsset.location);
    }
    
    // 3. 获取原图的示例，用队列限制最大并发为1，避免内存暴增
    //    self.operationQueue = [[NSOperationQueue alloc] init];
    //    self.operationQueue.maxConcurrentOperationCount = 1;
    
    
    [self analysisPHAsset:assets];
    //    for (NSInteger i = 0; i < assets.count; i++) {
    //        PHAsset *asset = assets[i];
    //        // 图片上传operation，上传代码请写到operation内的start方法里，内有注释
    ////        TZImageUploadOperation *operation = [[TZImageUploadOperation alloc] initWithAsset:asset completion:^(UIImage * photo, NSDictionary *info, BOOL isDegraded) {
    ////            if (isDegraded) return;
    ////            NSLog(@"图片获取&上传完成");
    ////        } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
    ////            NSLog(@"获取原图进度 %f", progress);
    ////        }];
    ////        [self.operationQueue addOperation:operation];
    //    }
    
}

- (void)analysisPHAsset:(NSArray *)assets {
    
    for (PHAsset *asset  in assets) {
        
        __weak __typeof(self)weakSelf = self;
        
        PHImageManager * imageManager = [PHImageManager defaultManager];
        [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
            NSString *str = [url absoluteString]; //url>string
            NSArray *arr = [str componentsSeparatedByString:@"/"];
            NSString *imgName = [arr lastObject]; // 图片名字
            NSInteger length = imageData.length; // 图片大小，单位B
            UIImage *image = [UIImage imageWithData:imageData];
            // 压缩
            UIImage *ssImage = [image wcSessionCompress];
            
            ImageModel *imageModel = [[ImageModel alloc] init];
            imageModel.name = imgName;
            imageModel.size = (int32_t)length;
            imageModel.id_p = [NSString stringWithFormat:@"%.0f", [FunctionManager getNowTime]];
            imageModel.height = ssImage.size.height;
            imageModel.width = ssImage.size.width;
            
            //            imageModel.imageData = UIImagePNGRepresentation(ssImage);
            //            UIImage *yqImage = [YQImageTool getThumbImageWithImage:ssImage andSize:CGSizeMake(ssImage.size.width, ssImage.size.height)  Scale:NO];
            NSData *yqimageData = [YQImageCompressTool CompressToDataWithImage:ssImage
                                                                      ShowSize:CGSizeMake(ssImage.size.width,
                                                                                          ssImage.size.height)
                                                                      FileSize:100];
            
            //            NSData *yqimageData = UIImagePNGRepresentation(yqImage);
            imageModel.thumbnail = yqimageData;
            imageModel.imageData = yqimageData;
            
            [strongSelf sendSelectImage:imageModel];
            
        }];
    }
    
}






// If user picking a video and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个视频且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetLowQuality success:^(NSString *outputPath) {
        // NSData *data = [NSData dataWithContentsOfFile:outputPath];
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    //    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image and allowPickingMultipleVideo is NO, this callback will be called.
// If allowPickingMultipleVideo is YES, will call imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
// 如果用户选择了一个gif图片且allowPickingMultipleVideo是NO，下面的代理方法会被执行
// 如果allowPickingMultipleVideo是YES，将会调用imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    //    [_collectionView reloadData];
}


#pragma mark - 打印图片名字

///  打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        NSLog(@"图片名字:%@",fileName);
    }
}

#pragma mark - 获取上传URL

/// 获取上传URL
- (void)getUploadURL:(YPMessage *)message {
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = [NSString stringWithFormat:@"%@%@",[AppModel sharedInstance].serverApiUrl,@"system/getUploadUrl"];
    entity.needCache = NO;
    
    //    [MBProgressHUD showActivityMessageInView:nil];
    __weak __typeof(self)weakSelf = self;
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUD];
        
        if (response[@"status"] && [response[@"status"] integerValue] == 1) {
            UploadFileModel *model = [UploadFileModel mj_objectWithKeyValues:response[@"data"]];
            //            strongSelf.upUrlModel = model;
            
            if (message.messageType == MessageType_Image) {
                message.imageModel.uploadUrl = model.url;
                message.imageModel.URL = model.img;
            } else  if (message.messageType == MessageType_Voice) {
                message.audioModel.uploadUrl = model.url;
                message.audioModel.URL = model.img;
            } else  if (message.messageType == MessageType_Video) {
                message.videoModel.uploadUrl = model.url;
                message.videoModel.URL = model.img;
            }
            
            
            [strongSelf uploadFile:message];
            NSLog(@"获取上传URL=: %@  ***** 上传完成后的URL=: %@", model.url, model.img);
        } else {
            [[AFHttpError sharedInstance] handleFailResponse:response];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[AFHttpError sharedInstance] handleFailResponse:error];
    } progressBlock:nil];
}


/*
 文件上传(put方式)
 */
- (void)uploadFile:(YPMessage *)message {
    
    NSString *uploadUrl = nil;
    if (message.messageType == MessageType_Image) {
        uploadUrl = message.imageModel.uploadUrl;
    } else  if (message.messageType == MessageType_Voice) {
        uploadUrl = message.audioModel.uploadUrl;
    } else  if (message.messageType == MessageType_Video) {
        uploadUrl = message.videoModel.uploadUrl;
    }
    
    //1.创建url对象
    NSURL *url = [NSURL URLWithString:uploadUrl];
    //2.创建request对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    //设置为put方式
    request.HTTPMethod = @"PUT";
    
    //4.设置授权
    //创建账号NSData
    //    NSData *accountData = [@"yyh:123456" dataUsingEncoding:NSUTF8StringEncoding];
    //    //对NSData进行base64编码
    //    NSString *accountStr = [accountData base64EncodedStringWithOptions:0];
    
    NSString *authStr = [NSString stringWithFormat:@"Bearer %@", [AppModel sharedInstance].token];
    //增加授权头字段
    [request setValue:authStr forHTTPHeaderField:@"Authorization"];
    [request setValue:@"" forHTTPHeaderField:@"Content-Type"];
    
    
    //获取图片的路径
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
    
    
    //6.创建上传任务
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSData *data = nil;
    if (message.messageType == MessageType_Image) {
        data = message.imageModel.imageData;
    } else if (message.messageType == MessageType_Voice) {
        //        data = message.audioModel.voiceData;
        data = [LGSoundRecorder convertCAFtoAMR:message.audioModel.voiceLocalPath];
    } else if (message.messageType == MessageType_Video) {
        NSString *url = message.videoModel.localPath;
        // 本地文件
        NSURL *fileUrl = [NSURL URLWithString:url];
        if (![url containsString:@"file:"]) {
            fileUrl = [NSURL fileURLWithPath:url];
        }
        
        NSString *path1 = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/tempvideoname.mp4"]];
        
        
        [VideoService encodeMP4WithVideoUrl:fileUrl outputVideoUrl:path1 blockHandler:^(AVAssetExportSession *handler) {
            NSLog(@"11");
            
            NSURL *ttfileUrl = [NSURL URLWithString:path1];
            //4 task
            /*
             Request:请求对象
             fromData:请求体
             */
            __weak __typeof(self)weakSelf = self;
            NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromFile:ttfileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                if (!error) {
                    NSLog(@"✅****** 上传图片|视频|音频成功 ******✅");
                    [strongSelf sendMessageAction:message];
                    // self.upUrlModel.img
                    /*! 回到主线程刷新UI */
                    //            dispatch_async(dispatch_get_main_queue(), ^{
                    //                [strongSelf.tableView reloadData];
                    //            });
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    //   删除文件
                    BOOL isDelete= [fileManager removeItemAtPath:path1 error:nil];
                    NSLog(@"11%@", isDelete ? @"缓存文件删除成功" : @"缓存文件删除失败");
                } else {
                    NSLog(@"🔴****** 上传图片|视频|音频失败 ******🔴");
                    message.deliveryState = MessageDeliveryState_Failed;
                    /*! 回到主线程刷新UI */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.tableView reloadData];
                    });
                }
                //打印出响应体，查看是否发送成功
                NSLog(@"response = %@",response);
                
            }];
            
            //7.执行上传
            [uploadTask resume];
            
        }];
        
        
        
        return;
    }
    
    
    
    
    
    
    
    //4 task
    /*
     Request:请求对象
     fromData:请求体
     */
    __weak __typeof(self)weakSelf = self;
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (!error) {
            NSLog(@"✅****** 上传图片|视频|音频成功 ******✅");
            [strongSelf sendMessageAction:message];
            
            /*! 回到主线程刷新UI */
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [strongSelf.tableView reloadData];
            //            });
            
        } else {
            NSLog(@"🔴****** 上传图片|视频|音频失败 ******🔴");
            message.deliveryState = MessageDeliveryState_Failed;
            /*! 回到主线程刷新UI */
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
        //打印出响应体，查看是否发送成功
        NSLog(@"response = %@",response);
        
    }];
    
    //7.执行上传
    [uploadTask resume];
    
    
}



@end

