//
//  EM+ChatMessageState.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageData.h"

@implementation EM_ChatMessageData


- (void)setDetails:(BOOL)details{
    _details = details;
}

- (void)setChecking:(BOOL)checking{
    _checking = checking;
}

- (void)setCollected:(BOOL)collected{
    _collected = collected;
    
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [[NSMutableDictionary alloc]init];
    [values setObject:@(self.details) forKey:MESSAGE_DETAILS_COLUMN_DETAILS];
    [values setObject:@(self.checking) forKey:MESSAGE_DETAILS_COLUMN_CHECKING];
    [values setObject:@(self.collected) forKey:MESSAGE_DETAILS_COLUMN_COLLECTED];
    
    return values;
}

- (void)getFromResultSet:(NSDictionary *)result{

    id deteils = result[MESSAGE_DETAILS_COLUMN_DETAILS];
    if (deteils && ![deteils isMemberOfClass:[NSNull class]]) {
        self.details = [deteils boolValue];
    }
    
    id checking = result[MESSAGE_DETAILS_COLUMN_CHECKING];
    if (checking && ![checking isMemberOfClass:[NSNull class]]) {
        self.checking = [checking boolValue];
    }
    
    id collected = result[MESSAGE_DETAILS_COLUMN_COLLECTED];
    if (collected && ![collected isMemberOfClass:[NSNull class]]) {
        self.collected = [collected boolValue];
    }
}

@end