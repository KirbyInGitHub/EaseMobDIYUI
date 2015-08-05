//
//  EM+DBOPHelper.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+DBOPHelper.h"
#import "FMDB.h"

@implementation EM_DBOPHelper

+ (long long) insertInto:(NSString *)table WithContent:(NSDictionary *)content UseDB:(FMDatabase *)db{
    NSMutableString * sql = [NSMutableString stringWithFormat:@"INSERT INTO %@ ", table];
    NSMutableString * colums = [[NSMutableString alloc]init];
    NSMutableString * values = [[NSMutableString alloc]init];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    
    for (id key in content) {
        [colums appendFormat:@"%@,", key];
        [values appendString:@"?,"];
        [args addObject:[content objectForKey:key]];
    }
    
    NSRange rangCol;
    rangCol.location = colums.length - 1;
    rangCol.length = 1;
    [colums deleteCharactersInRange:rangCol];
    
    NSRange rangValue;
    rangValue.location = values.length - 1;
    rangValue.length = 1;
    [values deleteCharactersInRange:rangValue];
    
    [ sql appendFormat:@"(%@) VALUES(%@)", colums, values ];
    if ([db executeUpdate:sql withArgumentsInArray:args]) {
        return  [db lastInsertRowId];
    }
    if ([db hadError]) {
        NSLog(@"insert failed! reason: %@", [db lastErrorMessage]);
    }
    return 0;
}

+ (int) update:(NSString *)table WithContent:(NSDictionary *)content Selection:(NSString *)select SelArgs:(NSArray *)args  UseDB:(FMDatabase *)db{
    NSMutableString * sql = [NSMutableString stringWithFormat:@"UPDATE  %@ SET ", table];
    NSMutableString * sets = [[NSMutableString alloc]init];
    NSMutableArray *tempargs = [[NSMutableArray alloc] init];
    
    for (id key in content) {
        [sets appendFormat:@"%@ = ?,", key];
        [tempargs addObject:[content objectForKey:key]];
    }
    
    NSRange rangCol;
    rangCol.location = sets.length - 1;
    rangCol.length = 1;
    [sets deleteCharactersInRange:rangCol];
    
    [tempargs addObjectsFromArray:args];
    if(select != nil){
        [ sql appendFormat:@" %@  WHERE %@", sets, select ];
    }else{
        [ sql appendFormat:@" %@ ", sets ];
    }
    
    if ([db executeUpdate:sql withArgumentsInArray:tempargs]) {
        return [db changes];
    }
    return 0 ;
}

+ (FMResultSet *)query:(NSString *)table Projects:(NSArray *)projects Selection:(NSString *)select SelArgs:(NSArray *)args Order:(NSString *) order  UseDB:(FMDatabase *)db{
    return [self query:table Projects:projects Selection:select SelArgs:args Order:order LimitSize:0 Offset:0 UseDB:db];
}

+ (FMResultSet *)query:(NSString *)table Projects:(NSArray *)projects Selection:(NSString *)select SelArgs:(NSArray *)args Order:(NSString *) order LimitSize:(int) size Offset:(int) offset  UseDB:(FMDatabase *)db {
    
    NSMutableString * sqlQuery = [NSMutableString stringWithFormat:@"SELECT "];
    
    if(projects != nil){
        NSMutableString *prj = [[NSMutableString alloc] init];
        
        for (id key in projects) {
            [prj appendFormat:@"%@,", key];
        }
        
        NSRange rangCol;
        rangCol.location = prj.length - 1;
        rangCol.length = 1;
        [prj deleteCharactersInRange:rangCol];
        
        [sqlQuery appendFormat:@" %@ ", prj];
    }else{
        [sqlQuery appendString:@" * "];
    }
    
    [sqlQuery appendFormat:@" FROM %@ ", table ];
    if(select != nil){
        [sqlQuery appendFormat:@" WHERE %@ ", select ];
    }
    
    if(order != nil){
        [sqlQuery appendFormat:@" ORDER BY %@ ", order];
    }
    
    if (size != 0) {
        [sqlQuery appendFormat:@" LIMIT %d ", size];
        if (offset != 0) {
            [sqlQuery appendFormat:@" OFFSET %d ", offset];
        }
    }
    
    FMResultSet *rs = [db executeQuery:sqlQuery withArgumentsInArray:args];
    return rs;
}

+ (int) deleteFrom:(NSString *)table Selection:(NSString *)select SelArgs:(NSArray *)args  UseDB:(FMDatabase *)db{
    NSMutableString * sql = [NSMutableString stringWithFormat:@"DELETE FROM  %@  ", table];
    
    if (select != nil) {
        [sql appendFormat:@" WHERE %@ ", select ];
    }
    
    if ([db executeUpdate:sql withArgumentsInArray:args]) {
        return [db changes];
    }
    return 0 ;
}

+ (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments  UseDB:(FMDatabase *)db{
    return [db executeQuery:sql withArgumentsInArray:arguments];
}

+ (int) deleteFrom:(NSString *)table Where:(NSString *)where  UseDB:(FMDatabase *)db{
    return [self deleteFrom:table Selection:where SelArgs:nil UseDB:db];
}

+ (NSString *) genInSubstringFromArray:(NSArray *) array {
    NSMutableString *names = [NSMutableString string];
    [names appendString:@"("];
    for (int i = 0; i < array.count; i++) {
        [names appendFormat:@"'%@'", array[i] ];
        if (i < array.count - 1) {
            [names appendString:@","];
        }
    }
    [names appendString:@")"];
    
    return  names;
}

@end