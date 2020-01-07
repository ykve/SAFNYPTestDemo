//
//  Contacts.h
//  WRHB
//
//  Created by AFan on 2019/6/20.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  消息送达状态枚举
 */
typedef NS_ENUM(NSInteger, FriendType) {
    /// 客服
    FriendType_KeFu  = 1,
    /// 推荐我的人  上级
    FriendType_Super  = 2,
    /// 我推荐的人  下级
    FriendType_Sub  = 3 ,
    /// 正常好友
    FriendType_Normal  = 4,
    /// 请求添加好友的人
    FriendType_Request  = 5
};



@interface YPContacts : NSObject<NSCoding>
/// 用户ID
@property (nonatomic, assign) NSInteger     user_id;
/// 用户名称
@property (nonatomic, copy) NSString     *name;
/// 昵称
@property (nonatomic, copy) NSString     *nickName;
/// 用户头像
@property (nonatomic, copy) NSString     *avatar;
/// 用户性别
@property (nonatomic, assign) UserGender sex;
/// 好友关系
@property (nonatomic, assign) FriendType  contactsType;
/// 个性签名
@property (nonatomic, copy) NSString     *des;

/// 编号  (对数据进行排序，并按首字母分类)
@property (nonatomic, assign) NSInteger sectionNumber;
///
//@property (nonatomic, assign) NSInteger     requestId;


/// 是否选中
@property (nonatomic, assign) BOOL     isSelected;
/// 是否已添加
@property (nonatomic, assign) BOOL     isAdded;


- (id)initWithPropertiesDictionary:(NSDictionary *)dic;


@end
