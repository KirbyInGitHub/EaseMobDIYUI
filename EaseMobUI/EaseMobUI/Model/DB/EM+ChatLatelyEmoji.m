//
//  EM+ChatLatelyEmoji.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatLatelyEmoji.h"

@implementation EM_ChatLatelyEmoji

+ (EM_ChatVersion *)currentVersion{
    static EM_ChatVersion *_current = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[EM_ChatVersion alloc] init];
        _current.currentCreateSql = [EM_ChatLatelyEmoji createSql];
        _current.tableName = [EM_ChatLatelyEmoji tableName];
        _current.currentVersion = [EM_ChatLatelyEmoji tableVersion];
        _current.lastVersion = [EM_ChatLatelyEmoji tableVersion];
        _current.currentFieldCount = [EM_ChatLatelyEmoji fieldCount];
        _current.lastFieldCount = [EM_ChatLatelyEmoji fieldCount];
        
    });
    return _current;
}

+ (NSString *)tableName{
    return @"EMEmojiTable";
}

+ (NSInteger)tableVersion{
    return 1;
}

+ (NSInteger)fieldCount{
    return [super fieldCount] + 3;
}

+ (NSMutableString *)createSql{
    NSMutableString *createSql = [super createSql];
    
    [createSql appendString:EMOJI_COLUMN_EMOJI];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:EMOJI_COLUMN_CALCULATE];
    [createSql appendString:@" INTEGET, "];
    
    [createSql appendString:EMOJI_COLUMN_USE_TIME];
    [createSql appendString:@" DOUBLE )"];
    return createSql;
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];
    
    if (self.emoji) {
        [values setObject:self.emoji forKey:EMOJI_COLUMN_EMOJI];
    }
    
    [values setObject:@(self.calculate) forKey:EMOJI_COLUMN_CALCULATE];
    [values setObject:@(self.useTime) forKey:EMOJI_COLUMN_USE_TIME];
    
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{
    [super getFromResultSet:result];
    
    id emoji = result[EMOJI_COLUMN_EMOJI];
    if (emoji && ![emoji isMemberOfClass:[NSNull class]]) {
        self.emoji = emoji;
    }
    
    id calculate = result[EMOJI_COLUMN_CALCULATE];
    if (calculate && ![calculate isMemberOfClass:[NSNull class]]) {
        self.calculate = [calculate integerValue];
    }
    
    id useTime = result[EMOJI_COLUMN_USE_TIME];
    if (useTime && ![useTime isMemberOfClass:[NSNull class]]) {
        self.useTime = [useTime doubleValue];
    }
}

@end