//
//  EM+ChatUserDelegate.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

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