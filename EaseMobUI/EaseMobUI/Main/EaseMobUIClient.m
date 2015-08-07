//
//  EaseMobUIClient.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EaseMobUIClient.h"
#import "EM+ChatDB.h"
#import "EM+ChatFileUtils.h"

static EaseMobUIClient *sharedClient;

@interface EaseMobUIClient()

@end

@implementation EaseMobUIClient

+ (instancetype)sharedInstance{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            [EM_ChatFileUtils initialize];
            sharedClient = [[self alloc] init];
        });
    }
    
    return sharedClient;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        EM_ChatDB *db = [EM_ChatDB shared];
        if (![db connect]) {
            NSLog(@"初始化数据库失败");
        }
    }
    return self;
}

@end