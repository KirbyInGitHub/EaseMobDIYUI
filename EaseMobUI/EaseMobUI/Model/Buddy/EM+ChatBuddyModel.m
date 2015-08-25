//
//  EM+ChatBuddyModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBuddyModel.h"
#import "EM+ChatBuddyGroupModel.h"

@implementation EM_ChatBuddyModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.onlineState = eOnlineStatus_OffLine;
        self.group = [EM_ChatBuddyGroupModel defaultGroup].firstObject;
    }
    return self;
}

@end