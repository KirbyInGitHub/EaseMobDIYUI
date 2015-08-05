//
//  EM+ChatBase.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBase.h"

@implementation EM_ChatBase

+ (EM_ChatVersion *)currentVersion{
    return nil;
}

+ (NSString *)tableName{
    return nil;
}

+ (NSInteger)tableVersion{
    return 1;
}

+ (NSInteger)fieldCount{
    return 1;
}

+ (NSMutableString *)createSql{
    NSMutableString *createSql = [[NSMutableString alloc]init];
    
    [createSql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [createSql appendString:[self tableName]];
    [createSql appendString:@" ( "];
    
    [createSql appendString:COLUMN_ID];
    [createSql appendString:@" INTEGER PRIMARY KEY AUTOINCREMENT, "];
    
    return createSql;
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [[NSMutableDictionary alloc]init];
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{
    id _id = result[COLUMN_ID];
    if (_id && ![_id isMemberOfClass:[NSNull class]]) {
        self._id = [_id longLongValue];
    }
}

@end