//
//  EM+ChatListController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseController.h"
@class EMConversation;

@protocol EM_ChatListControllerDelegate;

@interface EM_ChatListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatListControllerDelegate> delegate;

/**
 *  重新加载会话
 */
- (void)reloadData;

/**
 *  开始下拉刷新
 */
- (void)startRefresh;

/**
 *  结束下拉刷新
 */
- (void)endRefresh;

@end

@protocol EM_ChatListControllerDelegate <NSObject>

@required

@optional

/**
 *  选中某一会话
 *
 *  @param conversation
 */
- (void)didSelectedWithConversation:(EMConversation *)conversation;

/**
 *  开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  结束下拉刷新
 */
- (void)didEndRefresh;

@end