//
//  EaseMobUIClient.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EaseMobUIClient.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatDBUtils.h"

static EaseMobUIClient *sharedClient;

@interface EaseMobUIClient()

@end

@implementation EaseMobUIClient

+ (instancetype)sharedInstance{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            [EM_ChatFileUtils initialize];
            [EM_ChatDBUtils shared];
            sharedClient = [[self alloc] init];
        });
    }
    
    return sharedClient;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    if ([EM_ChatDBUtils shared]) {
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
}

@end