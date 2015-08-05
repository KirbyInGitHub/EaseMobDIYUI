//
//  EM+ChatDB.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

#define EM_DB_NAME (@"EM_Chat_UI.db")
#define EM_DB_VERSION   (1)

@interface EM_ChatDB : NSObject

@property (nonatomic,copy,readonly) NSString *dbName;
@property (nonatomic,assign,readonly) NSInteger dbVersion;
@property (nonatomic,copy,readonly) NSString *dbPath;

+ (instancetype)shared;

- (instancetype )init:(NSString *) dbName WithVersion:(NSInteger) dbVersion;

- (BOOL)connect;

- (void)inDatabase:(void (^)(FMDatabase *db))block;

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

- (void)close;

- (BOOL)remove;

@end