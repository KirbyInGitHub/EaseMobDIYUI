//
//  EM+ChatController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"

@protocol EM_ChatControllerDelegate;

@interface EM_ChatController : UIViewController

/**
 *  会话对象
 */
@property (nonatomic, strong, readonly) EMConversation *conversation;

/**
 *  当前界面是否在显示
 */
@property (nonatomic,assign,readonly) BOOL isShow;

@property (nonatomic,weak) id<EM_ChatControllerDelegate> delegate;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType config:(EM_ChatUIConfig *)config;

- (void)sendMessage:(EM_ChatMessageModel *)message;

@end

@protocol EM_ChatControllerDelegate <NSObject>

@required

@optional

/**
 *  根据用户名获取昵称
 *
 *  @param chatter 用户名
 *
 *  @return 昵称
 */
- (NSString *)nickNameWithChatter:(NSString *)chatter;

/**
 *  根据用户名获取头像网络地址
 *
 *  @param chatter 用户名
 *
 *  @return 头像网络地址
 */
- (NSString *)avatarWithChatter:(NSString *)chatter;

/**
 *  为要发送的消息添加扩展
 *
 *  @param body 消息内容
 *
 *  @param type 消息类型
 *
 *  @return 扩展
 */
- (EM_ChatMessageExtend *)extendForMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  是否允许发送消息
 *
 *  @param body 消息内容
 *  @param type 消息类型
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldSendMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  自定义动作监听
 *
 *  @param name 自定义动作
 */
- (void)didActionSelectedWithName:(NSString *)name;

@end