//
//  EM+ChatBase.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLUMN_ID                   (@"_id")

@interface EM_ChatBase : NSObject

@property (nonatomic,assign) long long _id;

+ (EM_ChatBase *)currentVersion;
+ (NSString *)tableName;
+ (NSInteger)tableVersion;
+ (NSInteger)fieldCount;
+ (NSMutableString *)createSql;

- (NSMutableDictionary *)getContentValues;
- (void)getFromResultSet:(NSDictionary *)result;

@end
