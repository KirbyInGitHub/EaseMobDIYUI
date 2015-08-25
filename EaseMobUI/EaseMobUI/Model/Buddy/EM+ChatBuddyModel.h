//
//  EM+ChatBuddyModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "commonDefs.h"
@class UIImage;
@class EM_ChatBuddyGroupModel;

@interface EM_ChatBuddyModel : NSObject

/**
 *  chatter 唯一标示
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *remarkName;

/**
 *  是否是特别关心
 */
@property (nonatomic, assign) BOOL carefor;

/**
 *  头像URL
 */
@property (nonatomic, copy) NSURL *avatarURL;

/**
 *  头像,如果设置了,avatarURL会失效
 */
@property (nonatomic, strong) UIImage *avatarImage;

/**
 *  签名
 */
@property (nonatomic, copy) NSString *signature;

@property (nonatomic, strong) EM_ChatBuddyGroupModel *group;

/**
 *  在线状态,环信并没有提供获取好友状态的API,但是有好友状态的枚举
 *  这里只是借用一下环信的枚举,状态需要自己通过自己的服务器去获取,说不定以后环信会支持相关API
 *  eOnlineStatus_OffLine   离线
 *  eOnlineStatus_Online    在线
 *  eOnlineStatus_Away      离开
 *  eOnlineStatus_Busy      忙碌
 *  eOnlineStatus_Invisible 隐身
 *  eOnlineStatus_Do_Not_Disturb 免打扰
 */
@property (nonatomic, assign) EMOnlineStatus onlineState;

@end