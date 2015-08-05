//
//  EM+ChatDBM.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatDBM.h"
#import "EM+ChatDB.h"
#import "EM+DBOPHelper.h"
#import "FMDB.h"

#import "EM+ChatConversation.h"
#import "EM+ChatLatelyEmoji.h"

@implementation EM_ChatDBM

#pragma mark - Conversation
+ (BOOL)insertConversation:(EM_ChatConversation *)conversation{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [EM_DBOPHelper insertInto:[EM_ChatConversation tableName] WithContent:[conversation getContentValues] UseDB:db];
    }];
    
    return ret;
}

+ (BOOL)deleteConversation:(EM_ChatConversation *)conversation{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString *selection = [[NSMutableString alloc]init];
        [selection appendString:CONVERSATION_COLUMN_CHATTER];
        [selection appendString:@" = ?"];
        
        NSArray *args = @[conversation.conversationChatter];
        
        ret = [EM_DBOPHelper deleteFrom:[EM_ChatConversation tableName] Selection:selection SelArgs:args UseDB:db];
    }];
    
    return ret;
}

+ (EM_ChatConversation *)queryConversation:(NSString *)chatter{
    __block EM_ChatConversation *ret = nil;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString *selection = [[NSMutableString alloc]init];
        
        [selection appendString:CONVERSATION_COLUMN_CHATTER];
        [selection appendString:@" = ?"];
        
        NSArray *args = @[chatter];
        
        FMResultSet *result = [EM_DBOPHelper query:[EM_ChatConversation tableName] Projects:nil Selection:selection SelArgs:args Order:nil UseDB:db];
        if ([result next]) {
            ret = [[EM_ChatConversation alloc]init];
            [ret getFromResultSet:result.resultDictionary];
        }
        [result close];
    }];
    
    return ret;
}

+ (BOOL)updateConversation:(EM_ChatConversation *)conversation{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary *content = @{CONVERSATION_COLUMN_EDITOR:conversation.conversationEditor};
        
        NSMutableString *selection = [[NSMutableString alloc]init];
        [selection appendString:CONVERSATION_COLUMN_CHATTER];
        [selection appendString:@" = ?"];
        
        NSArray *args = @[conversation.conversationChatter];
        
        ret = [EM_DBOPHelper update:[EM_ChatConversation tableName] WithContent:content Selection:selection SelArgs:args UseDB:db];
        
    }];
    
    return ret;
}

#pragma mark - Emoji
+ (BOOL)insertEmoji:(EM_ChatLatelyEmoji *)emoji{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        ret = [EM_DBOPHelper insertInto:[EM_ChatLatelyEmoji tableName] WithContent:[emoji getContentValues] UseDB:db];
    }];
    
    return ret;
}

+ (BOOL)deleteEmoji:(EM_ChatLatelyEmoji *)emoji{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSMutableString *selection = [[NSMutableString alloc]init];
        [selection appendString:EMOJI_COLUMN_EMOJI];
        [selection appendString:@" = ?"];
        
        NSArray *args = @[emoji.emoji];
        
        ret = [EM_DBOPHelper deleteFrom:[EM_ChatLatelyEmoji tableName] Selection:selection SelArgs:args UseDB:db];
    }];
    
    return ret;
}

+ (NSArray *)queryEmoji{
    __block NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    NSString *order = [NSString stringWithFormat:@"%@ %@",EMOJI_COLUMN_USE_TIME,@"DESC"];
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *result = [EM_DBOPHelper query:[EM_ChatLatelyEmoji tableName] Projects:nil Selection:nil SelArgs:nil Order:order LimitSize:46 Offset:0 UseDB:db];
        while ([result next]) {
            EM_ChatLatelyEmoji *emoji = [[EM_ChatLatelyEmoji alloc]init];
            [emoji getFromResultSet:result.resultDictionary];
            [ret addObject:emoji];
        }
        [result close];
    }];
    
    return ret;
}

+ (BOOL)updateEmoji:(EM_ChatLatelyEmoji *)emoji{
    __block BOOL ret = NO;
    
    [[EM_ChatDB shared] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSDictionary *content = @{EMOJI_COLUMN_CALCULATE:@(emoji.calculate),EMOJI_COLUMN_USE_TIME:@(emoji.useTime)};
        
        NSMutableString *selection = [[NSMutableString alloc]init];
        [selection appendString:EMOJI_COLUMN_EMOJI];
        [selection appendString:@" = ?"];
        
        NSArray *args = @[emoji.emoji];
        
        ret = [EM_DBOPHelper update:[EM_ChatLatelyEmoji tableName] WithContent:content Selection:selection SelArgs:args UseDB:db];
        
    }];
    
    return ret;
}

@end