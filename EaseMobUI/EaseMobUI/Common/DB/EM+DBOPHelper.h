//
//  EM+DBOPHelper.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class FMResultSet;

@interface EM_DBOPHelper : NSObject

+ (long long) insertInto:(NSString *)table WithContent:(NSDictionary *)content UseDB:(FMDatabase *)db;
+ (int) update:(NSString *)table WithContent:(NSDictionary *)content Selection:(NSString *)select SelArgs:(NSArray *)args UseDB:(FMDatabase *)db;
+ (FMResultSet *)query:(NSString *)table Projects:(NSArray *)projects Selection:(NSString *)select SelArgs:(NSArray *)args Order:(NSString *) order UseDB:(FMDatabase *)db;
+ (FMResultSet *)query:(NSString *)table Projects:(NSArray *)projects Selection:(NSString *)select SelArgs:(NSArray *)args Order:(NSString *) order LimitSize:(int) size Offset:(int) offset UseDB:(FMDatabase *)db;
+ (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments UseDB:(FMDatabase *)db;
+ (int) deleteFrom:(NSString *)table Where:(NSString *)where UseDB:(FMDatabase *)db;
+ (int) deleteFrom:(NSString *)table Selection:(NSString *)select SelArgs:(NSArray *)args  UseDB:(FMDatabase *)db;
+ (NSString *) genInSubstringFromArray:(NSArray *) array;

@end