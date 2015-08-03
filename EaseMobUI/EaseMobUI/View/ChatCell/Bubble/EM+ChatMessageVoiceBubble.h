//
//  EM+ChatMessageVoiceBubble.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBaseBubble.h"

@protocol EM_ChatVoiceBubbleDelegate;

@interface EM_ChatMessageVoiceBubble : EM_ChatMessageBaseBubble

@end

@protocol EM_ChatVoiceBubbleDelegate <NSObject>

@required
@optional

- (BOOL)shouldVoiceRecognition;
- (void)didVoiceRecognitionStartWithMessage:(EM_ChatMessageModel *)message;
- (void)didVoiceRecognitionCancelWithMessage:(EM_ChatMessageModel *)message;

@end