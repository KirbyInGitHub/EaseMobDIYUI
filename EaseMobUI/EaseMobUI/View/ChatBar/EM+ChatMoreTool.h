//
//  EM+MessageMoreTool.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EM+ChatBaseView.h"
#import "EM+ChatRecordView.h"
#import "EM+ChatEmojiView.h"
#import "EM+ChatActionView.h"

@protocol EM_ChatMoreToolDelegate;

@interface EM_ChatMoreTool : EM_ChatBaseView

@property (nonatomic,strong,readonly) EM_ChatRecordView *recordView;
@property (nonatomic,strong,readonly) EM_ChatEmojiView *emojiView;
@property (nonatomic,strong,readonly) EM_ChatActionView *actionView;

@property (nonatomic,strong,readonly) UIView *currentTool;

@property (nonatomic, weak) id<EM_ChatMoreToolDelegate> delegate;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

- (void)showTool:(UIView *)tool animation:(BOOL)animation;
- (void)dismissTool:(BOOL)animation;

@end

@protocol EM_ChatMoreToolDelegate <NSObject>

@required

//Action
- (void)didActionClicked:(NSString *)actionName;

//Emoji
- (void)didEmojiClicked:(NSString *)emoji;
- (void)didEmojiDeleteClicked;
- (void)didEmojiSendClicked;

//Record
- (BOOL)shouldRecord;
- (void)didRecordStart;
- (void)didRecording:(NSInteger)duration;
- (void)didRecordEnd:(NSString *)recordName path:recordPath duration:(NSInteger)duration;
- (void)didRecordCancel;
- (void)didRecordError:(NSError *)error;

- (void)didRecordPlay;
- (void)didRecordPlaying:(NSInteger)duration;
- (void)didRecordPlayStop;
@optional


@end