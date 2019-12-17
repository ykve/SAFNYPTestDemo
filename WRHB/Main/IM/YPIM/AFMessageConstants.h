//
//  AFMessageConstants.h
//  Project
//
//  Created by AFan on 2019/4/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#ifndef AFMessageConstants_h
#define AFMessageConstants_h

//cell的一些设置
static NSString *const YPChatTextCellId = @"YPChatTextCellId";
static NSString *const YPChatImageCellId = @"YPChatImageCellId";
static NSString *const YPChatVoiceCellId = @"YPChatVoiceCellId";
static NSString *const YPChatMapCellId = @"YPChatMapCellId";
static NSString *const YPChatVideoCellId = @"YPChatVideoCellId";
// 红包Cell
static NSString *const AFRedPacketCellId = @"AFRedPacketCellId";
// 牛牛报奖信息
static NSString *const CowCowVSMessageCellId = @"CowCowVSMessageCellId";
// 系统消息
static NSString *const NotificationMessageCellId = @"ChatNotifiCell";


static const CGFloat   YPChatCellTopOrBottom             = 10;  //顶部距离cell or 底部距离cell
static const CGFloat   YPChatNameWidth             = 120;  //原型昵称尺寸宽度
static const CGFloat   YPChatNameSpacingHeight     = 16;  //名称+间隔
static const CGFloat   YPChatHeadImgWH             = 40;  //原型头像尺寸

//显示时间
static const CGFloat   YPChatNameHeight             = 44;  //原型头像尺寸
static const CGFloat   YPChatIconLeftOrRight             = 10;  //头像与左边or右边距离
static const CGFloat   YPChatDetailLeft             = 10;  //详情与左边距离
static const CGFloat   YPChatDetailRight     = 10;  //详情与右边距离
static const CGFloat   YPChatTextTop             = 10;  //文本距离详情顶部
static const CGFloat   YPChatTextBottom             = 12;  //文本距离详情底部
static const CGFloat   YPChatTextLRS             = 5;  //文本左右短距离
static const CGFloat   YPChatTextLRB             = 10;  //文本左右长距离


//显示时间
static const CGFloat   YPChatTimeWidth             = 180;  //时间宽度
static const CGFloat   YPChatTimeHeight             = 20;  //时间高度
static const CGFloat   YPChatTimeTopOrBottom             = 12.5;  //时间距离顶部或者底部


static const CGFloat   YPChatAirTop             = 10;  //气泡距离详情顶部
static const CGFloat   YPChatAirLRS             = 10;  //气泡左右短距离
static const CGFloat   YPChatAirBottom             = 20;  //气泡距离详情底部
static const CGFloat   YPChatAirLRB             = 15;  //气泡左右长距离
static const CGFloat   YPChatTimeFont             = 12;  //时间字体
static const CGFloat   YPChatTextFont             = 17;  //内容字号


static const CGFloat   YPChatTextLineSpacing             = 5;  //文本行高
static const CGFloat   YPChatTextRowSpacing             = 0;  //文本间距

// 已读标识
static const CGFloat   YPChatReadedBackViewWidth             = 46;  // 宽
static const CGFloat   YPChatReadedBackViewHeight             = 10;  // 宽
static const CGFloat   YPChatReadedIconWidth             = 12;  // 宽
static const CGFloat   YPChatReadedIconHeight             = 9;  // 高


#define bgWidth (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 2))//
#define bgRate 0.45

#define CowBackImageHeight 80


// 红包宽度
//#define   YPRedPacketBackWidth              (UIScreen.mainScreen.bounds.size.width - (CD_WidthScal(60, 320) * 1) -(CD_WidthScal(70, 320) * 1))  //200 红包宽度
//// 红包高度
//#define   YPRedPacketBackHeight              bgWidth*60.5/200  // 红包高度


// 红包宽度
#define   YPRedPacketBackWidth         176.5       // 红包宽度
// 红包高度
#define   YPRedPacketBackHeight              60.5  // 红包高度



//文本颜色
#define YPChatTextColor         [UIColor blackColor]

//右侧头像的X坐标
#define YPChatIcon_RX            YPSCREEN_Width-YPChatIconLeftOrRight-YPChatHeadImgWH

//文本自适应限制宽度
#define YPChatTextInitWidth    YPSCREEN_Width*0.62-YPChatTextLRS-YPChatTextLRB

//图片最大尺寸(正方形)
static const CGFloat   YPChatImageMaxSize             = 150;

//音频的最小宽度  最大宽度   高度
#define YPChatVoiceMinWidth     100
#define YPChatVoiceMaxWidth        YPSCREEN_Width*2/3-YPChatTextLRS-YPChatTextLRB
#define YPChatVoiceHeight       45
//音频时间字体
#define YPChatVoiceTimeFont     14
//音频波浪图案尺寸
#define YPChatVoiceImgSize      20
#define YPChatVoiceUnreadRedDotSize      5

// 消息分页数量
#define kMessagePageNumber     30

//地图位置宽度 高度
static const CGFloat   YPChatMapWidth             = 240;
static const CGFloat   YPChatMapHeight             = 150;

//短视频位置宽度 高度
static const CGFloat   YPChatVideoWidth             = 200;
static const CGFloat   YPChatVideoHeight             = 150;



// ***************** 通知 *****************
// 刷新聊天内容
static NSString * const kRefreshChatContentNotification = @"kRefreshChatContentNotification";
// 发送红包后通知
static NSString * const kSendRedPacketNotification = @"kSendRedPacketNotification";



#endif /* ChatMessageConstants_h */
