//
//  EaseMobUIClient.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EM_ChatUserDelegate;

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