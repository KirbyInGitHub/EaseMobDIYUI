//
//  EaseMobUIClient.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/5.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EM+ChatController.h"

#import "EM+Common.h"
#import "EM+ChatUIConfig.h"

@interface EaseMobUIClient : NSObject


+ (instancetype)sharedInstance;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

@end