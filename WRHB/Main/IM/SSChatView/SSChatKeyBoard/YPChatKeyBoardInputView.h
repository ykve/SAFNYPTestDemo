//
//  YPChatKeyBoardInputView.h
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "SSDeviceDefault.h"
#import <AVFoundation/AVFoundation.h>
#import "UUProgressHUD.h"
#import "UUAVAudioPlayer.h"
#import "YPChatKeyBoardDatas.h"
#import "YPChatKeyBordView.h"



/**
 聊天界面底部的输入框视图
 */

#define YPChatKeyBoardInputViewH      49     //输入部分的高度
#define YPChatKeyBoardInputUpViewH      60     //输入框上面部分的高度 客服才有
#define YPChatKeyBordBottomHeight     240    //底部视图的高度


#define YPChatLineHeight        0.5          //线条高度
#define YPChatBotomTop          YPSCREEN_Height-YPChatBotomHeight-kiPhoneX_Bottom_Height                    //底部视图的顶部
#define YPChatBtnSize           30           //按钮的大小
#define YPChatLeftDistence      5            //左边间隙
#define YPChatRightDistence     5            //左边间隙
#define YPChatBtnDistence       10           //控件之间的间隙
#define YPChatTextHeight        33           //输入框的高度
#define YPChatTextMaxHeight     83           //输入框的最大高度
#define YPChatTextWidth      YPSCREEN_Width - (3*YPChatBtnSize + 5* YPChatBtnDistence)   //输入框的宽度
//#define YPChatTextWidth      YPSCREEN_Width - (2*YPChatBtnSize + 4* YPChatBtnDistence)   //输入框的宽度

#define YPChatTBottomDistence   8            //输入框上下间隙
#define YPChatBBottomDistence   8.5          //按钮上下间隙


@class YPChatKeyBoardInputView;


@protocol YPChatKeyBoardInputViewDelegate <NSObject>

//改变输入框的高度 并让控制器弹出键盘
-(void)YPChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime;

//发送文本信息
-(void)onChatKeyBoardInputViewSendText:(NSString *)text;

//发送语音消息
- (void)YPChatKeyBoardInputViewBtnClick:(YPChatKeyBoardInputView *)view voicePath:(NSString *)voicePath sendVoice:(NSData *)voice time:(NSInteger)second;

//多功能视图按钮点击回调
-(void)chatFunctionBoardClickedItemWithTag:(NSInteger)tag;
-(void)didChatKeFuTopupTypeSelectedIndex:(NSInteger)index;
-(void)didChatGoto_kefu;
-(void)didChatGoto_feedbackBtn;


@end


@interface YPChatKeyBoardInputView : UIView<UITextViewDelegate,AVAudioRecorderDelegate,YPChatKeyBordViewDelegate> 

@property (nonatomic, assign)id<YPChatKeyBoardInputViewDelegate>delegate;

//当前的编辑状态（默认 语音 编辑文本 发送表情 其他功能）
@property (nonatomic, assign)YPChatKeyBoardStatus keyBoardStatus;

//键盘或者 表情视图 功能视图的高度
@property (nonatomic, assign)CGFloat changeTime;
@property (nonatomic, assign)CGFloat keyBoardHieght; 

//传入底部视图进行frame布局
@property (strong, nonatomic) YPChatKeyBordView   *mKeyBordView; 

//顶部线条
@property (nonatomic, strong) UIView   *topLine;

//当前点击的按钮  左侧按钮   表情按钮  添加按钮
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) UIButton *mLeftBtn;
@property (nonatomic, strong) UIButton *mSymbolBtn;
@property (nonatomic, strong) UIButton *mAddBtn;

//输入框背景 输入框 缓存输入的文字
@property (nonatomic, strong) UIButton     *mTextBtn;
@property (nonatomic, strong) UITextView   *mTextView;
@property (nonatomic, strong) NSString     *textString;
/// 输入框的高度
@property (nonatomic, assign) CGFloat   textH;

/// ************ 客服 ************
/// 输入框上面的高度， 客服才有
@property (nonatomic, assign) CGFloat   initKefuViewHeight;
/// 客服充值支持
@property (nonatomic, strong) NSArray *ysReplyModelArray;
/// 客服View
@property (nonatomic, strong) UIView *topBackView;
/// 支付View
@property (nonatomic, strong) UIView *payBgView;
/// 客服提示msg View
@property (nonatomic, strong) UIView *textBgView;
/// 客服是否禁言
@property (nonatomic, assign) BOOL isNoSpeak;
/// 客服是否断开链接
@property (nonatomic, assign) BOOL isDisconnect;




/// 初始化总高度
@property (nonatomic, assign, readonly) CGFloat   initViewHeight;

//添加表情
@property (nonatomic, strong) NSObject       *emojiText;

//录音相关
@property (nonatomic, assign) BOOL      isbeginVoiceRecord;
@property (nonatomic, assign) NSInteger playTime;
/// 录音文件路径
@property (nonatomic, strong) NSString  *docmentFilePath;

@property (nonatomic, strong) NSTimer         *playTimer;
@property (nonatomic, strong) UILabel         *placeHold;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioSession  *audioSession;

@property (nonatomic, strong) UIButton  *btnSendMessage;
@property (nonatomic, strong) UIButton  *btnChangeVoiceState;
@property (nonatomic, strong) UIButton  *btnVoiceRecord;


//键盘归位
-(void)SetSSChatKeyBoardInputViewEndEditing;


/**
 添加@ 用户

 @param userInfo 用户模型
 */
- (void)addMentionedUser:(UserInfo *)userInfo;

@end







