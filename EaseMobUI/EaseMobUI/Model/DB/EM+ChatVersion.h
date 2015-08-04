//
//  EM+ChatVersion.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBase.h"


#define VERSION_COLUMN_TABLE_NAME           (@"tableName")
#define VERSION_COLUMN_CURRENT_VERSION      (@"currentVersion")
#define VERSION_COLUMN_LAST_VERSION         (@"lastVersion")
#define VERSION_COLUMN_CURRENT_FIELD_COUNT  (@"currentFieldCount")
#define VERSION_COLUMN_LAST_FIELD_COUNT     (@"lastFieldCount")
#define VERSION_COLUMN_CURRENT_CREATE_SQL   (@"currentCreateSql")
#define VERSION_COLUMN_LAST_CREATE_SQL      (@"lastCreateSql")

@interface EM_ChatVersion : EM_ChatBase

@property (nonatomic,copy) NSString *tableName;
@property (nonatomic,assign) NSInteger currentVersion;
@property (nonatomic,assign) NSInteger lastVersion;
@property (nonatomic,assign) NSInteger currentFieldCount;
@property (nonatomic,assign) NSInteger lastFieldCount;
@property (nonatomic,copy) NSString *currentCreateSql;
@property (nonatomic,copy) NSString *lastCreateSql;

@end