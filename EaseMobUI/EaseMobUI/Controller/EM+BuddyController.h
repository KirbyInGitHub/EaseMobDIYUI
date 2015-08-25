//
//  EM+FriendsController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
@class EM_ChatBuddyTagModel;
@class EM_ChatBuddyGroupModel;
@class EM_ChatBuddyModel;

@protocol EM_ChatBuddyControllerDelegate;

@interface EM_BuddyController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatBuddyControllerDelegate> delegate;

@end

@protocol EM_ChatBuddyControllerDelegate <NSObject>

@required

@optional
/**
 *  用户自定义标签
 *  由EM_ChatBuddyTagModel构成
 *  除了自定义外还有四个默认tag,如果需要请在NSArray中返回
 *  kEMChatBuddyTagNameNewBuddy;新朋友
 *  kEMChatBuddyTagNameCarefor;特别关心
 *  kEMChatBuddyTagNameGroup;群组
 *  kEMChatBuddyTagNameBlacklist;黑名单
 *  @return
 */
- (NSArray *)tagsForChatBuddy;

/**
 *  用户自定义分组,未设置分组的好友将默认在“我的好友”分组中
 *  ,由EM_ChatBuddyGroupModel构成
 *  @return
 */
- (NSArray *)groupsForChatBuddy;

/**
 *  点击Tag
 *
 *  @param tag
 */
- (void)didSelectedWithTag:(EM_ChatBuddyTagModel *)tag;

/**
 *  点击好友
 *  如果不实现该方法,则默认会push EM_ChatController
 *  @param buddy 
 */
- (void)didSelectedWithBuddy:(EM_ChatBuddyModel *)buddy;

@end