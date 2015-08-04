//
//  EM+ChatVersion.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatVersion.h"

@implementation EM_ChatVersion

+ (EM_ChatVersion *)currentVersion{
    static EM_ChatVersion *_current = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[EM_ChatVersion alloc] init];
        _current.currentCreateSql = [EM_ChatVersion createSql];
        _current.tableName = [EM_ChatVersion tableName];
        _current.currentVersion = [EM_ChatVersion tableVersion];
        _current.lastVersion = [EM_ChatVersion tableVersion];
        _current.currentFieldCount = [EM_ChatVersion fieldCount];
        _current.lastFieldCount = [EM_ChatVersion fieldCount];
        
    });
    return _current;
}

+ (NSString *)tableName{
    return @"EMVersionTable";
}

+ (NSInteger)tableVersion{
    return 1;
}

+ (NSInteger)fieldCount{
    return [super fieldCount] + 7;
}

+ (NSMutableString *)createSql{
    NSMutableString *createSql = [super createSql];

    [createSql appendString:VERSION_COLUMN_TABLE_NAME];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:VERSION_COLUMN_CURRENT_CREATE_SQL];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:VERSION_COLUMN_LAST_CREATE_SQL];
    [createSql appendString:@" VARCHAR, "];
    
    [createSql appendString:VERSION_COLUMN_CURRENT_VERSION];
    [createSql appendString:@" INTEGET, "];
    
    [createSql appendString:VERSION_COLUMN_LAST_VERSION];
    [createSql appendString:@" INTEGET, "];
    
    [createSql appendString:VERSION_COLUMN_CURRENT_FIELD_COUNT];
    [createSql appendString:@" INTEGET, "];
    
    [createSql appendString:VERSION_COLUMN_LAST_FIELD_COUNT];
    [createSql appendString:@" INTEGET )"];
    
    return createSql;
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];;
    
    if (self.tableName) {
        [values setObject:self.tableName forKey:VERSION_COLUMN_TABLE_NAME];
    }
    
    if (self.currentCreateSql) {
        [values setObject:self.currentCreateSql forKey:VERSION_COLUMN_CURRENT_CREATE_SQL];
    }
    
    if (self.lastCreateSql) {
        [values setObject:self.lastCreateSql forKey:VERSION_COLUMN_LAST_CREATE_SQL];
    }
    
    [values setObject:@(self.currentVersion) forKey:VERSION_COLUMN_CURRENT_VERSION];
    [values setObject:@(self.lastVersion) forKey:VERSION_COLUMN_LAST_VERSION];
    [values setObject:@(self.currentFieldCount) forKey:VERSION_COLUMN_CURRENT_FIELD_COUNT];
    [values setObject:@(self.lastFieldCount) forKey:VERSION_COLUMN_LAST_FIELD_COUNT];
    
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{
    
    [super getFromResultSet:result];
    
    id tableName = result[VERSION_COLUMN_TABLE_NAME];
    if (tableName && ![tableName isMemberOfClass:[NSNull class]]) {
        self.tableName = tableName;
    }
    
    id currentVersion = result[VERSION_COLUMN_CURRENT_VERSION];
    if (currentVersion && ![currentVersion isMemberOfClass:[NSNull class]]) {
        self.currentVersion = [currentVersion integerValue];
    }
    
    id lastVersion = result[VERSION_COLUMN_LAST_VERSION];
    if (lastVersion && ![lastVersion isMemberOfClass:[NSNull class]]) {
        self.lastVersion = [lastVersion integerValue];
    }
    
    id currentFieldCount = result[VERSION_COLUMN_CURRENT_FIELD_COUNT];
    if (currentFieldCount && ![currentFieldCount isMemberOfClass:[NSNull class]]) {
        self.currentFieldCount = [currentFieldCount integerValue];
    }
    
    id lastFieldCount = result[VERSION_COLUMN_LAST_FIELD_COUNT];
    if (lastFieldCount && ![lastFieldCount isMemberOfClass:[NSNull class]]) {
        self.lastFieldCount = [lastFieldCount integerValue];
    }
    
    id currentCreateSql = result[VERSION_COLUMN_CURRENT_CREATE_SQL];
    if (currentCreateSql && ![currentCreateSql isMemberOfClass:[NSNull class]]) {
        self.currentCreateSql = currentCreateSql;
    }
    
    id lastCreateSql = result[VERSION_COLUMN_LAST_CREATE_SQL];
    if (lastCreateSql && ![lastCreateSql isMemberOfClass:[NSNull class]]) {
        self.lastCreateSql = lastCreateSql;
    }
}

@end