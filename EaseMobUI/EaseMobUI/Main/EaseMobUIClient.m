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
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"
#import "EM+ChatUIConfig.h"

#import "EM+CallController.h"
#import "UIViewController+HUD.h"

#import <EaseMobSDKFull/EaseMob.h>
#import <AVFoundation/AVFoundation.h>

static EaseMobUIClient *sharedClient;
/**
 *  EMChatManagerLoginDelegate
 *  EMChatManagerEncryptionDelegate
 *  EMChatManagerBuddyDelegate
 *  EMChatManagerUtilDelegate
 *  EMChatManagerGroupDelegate
 *  EMChatManagerPushNotificationDelegate
 *  EMChatManagerChatroomDelegate
 */

/**
 *  EMCallManagerCallDelegate
 */

/**
 *  EMDeviceManagerNetworkDelegate
 */
@interface EaseMobUIClient()<EMChatManagerDelegate,EMCallManagerDelegate,EMDeviceManagerDelegate>

@property (nonatomic, assign) BOOL callShow;

@end

@implementation EaseMobUIClient

NSString * const kEMNotificationCallActionIn = @"kEMNotificationCallActionIn";
NSString * const kEMNotificationCallActionOut = @"kEMNotificationCallActionOut";
NSString * const kEMNotificationCallShow = @"kEMNotificationCallShow";
NSString * const kEMNotificationCallDismiss = @"kEMNotificationCallDismiss";

NSString * const kEMNotificationEditorChanged = @"kEMNotificationEditorChanged";

NSString * const kEMCallChatter = @"kEMCallChatter";
NSString * const kEMCallType = @"kEMCallType";

NSString * const kEMCallTypeVoice = @"kEMCallActionVoice";
NSString * const kEMCallTypeVideo = @"kEMCallActionVideo";

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

+ (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    return bCanRecord;
}

+ (BOOL)canVideo{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized;
    }
    return YES;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self registerNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallIn:) name:kEMNotificationCallActionIn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallOut:) name:kEMNotificationCallActionOut object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallShow:) name:kEMNotificationCallShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatCallDismiss:) name:kEMNotificationCallDismiss object:nil];
    }
    return self;
}

- (void)dealloc{
    [self unregisterNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification
- (void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)chatCallIn:(NSNotification *)notification{
    EMCallSession *callSession = notification.object;
    if (!callSession) {
        return;
    }
    EMChatCallType type;
    if (callSession.type == eCallSessionTypeVideo) {
        type = EMChatCallTypeVideo;
    }else if(callSession.type == eCallSessionTypeAudio){
        type = EMChatCallTypeVoice;
    }
    
    if (type == EMChatCallTypeVideo || type == EMChatCallTypeVoice) {
        EM_CallController *callController = [[EM_CallController alloc]initWithSession:callSession type:type action:EMChatCallActionIn];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [ShareWindow.rootViewController presentViewController:callController animated:YES completion:nil];
    }
}

- (void)chatCallOut:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *chatter = userInfo[kEMCallChatter];
    NSString *action = userInfo[kEMCallType];
    
    EMError *error = nil;
    EMCallSession *callSession;
    EMChatCallType type;
    if ([action isEqualToString:kEMCallTypeVoice]) {
        if (![EaseMobUIClient canRecord]) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.vioce"]];
            return;
        }
        type = EMChatCallTypeVoice;
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:60 error:&error];
    }else{
        if (![EaseMobUIClient canVideo]) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.video"]];
            return;
        }
        type = EMChatCallTypeVideo;
        callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:60 error:&error];
    }
    
    if (callSession && !error) {
        UIViewController *result = nil;
        
        UIWindow * window = ShareWindow;
        if (window.windowLevel != UIWindowLevelNormal){
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows){
                if (tmpWin.windowLevel == UIWindowLevelNormal){
                    window = tmpWin;
                    break;
                }
            }
        }
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }else{
            result = window.rootViewController;
        }
        EM_CallController *callController = [[EM_CallController alloc]initWithSession:callSession type:type action:EMChatCallActionOut];
        callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [result presentViewController:callController animated:YES completion:nil];
    }else{
        if (type == EMChatCallTypeVoice) {
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.vioce"]];
        }else{
            [ShareWindow.rootViewController showHint:[EM_ChatResourcesUtils stringWithName:@"error.hint.video"]];
        }
    }
}

- (void)chatCallShow:(NSNotification *)notification{
    self.callShow = YES;
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

- (void)chatCallDismiss:(NSNotification *)notification{
    self.callShow = NO;
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

#pragma mark - application
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
}

#pragma mark - EMChatManagerDelegate
#pragma mark -
#pragma mark - EMChatManagerLoginDelegate
#pragma mark - EMChatManagerEncryptionDelegate
#pragma mark - EMChatManagerBuddyDelegate
#pragma mark - EMChatManagerUtilDelegate
#pragma mark - EMChatManagerGroupDelegate
#pragma mark - EMChatManagerPushNotificationDelegate
#pragma mark - EMChatManagerChatroomDelegate

#pragma mark - EMCallManagerCallDelegate
#pragma mark -
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (callSession.status == eCallSessionStatusConnected) {
        if (self.callShow) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Busy];
        }else{
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                if (callSession.type == eCallSessionTypeVideo) {
                    if (![EaseMobUIClient canVideo]) {
                        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Null];
                        return;
                    }
                }else if(callSession.type == eCallSessionTypeAudio){
                    if (![EaseMobUIClient canRecord]) {
                        [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Null];
                        return;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationCallActionIn object:callSession userInfo:nil];
            }else{
                
            }
        }
    }
}

#pragma mark - EMDeviceManagerDelegate

#pragma mark - IEMChatProgressDelegate


@end