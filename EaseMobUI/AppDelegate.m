//
//  AppDelegate.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/6/30.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMobUIClient.h"
#import "EM+Common.h"

#import "UStylistChatController.h"


#define EaseMob_AppKey (@"zhou-yuzhen#easemobchatui")

#ifdef DEBUG

#define EaseMob_APNSCertName (@"apns_dev")

#else

#define EaseMob_APNSCertName (@"apns_pro")

#endif

@interface AppDelegate ()<EM_ChatUserDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *chatter = nil;
    NSString *user = nil;
    NSString *password = nil;
    
    if (IS_PAD || TARGET_IPHONE_SIMULATOR) {
        chatter = @"yuanjing";
        user = @"zhouyuzhen";
        password = @"123456";
    }else{
        chatter = @"zhouyuzhen";
        user = @"yuanjing";
        password = @"123456";
    }
    
    [EaseMobUIClient sharedInstance].userDelegate = self;
    
    EM_ChatUIConfig *config = [EM_ChatUIConfig defaultConfig];
    //[config removeActionWithName:kActionNameVoice];
    //[config removeActionWithName:kActionNameVideo];
    UIViewController *rootController = [[UStylistChatController alloc]initWithChatter:chatter conversationType:eConversationTypeChat config:config];
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
    [[EaseMobUIClient sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillTerminate:application];
}

#pragma mark - EM_ChatUserDelegate
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    if ([chatter isEqualToString:@"zhouyuzhen"]) {
        return @"周玉震";
    }else if ([chatter isEqualToString:@"yuanjing"]){
        return @"袁静";
    }
    return nil;
}

@end