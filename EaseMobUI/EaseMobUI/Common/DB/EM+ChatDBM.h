//
//  EM+ChatDBM.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EM+ChatMessageState.h"
#import "EM+ChatConversation.h"
#import "EM+ChatLatelyEmoji.h"

@interface EM_ChatDBM : NSObject

#pragma mark - MessageDetails
+ (BOOL)insertMessageDetails:(EM_ChatMessageState *)state;
+ (BOOL)deleteMessageDetails:(EM_ChatMessageState *)state;
+ (BOOL)queryMessageDetails:(EM_ChatMessageState *)state;
+ (BOOL)updateMessageDetails:(EM_ChatMessageState *)state;

#pragma mark - Conversation
+ (BOOL)insertConversation:(EM_ChatConversation *)conversation;
+ (BOOL)deleteConversation:(EM_ChatConversation *)conversation;
+ (EM_ChatConversation*)queryConversation:(NSString *)chatter;
+ (BOOL)updateConversation:(EM_ChatConversation *)conversation;

#pragma mark - Emoji
+ (BOOL)insertEmoji:(EM_ChatLatelyEmoji *)emoji;
+ (BOOL)deleteEmoji:(EM_ChatLatelyEmoji *)emoji;
+ (NSArray *)queryEmoji;
+ (BOOL)updateEmoji:(EM_ChatLatelyEmoji *)emoji;

@end