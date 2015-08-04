//
//  EM+ChatDB.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatDB.h"
#import "EM+Common.h"

@implementation EM_ChatDB{
    FMDatabaseQueue * _dbQueue;
}

+ (instancetype)shared{
    static EM_ChatDB *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EM_ChatDB alloc] init:EM_DB_NAME WithVersion:EM_DB_VERSION];
    });
    return _sharedClient;
}

- (instancetype)init:(NSString *)dbName WithVersion:(NSInteger)dbVersion{
    self = [super init];
    if (self) {
        _dbName = dbName;
        _dbVersion = dbVersion;
    }
    return self;
}

- (NSString *)dbPath{
    NSString *docPath = kDocumentFolder;
    NSString *dbPath = [docPath stringByAppendingString:[NSString stringWithFormat:@"/%@", _dbName]];
    return dbPath;
}

- (BOOL)connect{
    
    NSLog(@"DB_PATH - %@",self.dbPath);
    if (!_dbQueue) {
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    
    __block BOOL ret = YES;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
#ifdef DEBUG
        db.traceExecution = YES;
#endif
        [self onCreate:db];
        
        NSArray *versionArray = @[[EM_ChatVersion currentVersion],[EM_ChatConversation currentVersion],[EM_ChatLatelyEmoji currentVersion]];
        [self checkVersionWithDB:db version:versionArray Roolback:rollback];
        if ([db hadError]) {
            ret = NO;
            NSLog(@"Create database failed! reason: %@", [db lastErrorMessage]);
        }
    }];
    return ret;
}

- (void)onCreate:(FMDatabase *)db{
    
    NSString *sql = [EM_ChatVersion createSql];
    NSLog(@"Create Version SQL - %@",sql);
    BOOL create = [db executeUpdate:[EM_ChatVersion createSql]];
    NSLog(@"Create %@ : %@",[EM_ChatVersion tableName],create ? @"Success":@"Failure");
    
    sql = [EM_ChatConversation createSql];
    NSLog(@"Create Conversation SQL - %@",sql);
    create = [db executeUpdate:sql];
    NSLog(@"Create %@ : %@ %@",[EM_ChatConversation tableName],create ? @"Success":@"Failure",[EM_ChatConversation createSql]);
    
    sql = [EM_ChatLatelyEmoji createSql];
    create = [db executeUpdate:sql];
    NSLog(@"Create %@ Table : %@ %@",[EM_ChatLatelyEmoji tableName],create ? @"Success":@"Failure",[EM_ChatLatelyEmoji createSql]);
    
}

- (void)checkVersionWithDB:(FMDatabase *)db version:(NSArray *)versionArray Roolback:(BOOL *)rollback{
    
    for (int i = 0; i < versionArray.count; i++) {
        EM_ChatVersion *newVersion = versionArray[i];
        NSString *selection = [NSString stringWithFormat:@"%@ = '%@'",VERSION_COLUMN_TABLE_NAME,newVersion.tableName];
        FMResultSet *result = [EM_DBOPHelper query:[EM_ChatVersion tableName] Projects:nil Selection:selection SelArgs:nil Order:nil UseDB:db];
        
        EM_ChatVersion *oldVersion;
        if ([result next]) {
            oldVersion = [[EM_ChatVersion alloc]init];
            [oldVersion getFromResultSet:result.resultDictionary];
        }
        [result close];
        
        if (oldVersion) {
            if (newVersion.currentVersion != oldVersion.currentVersion) {
                BOOL upgrade = [self onUpgrade:db from:oldVersion to:newVersion];
                if (!upgrade) {
                    *rollback = YES;
                    return;
                }
            }else{
                NSLog(@"%@ table version is no change",newVersion.tableName);
            }
        }else{
            [EM_DBOPHelper insertInto:[EM_ChatVersion tableName] WithContent:[newVersion getContentValues] UseDB:db];
            NSLog(@"第一次创建版本");
        }
    }
}

- (BOOL)onUpgrade:(FMDatabase *)db from:(EM_ChatVersion *)oldVersion to:(EM_ChatVersion *)newVersion{
    
    FMResultSet *result = [EM_DBOPHelper query:oldVersion.tableName Projects:nil Selection:nil SelArgs:nil Order:nil UseDB:db];
    NSMutableArray *data = [[NSMutableArray alloc]init];
    while ([result next]) {
        [data addObject:result.resultDictionary];
    }
    [result close];
    
    BOOL drop = [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE %@",oldVersion.tableName]];
    if (drop) {
        BOOL create = [db executeUpdate:newVersion.currentCreateSql];
        if (create) {
            for (int i = 0; i < data.count; i++) {
                NSDictionary *values = data[i];
                [EM_DBOPHelper insertInto:newVersion.tableName WithContent:values UseDB:db];
            }
            newVersion.lastVersion = oldVersion.currentVersion;
            newVersion.lastFieldCount = oldVersion.currentFieldCount;
            newVersion.lastCreateSql = oldVersion.currentCreateSql;
            
            NSString *selection = [NSString stringWithFormat:@"%@ = '%@'",VERSION_COLUMN_TABLE_NAME,newVersion.tableName];
            [EM_DBOPHelper update:[EM_ChatVersion tableName] WithContent:[newVersion getContentValues] Selection:selection SelArgs:nil UseDB:db];
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    
    return YES;
}

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block {
    [_dbQueue inTransaction:block];
}


- (void)inDatabase:(void (^)(FMDatabase *db))block {
    [_dbQueue inDatabase:block];
}

- (void)close{
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
}

- (BOOL)remove {
    NSString *dbPath = self.dbPath;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    return [fileManager removeItemAtPath:dbPath error:&error];
}

@end