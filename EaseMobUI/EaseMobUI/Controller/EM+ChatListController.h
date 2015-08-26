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

//overwrite
- (void)pulldownLoad;

@end

@protocol EM_ChatListControllerDelegate <NSObject>

@required

@optional

- (void)didSelectedWithConversation:(EMConversation *)conversation;

@end