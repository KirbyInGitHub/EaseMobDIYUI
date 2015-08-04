//
//  EM+ChatConversation.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatConversation.h"

@implementation EM_ChatConversation

+ (EM_ChatVersion *)currentVersion{
    static EM_ChatVersion *_current = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[EM_ChatVersion alloc] init];
        _current.currentCreateSql = [EM_ChatConversation createSql];
        _current.tableName = [EM_ChatConversation tableName];
        _current.currentVersion = [EM_ChatConversation tableVersion];
        _current.lastVersion = [EM_ChatConversation tableVersion];
        _current.currentFieldCount = [EM_ChatConversation fieldCount];
        _current.lastFieldCount = [EM_ChatConversation fieldCount];
        
    });
    return _current;
}

+ (NSString *)tableName{
    return @"EMConversationTable";
}

+ (NSInteger)tableVersion{
    return 1;
}

+ (NSInteger)fieldCount{
    return [super fieldCount] + 3;
}

+ (NSMutableString *)createSql{
    NSMutableString *createSql = [super createSql];
    
    [createSql appendString:CONVERSATION_COLUMN_CHATTER];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:CONVERSATION_COLUMN_EDITOR];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:CONVERSATION_COLUMN_TYPE];
    [createSql appendString:@" SMALLINT )"];
    return createSql;
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];
    
    if (self.conversationChatter) {
        [values setObject:self.conversationChatter forKey:CONVERSATION_COLUMN_CHATTER];
    }
    if (self.conversationEditor) {
        [values setObject:self.conversationEditor forKey:CONVERSATION_COLUMN_EDITOR];
    }
    [values setObject:@(self.conversationType) forKey:CONVERSATION_COLUMN_TYPE];
    
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{
    [super getFromResultSet:result];
    
    id chatter = result[CONVERSATION_COLUMN_CHATTER];
    if (chatter && ![chatter isMemberOfClass:[NSNull class]]) {
        self.conversationChatter = chatter;
    }
    
    id editor = result[CONVERSATION_COLUMN_EDITOR];
    if (editor && ![editor isMemberOfClass:[NSNull class]]) {
        self.conversationEditor = editor;
    }
    
    id type = result[CONVERSATION_COLUMN_TYPE];
    if (type && ![type isMemberOfClass:[NSNull class]]) {
        self.conversationType = [type integerValue];
    }
}

@end