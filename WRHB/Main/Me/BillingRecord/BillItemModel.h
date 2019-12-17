//
//  BillItemModel.h
//  WRHB
//
//  Created by AFan on 2019/10/13.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>

// 账单类型
typedef NS_ENUM(NSInteger, BillType) {
    /// 发红包扣除
    BillType_SendHongBao_Less    = 1,
    /// 单雷场踩雷赔付
    BillType_SingleMine_CaiLeiPeiFu_Less    = 2,
    /// 单雷场抢包
    BillType_SingleMine_QiangBao_More    = 3,
    /// 单雷场红包返还
    BillType_SingleMine_HongBaoFanHuan_More    = 4,
    /// 单雷场发包者赢输结果
    BillType_SingleMine_ShuYingJieGuo_Less    = 5,
    
    /// 多雷场踩雷赔付
    BillType_ManyMine_CaiLeiPeiFu_Less    = 6,
    /// 多雷场抢包
    BillType_ManyMine_QiangBao_More    = 7,
    /// 多雷场红包返还
    BillType_ManyMine_HongBaoFanHuan_More    = 8,
    /// 多雷场发包者赢输结果
    BillType_ManyMine_ShuYingJieGuo_Less    = 9,
    
    
    /// 牛牛场赔付
    BillType_CowCow_PeiFu_Less    = 10,
    /// 牛牛场抢包
    BillType_CowCow_QiangBao_More    = 11,
    /// 牛牛场赢
    BillType_CowCow_Win_More    = 12,
    /// 牛牛场抢包返还
    BillType_CowCow_QiangBaoFanHuan_More    = 13,
    
    
    /// 牛牛场发包者赢结果
    BillType_CowCow_ShuYingJieGuo_More    = 14,
    /// 牛牛场发包者输结果
    BillType_CowCow_ShuYingJieGuo_Less    = 15,
    
    
    /// 牛牛场豹子奖励
    BillType_CowCow_BaoZi_JiangLi    = 16,
    /// 牛牛场顺子奖励
    BillType_CowCow_ShunXi_JiangLi    = 17,
    
    
    /// 人工上分  - 充值
    BillType_RenGongShangFen_Topup    = 18,
    /// 人工下分   - 提现
    BillType_RenGongXiaFen_TiXian    = 19,
    /// 玩家提现
    BillType_WanJia_TiXian    = 20,
    /// 签到奖励
    BillType_QianDao_JiangLi    = 21,
    
    /// VIP通道充值
    BillType_Vip_Topup    = 22,
    /// 第三方网关通道充值
    BillType_WangGuan_Topup    = 23,
    /// 赠送彩金
    BillType_Lottery_Topup    = 26,
    /// 盈商上分
    BillType_YS_Topup    = 27,
    
    
    
    /// 代理流水奖励
    BillType_LiuShui_JiangLi    = 1018,
    /// 代理盈利奖励
    BillType_DaiLiYingLi_JiangLi    = 1019,
    
    /// 普通玩法抢红包
    BillType_Normal_QiangHongBao_More    = 1020,
    /// 普通玩法发红包
    BillType_Normal_SendHongBao_Less    = 1021,
    /// 普通玩法红包余额退还
    BillType_Normal_YuEFanHuan_More    = 1022,
    
    
    /// 红包接力抢包
    BillType_HongBaoJieLi_QiangBao_More    = 1023,
    /// 红包接力返还
    BillType_HongBaoJieLiFanHuan_More    = 1024,
    /// 红包接力押金
    BillType_HongBaoJieLi_YaJin_Less    = 1025,
    /// 红包接力押金返还
    BillType_HongBaoJieLi_YaJinFanHuan_More    = 1026,
    /// 红包接力发送红包
    BillType_HongBaoJieLi_SendHongBao_Less    = 1027,
    
    /// 红包押金扣除
    BillType_HongBaoYaJin_Less    = 1028,
    /// 特殊金额奖励
    BillType_TeShuJinE_JiangLi    = 1029,
    /// 充值奖励
    BillType_ChongZhi_JiangLi    = 1030,
    /// 首充奖励
    BillType_ShouChong_JiangLi    = 1031,
    /// 还有充值奖励
    BillType_HaiYouChongZhi_JiangLi    = 1032,
    /// 代理工资奖励
    BillType_DaiLiGongZi_JiangLi    = 1033,
    /// 救济金奖励
    BillType_JiuJiJin_JiangLi    = 1034,
    /// 红包福利群
    BillType_HongBao_FuLiQun_More    = 1035
};

NS_ASSUME_NONNULL_BEGIN

@interface BillItemModel : NSObject

/// 账单ID
@property (nonatomic, assign) NSInteger ID;
/// title
@property (nonatomic, copy) NSString *title;
/// 账单类型 (全部不传递次字段)
@property (nonatomic, assign) BillType type;
/// 数量
@property (nonatomic, copy) NSString *number;
/// 创建时间
@property (nonatomic, assign) NSInteger created_at;
/// 红包 ID
@property (nonatomic, assign) NSInteger packet_id;
/// 目标 id 例如 充值时使用这个
@property (nonatomic, assign) NSInteger target_id;


/// ?
@property (nonatomic, assign) NSInteger play_type;
/// ********* 充值 *********
///  1支付宝 ，2微信 3银行卡  4人工充值  5赠送彩金
@property (nonatomic, assign) NSInteger method;

@end

NS_ASSUME_NONNULL_END
