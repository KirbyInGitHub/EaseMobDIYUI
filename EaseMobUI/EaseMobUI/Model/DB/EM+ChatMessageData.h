//
//  EM+ChatMessageState.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

#define MESSAGE_DETAILS_COLUMN_DETAILS          (@"details")
#define MESSAGE_DETAILS_COLUMN_CHECKING         (@"checking")
#define MESSAGE_DETAILS_COLUMN_COLLECTED        (@"collected")

@interface EM_ChatMessageData : NSObject

@property (nonatomic,strong) EMMessage *message;

@property (nonatomic,assign) BOOL details;
@property (nonatomic,assign) BOOL checking;
@property (nonatomic,assign) BOOL collected;

- (NSMutableDictionary *)getContentValues;
- (void)getFromResultSet:(NSDictionary *)result;

@end