//
//  EaseMobUIClient.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EM+ChatBuddyTagModel.h"
#import "EM+ChatBuddyGroupModel.h"
#import "EM+ChatBuddyModel.h"

@protocol EM_ChatUserDelegate;
@protocol EM_ChatBuddyDelegate;

extern NSString * const kEMNotificationCallActionIn;
extern NSString * const kEMNotificationCallActionOut;
extern NSString * const kEMNotificationCallShow;
extern NSString * const kEMNotificationCallDismiss;

extern NSString * const kEMCallChatter;
extern NSString * const kEMCallType;

extern NSString * const kEMCallTypeVoice;
extern NSString * const kEMCallTypeVideo;

@interface EaseMobUIClient : NSObject

@property (nonatomic, weak) id<EM_ChatUserDelegate> userDelegate;
@property (nonatomic, weak) id<EM_ChatBuddyDelegate> buddyDelegate;

+ (instancetype)sharedInstance;

+ (BOOL)canRecord;

+ (BOOL)canVideo;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

@end

@protocol EM_ChatUserDelegate <NSObject>

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

@end

@protocol EM_ChatBuddyDelegate <NSObject>

@required

@optional

/**
 *  好友列表 由 EM_ChatBuddyModel 构成
 *  如果好友在某一个分组中请设置EM_ChatBuddyModel 的 group
 *  如果不提供好友列表,默认通过环信API获取好友列表,获取后会调用 - (EM_ChatBuddyModel *)buddyWithChatter:(NSString *)chatter
 *  @return
 */
- (NSArray *)listForChatBuddy;

/**
 *  如果你没有提供自己好友列表,会默认通过环信API获取好友列表
 *  因为环信获取的好友信息中只有用户名(chatter),所以你需要提供好友的其他信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatBuddyModel *)buddyWithChatter:(NSString *)chatter;

/**
 *  黑名单
 *
 *  @return 
 */
- (NSArray *)listForChatBlacklist;

/**
 *  群列表
 *
 *  @return
 */
- (NSArray *)listForChatGroup;

/**
 *  讨论组
 *
 *  @return
 */
- (NSArray *)listForChatRoom;

@end