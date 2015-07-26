//
//  EM+ChatMessageRead.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/22.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EM_ChatMessageManagerDelegate;

@interface EM_ChatMessageManager : NSObject

@property (nonatomic,assign,readonly) BOOL isPlaying;
@property (nonatomic,weak) id<EM_ChatMessageManagerDelegate> delegate;

+ (instancetype)defaultManager;
- (void)showBrowserWithImagesMessage:(NSArray *)imageMessageArray index:(NSInteger)index;
- (void)showBrowserWithVideoMessage:(id)videoMessage;

- (void)playVoice:(NSArray *)voiceMessageArray index:(NSInteger)index;
- (void)stopVoice;

@end

@protocol EM_ChatMessageManagerDelegate <NSObject>

- (void)playStartWithMessage:(id)startMessage;
- (void)playCompletionWithMessage:(id)completionMessage nextMessage:(id)nextMessage;

@end