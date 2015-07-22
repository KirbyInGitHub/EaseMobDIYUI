//
//  EM+ChatMessageRead.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/22.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EM_ChatMessageManager : NSObject

@property (nonatomic,strong,readonly) id currentImageMessage;
@property (nonatomic,strong,readonly) id currentVideoMessage;
@property (nonatomic,strong,readonly) id currentVoiceMessage;
@property (nonatomic,assign,readonly) BOOL isPlaying;

+ (instancetype)defaultManager;
- (void)showBrowserWithImagesMessage:(NSArray *)imageMessageArray index:(NSInteger)index;
- (void)showBrowserWithVideoMessage:(id)videoMessage;

- (void)playVoice:(NSArray *)voiceMessageArray index:(NSInteger)index;
- (void)stopVoice;

@end