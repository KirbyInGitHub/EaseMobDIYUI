//
//  EM+ChatMessageContent.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EM_ChatMessageModel;

@protocol EM_ChatMessageContentDelegate;

@interface EM_ChatMessageContent : UIView

@property (nonatomic,strong) EM_ChatMessageModel *message;

/**
 *  是否需要点击,默认YES
 */
@property (nonatomic, assign) BOOL needTap;

/**
 *  是否需要长按,默认YES
 */
@property (nonatomic, assign) BOOL needLongPress;

/**
 *  是否需要菜单,默认YES
 */
@property (nonatomic, assign) BOOL needMenu;

@end

@protocol EM_ChatMessageContentDelegate <NSObject>

@required

@optional

/**
 *  点击监听
 *
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentTap:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  长按监听
 *
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentLongPress:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  菜单选项监听
 *
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentMenu:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

@end