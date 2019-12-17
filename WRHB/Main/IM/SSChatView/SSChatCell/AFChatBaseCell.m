//
//  AFChatBaseCell.m
//  YPChatView
//
//  Created by soldoros on 2019/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "AFChatBaseCell.h"
#import "YPIMKitUtil.h"

@implementation AFChatBaseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YPChatCellColor;
        self.contentView.backgroundColor = YPChatCellColor;
        [self initChatCellUI];
    }
    return self;
}


-(void)initChatCellUI {
    
    //创建时间
    _mMessageTimeLab = [UILabel new];
    _mMessageTimeLab.bounds = CGRectMake(0, 0, YPChatTimeWidth, YPChatTimeHeight);
    _mMessageTimeLab.top = YPChatTimeTopOrBottom;
    _mMessageTimeLab.centerX = YPSCREEN_Width*0.5;
    [self.contentView addSubview:_mMessageTimeLab];
    _mMessageTimeLab.textAlignment = NSTextAlignmentCenter;
    _mMessageTimeLab.font = [UIFont systemFontOfSize:YPChatTimeFont];
    _mMessageTimeLab.textColor = [UIColor whiteColor];
    _mMessageTimeLab.backgroundColor = [UIColor colorWithRed:0.788 green:0.788 blue:0.788 alpha:1.000];
    _mMessageTimeLab.clipsToBounds = YES;
    _mMessageTimeLab.layer.cornerRadius = 3;
    
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _mHeaderImgBtn.backgroundColor =  [UIColor brownColor];
    _mHeaderImgBtn.tag = 10;
    _mHeaderImgBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:_mHeaderImgBtn];
    _mHeaderImgBtn.layer.cornerRadius = 5;
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(onHeadImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPgr =  [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPgr.minimumPressDuration = 0.5;
    [_mHeaderImgBtn addGestureRecognizer:longPgr];
    
    
    // 创建昵称
    _nicknameLabel = [UILabel new];
    _nicknameLabel.bounds = CGRectMake(YPChatIconLeftOrRight*2 + YPChatHeadImgWH,YPChatCellTopOrBottom, YPChatNameWidth, YPChatNameHeight);
    [self.contentView addSubview:_nicknameLabel];
    _nicknameLabel.textAlignment = NSTextAlignmentLeft;
    _nicknameLabel.font = [UIFont systemFontOfSize:YPChatTimeFont];
    _nicknameLabel.textColor = [UIColor darkGrayColor];
    
    
    //背景按钮
    _bubbleBackView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleBackViewAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_bubbleBackView addGestureRecognizer:tap];
    _bubbleBackView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleBackView];
    
    //traningActivityIndicator
    _traningActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [self.contentView addSubview:_traningActivityIndicator];
    //    _traningActivityIndicator.backgroundColor = [UIColor redColor];
    _traningActivityIndicator.color = [UIColor darkGrayColor];
    _traningActivityIndicator.hidden = YES;
    
    //    _bubbleBackView.backgroundColor = [UIColor greenColor];
    // 高度   45 + 10 + 名称(12) + 4 + 消息内容高度（？）+ 10
    
    _errorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,20,20)];
    //    _errorBtn.backgroundColor = [UIColor redColor];
    [_errorBtn setBackgroundImage:[UIImage imageNamed:@"message_ic_warning"] forState:UIControlStateNormal];
    _errorBtn.hidden = YES;
    [_errorBtn addTarget:self action:@selector(onErrorBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_errorBtn];
    
    
    UIView *readedBackView = [[UIView alloc] init];
    [_bubbleBackView addSubview:readedBackView];
    _readedBackView = readedBackView;
//    readedBackView.backgroundColor = [UIColor greenColor];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"12:00";
    dateLabel.font = [UIFont systemFontOfSize:9];
    dateLabel.textColor = [UIColor whiteColor];
    [readedBackView addSubview:dateLabel];
    _dateLabel = dateLabel;
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(readedBackView.mas_left).offset(3);
        make.centerY.equalTo(readedBackView.mas_centerY);
    }];
    
    // 创建已读标识
    _readedImg = [UIImageView new];
//    _readedImg.backgroundColor = [UIColor redColor];
    _readedImg.image = [UIImage imageNamed:@"chat_readed"];
//    _readedImg.bounds = CGRectMake(0, 0, YPChatReadedIconWidth, YPChatReadedIconHeight);
    [readedBackView addSubview:_readedImg];
    
    [_readedImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(readedBackView.mas_right).offset(-3);
        make.centerY.equalTo(readedBackView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(YPChatReadedIconWidth, YPChatReadedIconHeight));
    }];
    
    
//    _bubbleBackView.backgroundColor = [UIColor greenColor];
}


- (void)onErrorBtn {
    if(self.delegate && [self.delegate respondsToSelector:@selector(onErrorBtnCell:)]){
        [self.delegate onErrorBtnCell:self.model.message];
    }
}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)setModel:(ChatMessagelLayout *)model{
    _model = model;
    
    _mMessageTimeLab.hidden = !model.message.showTime;
    _mMessageTimeLab.text = [YPIMKitUtil showTime:model.message.timestamp/1000 showDetail:YES];
    [_mMessageTimeLab sizeToFit];
    _mMessageTimeLab.height = YPChatTimeHeight;
    _mMessageTimeLab.width += 20;
    _mMessageTimeLab.centerX = YPSCREEN_Width*0.5;
    _mMessageTimeLab.top = YPChatTimeTopOrBottom;
    
    
    
    NSString *name = nil;
    NSString *avatar = nil;
    [self.mHeaderImgBtn setImage:nil forState:UIControlStateNormal];  // 清空缓存
    if(model.message.messageFrom == MessageDirection_SEND){
        name = [AppModel sharedInstance].user_info.name;
        avatar = [AppModel sharedInstance].user_info.avatar;
    } else {
        // 群组用户头像和名称处理
        if (model.message.chatSessionType == ChatSessionType_SystemRoom || model.message.chatSessionType == ChatSessionType_ManyPeople_Game || model.message.chatSessionType == ChatSessionType_ManyPeople_NormalChat) {
            NSString *queryId = [NSString stringWithFormat:@"%ld_%ld", model.message.sessionId, model.message.messageSendId];
            BaseUserModel *userModel = [AppModel sharedInstance].myGroupFriendListDict[queryId];
            name = userModel.name;
            avatar = userModel.avatar;
        } else {
            name = model.message.user.name;
            avatar = model.message.user.avatar;
        }
    }
    
    
    
   
    self.nicknameLabel.frame = model.nickNameRect;
    if (model.message.messageFrom == MessageDirection_SEND) {
        self.nicknameLabel.text = @"";
    } else {
        self.nicknameLabel.text = name;
    }
    
    self.mHeaderImgBtn.frame = model.headerImgRect;
    
    if (avatar.length < kAvatarLength) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"group_av_%@", avatar]];
        if (image) {
            [self.mHeaderImgBtn setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [self.mHeaderImgBtn setBackgroundImage:[UIImage imageNamed:@"cm_default_avatar"] forState:UIControlStateNormal];
        }
    } else {
        [self.mHeaderImgBtn cd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"cm_default_avatar"]];
    }
    
    
    //    [self.mHeaderImgBtn setBackgroundImage:[UIImage imageNamed:@"touxaing2"] forState:UIControlStateNormal];
    
    _readedBackView.hidden = NO;
    // 接收
    if(model.message.messageFrom == MessageDirection_RECEIVE){
        _nicknameLabel.textAlignment = NSTextAlignmentLeft;
        _readedImg.hidden = YES;
        if (model.message.messageType == MessageType_Text || model.message.messageType == MessageType_Image || model.message.messageType == MessageType_Voice || model.message.messageType == MessageType_Video) {
            _dateLabel.hidden = NO;
        } else {
            _dateLabel.hidden = YES;
        }
    } else {
        _nicknameLabel.textAlignment = NSTextAlignmentRight;
       if (model.message.messageType == MessageType_Text || model.message.messageType == MessageType_Image || model.message.messageType == MessageType_Voice || model.message.messageType == MessageType_Video) {
            _readedImg.hidden = NO;
        } else {
            _readedImg.hidden = YES;
            _dateLabel.hidden = YES;
        }
        
    }
}


/**
 设置发送消息的状态
 */
- (void)setSendMessageStats {
    if (self.model.message.messageFrom == MessageDirection_SEND)
    {
        // 消息加载状态
        BOOL isActivityIndicatorHidden = [self activityIndicatorHidden];
        if (isActivityIndicatorHidden) {
            [self.traningActivityIndicator stopAnimating];  // 停止转圈
        } else {
            [self.traningActivityIndicator startAnimating];   // 转圈
            [self layoutActivityIndicator];  // 位置
        }
        [self.traningActivityIndicator setHidden:isActivityIndicatorHidden];
        
        if (self.model.message.deliveryState == MessageDeliveryState_Failed) {
            [self layoutErrorBtn];
        } else {
            self.errorBtn.hidden = YES;
        }
    } else {
        [self.traningActivityIndicator setHidden:YES];
        self.errorBtn.hidden = YES;
    }
}

- (void)layoutErrorBtn
{
    CGFloat centerX = 0;
    
    centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
    self.errorBtn.center = CGPointMake(centerX,
                                       self.bubbleBackView.center.y);
    self.errorBtn.hidden = NO;
    
}

- (void)layoutActivityIndicator
{
    if (self.traningActivityIndicator.isAnimating) {
        CGFloat centerX = 0;
        
        centerX = CGRectGetMinX(self.bubbleBackView.frame) - 8 - CGRectGetWidth(self.traningActivityIndicator.bounds)/2;
        self.traningActivityIndicator.center = CGPointMake(centerX,
                                                           self.bubbleBackView.center.y);
    }
}

- (BOOL)activityIndicatorHidden
{
    if (self.model.message.isReceivedMsg)
    {
        return self.model.message.deliveryState != MessageDeliveryState_Delivering;
    }
    return NO;
}



/**
 点击头像
 
 @param sender UIButton
 */
-(void)onHeadImageBtn:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapCellChatHeaderImg:)]){
        [self.delegate didTapCellChatHeaderImg:self.model.message.user];
    }
}


// 头像长按手势
-(void)longPress:(UILongPressGestureRecognizer *)longPressGesture {
    // 当识别到长按手势时触发(长按时间到达之后触发)
    if (UIGestureRecognizerStateBegan ==longPressGesture.state) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didLongPressCellChatHeaderImg:)]){
            [self.delegate didLongPressCellChatHeaderImg:self.model.message.user];
        }
    }
}




// 点击消息背景事件
-(void)bubbleBackViewAction:(UIImageView *)sender{
    [self buttonPressed:nil];
    if(self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageCell:)]){
        [self.delegate didTapMessageCell:self.model.message];
    }
}

//消息按钮50
-(void)buttonPressed:(UIButton *)sender{
    NSLog(@"1");
}



- (void)setCountDownOrDescLabel:(UILabel *)countDownOrDescLabel {
    _countDownOrDescLabel = countDownOrDescLabel;
}

@end
