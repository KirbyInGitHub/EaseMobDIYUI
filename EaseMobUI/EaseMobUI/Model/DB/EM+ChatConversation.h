//
//  EM+ChatConversation.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBase.h"

#define CONVERSATION_COLUMN_CHATTER (@"conversationChatter")
#define CONVERSATION_COLUMN_EDITOR  (@"converstionEditor")
#define CONVERSATION_COLUMN_TYPE    (@"converstionType")

@interface EM_ChatConversation : EM_ChatBase

@property (nonatomic,copy) NSString *conversationChatter;
@property (nonatomic,copy) NSString *conversationEditor;
@property (nonatomic,assign) NSInteger conversationType;

@end