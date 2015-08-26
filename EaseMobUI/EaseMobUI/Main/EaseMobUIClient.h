//
//  EaseMobUIClient.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EM+ChatUser.h"
#import "EM+ChatBuddy.h"
#import "EM+ChatGroup.h"
#import "EM+ChatRoom.h"

@protocol EM_ChatUserDelegate;
@protocol EM_ChatOppositeDelegate;

extern NSString * const kEMNotificationCallActionIn;
extern NSString * const kEMNotificationCallActionOut;
extern NSString * const kEMNotificationCallShow;
extern NSString * const kEMNotificationCallDismiss;

extern NSString * const kEMCallChatter;
extern NSString * const kEMCallType;

extern NSString * const kEMCallTypeVoice;
extern NSString * const kEMCallTypeVideo;

@interface EaseMobUIClient : NSObject

/**
 *  登录用户信息代理
 */
@property (nonatomic, weak) id<EM_ChatUserDelegate> userDelegate;

/**
 *  聊天数据代理
 */
@property (nonatomic, weak) id<EM_ChatOppositeDelegate> oppositeDelegate;



+ (instancetype)sharedInstance;

+ (BOOL)canRecord;

+ (BOOL)canVideo;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

@end

@protocol EM_ChatUserDelegate <NSObject>

@required

- (EM_ChatUser *)userForEMChat;

@optional

@end

@protocol EM_ChatOppositeDelegate <NSObject>

@required

/**
 *  根据chatter返回好友信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatGroup *)groupInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回群中好友信息
 *
 *  @param chatter
 *  @param group
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inGroup:(EM_ChatGroup *)group;

/**
 *  根据chatter返回讨论组信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatRoom *)roomInfoWithChatter:(NSString *)chatter;

/**
 *  根据chatter返回讨论组成员信息
 *
 *  @param chatter
 *  @param room
 *
 *  @return 
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inRoom:(EM_ChatRoom *)room;

@optional

@end