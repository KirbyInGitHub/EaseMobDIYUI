//
//  EM+ChatBuddyTagModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@class UIFont;

/**
 *  默认tag 新朋友
 */
extern NSString * const kEMChatBuddyTagNameNewBuddy;

/**
 *  默认tag 特别关心
 */
extern NSString * const kEMChatBuddyTagNameCarefor;

/**
 *  默认tag 群组
 */
extern NSString * const kEMChatBuddyTagNameGroup;

/**
 *  默认tag 黑名单
 */
extern NSString * const kEMChatBuddyTagNameBlacklist;


@interface EM_ChatBuddyTagModel : NSObject

@property (nonatomic, copy) NSString *title;

/**
 *  唯一标示
 */
@property (nonatomic, copy) NSString *name;

/**
 *  是否显示tag
 */
@property (nonatomic, assign) BOOL show;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightImage;

@property (nonatomic, strong) UIFont *iconFont;
@property (nonatomic, copy) NSString *iconText;

+ (NSArray *)defaultTags;
+ (EM_ChatBuddyTagModel *)defaultTagWithNewBuddy;
+ (EM_ChatBuddyTagModel *)defaultTagWithCarefor;
+ (EM_ChatBuddyTagModel *)defaultTagWithGroup;
+ (EM_ChatBuddyTagModel *)defaultTagWithBlacklist;

@end