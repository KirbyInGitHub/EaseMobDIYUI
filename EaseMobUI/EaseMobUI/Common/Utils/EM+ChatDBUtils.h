//
//  EM+ChatDBUtils.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/7.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EM_ChatConversation;
@class EM_ChatEmoji;

@interface EM_ChatDBUtils : NSObject

+ (instancetype)shared;
- (EM_ChatConversation *)insertNewConversation;
- (void)deleteConversationWithChatter:(EM_ChatConversation *)conversation;
- (EM_ChatConversation *)queryConversationWithChatter:(NSString *)chatter;

- (EM_ChatEmoji *)insertNewEmoji;
- (void)deleteEmoji:(EM_ChatEmoji *)emoji;
- (NSArray *)queryEmoji;
- (EM_ChatEmoji *)queryEmoji:(NSString *)emoji;

- (void)processPendingChangesChat;
- (BOOL)saveChat;

@end