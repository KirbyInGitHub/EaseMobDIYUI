//
//  EM+ChatMessageState.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageState.h"

@implementation EM_ChatMessageState

+ (EM_ChatVersion *)currentVersion{
    static EM_ChatVersion *_current = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[EM_ChatVersion alloc] init];
        _current.currentCreateSql = [EM_ChatMessageState createSql];
        _current.tableName = [EM_ChatMessageState tableName];
        _current.currentVersion = [EM_ChatMessageState tableVersion];
        _current.lastVersion = [EM_ChatMessageState tableVersion];
        _current.currentFieldCount = [EM_ChatMessageState fieldCount];
        _current.lastFieldCount = [EM_ChatMessageState fieldCount];
        
    });
    return _current;
}

+ (NSString *)tableName{
    return @"EMMessageTable";
}

+ (NSInteger)tableVersion{
    return 1;
}

+ (NSInteger)fieldCount{
    return [super fieldCount] + 4;
}

+ (NSMutableString *)createSql{
    NSMutableString *createSql = [super createSql];
    
    [createSql appendString:MESSAGE_DETAILS_COLUMN_MESSAGE_ID];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:MESSAGE_DETAILS_COLUMN_DETAILS];
    [createSql appendString:@" SMALLINT, "];
    
    [createSql appendString:MESSAGE_DETAILS_COLUMN_BODY_TYPE];
    [createSql appendString:@" SMALLINT, "];
    
    [createSql appendString:MESSAGE_DETAILS_COLUMN_TYPE];
    [createSql appendString:@" SMALLINT )"];
    return createSql;
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];
    
    if (self.messageId) {
        [values setObject:self.messageId forKey:MESSAGE_DETAILS_COLUMN_MESSAGE_ID];
    }
    
    [values setObject:@(self.details) forKey:MESSAGE_DETAILS_COLUMN_DETAILS];
    [values setObject:@(self.messageBodyType) forKey:MESSAGE_DETAILS_COLUMN_BODY_TYPE];
    [values setObject:@(self.messageType) forKey:MESSAGE_DETAILS_COLUMN_TYPE];
    
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{
    [super getFromResultSet:result];
    
    id messageId = result[MESSAGE_DETAILS_COLUMN_MESSAGE_ID];
    if (messageId && ![messageId isMemberOfClass:[NSNull class]]) {
        self.messageId = messageId;
    }
    
    id deteils = result[MESSAGE_DETAILS_COLUMN_DETAILS];
    if (deteils && ![deteils isMemberOfClass:[NSNull class]]) {
        self.details = [deteils boolValue];
    }
    
    id messageBodyType = result[MESSAGE_DETAILS_COLUMN_BODY_TYPE];
    if (messageBodyType && ![messageBodyType isMemberOfClass:[NSNull class]]) {
        self.messageBodyType = [messageBodyType integerValue];
    }
    
    id messageType = result[MESSAGE_DETAILS_COLUMN_TYPE];
    if (messageType && ![messageType isMemberOfClass:[NSNull class]]) {
        self.messageType = [messageType integerValue];
    }
}

@end