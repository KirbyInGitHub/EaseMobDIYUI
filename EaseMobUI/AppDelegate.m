//
//  AppDelegate.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/6/30.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "MainController.h"
#import "EM+Common.h"
#import "EM+ChatDB.h"

#define EaseMob_AppKey (@"zhou-yuzhen#easemobchatui")

#ifdef DEBUG

#define EaseMob_APNSCertName (@"apns_dev")

#else

#define EaseMob_APNSCertName (@"apns_pro")

#endif

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EM_ChatDB *db = [EM_ChatDB shared];
    if (![db connect]) {
        NSLog(@"初始化数据库失败");
    }
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *chatter = nil;
    NSString *name = nil;
    NSString *user = nil;
    NSString *password = nil;
    
    if (IS_PAD || TARGET_IPHONE_SIMULATOR) {
        chatter = @"yuanjing";
        name = @"Jing";
        user = @"zhouyuzhen";
        password = @"123456";
    }else{
        chatter = @"zhouyuzhen";
        name = @"ZhouYuzhen";
        user = @"yuanjing";
        password = @"123456";
    }
    
    UIViewController *rootController = [[MainController alloc]initWithChatter:chatter conversationType:eConversationTypeChat];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:rootController];
    [self.window makeKeyAndVisible];

    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMob_AppKey apnsCertName:EaseMob_APNSCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user password:password completion:^(NSDictionary *loginInfo, EMError *error) {
    } onQueue:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
