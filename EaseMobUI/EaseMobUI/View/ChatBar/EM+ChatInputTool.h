//
//  EM+MessageInputTool.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EM+ChatBaseView.h"
#import "EM+ChatUIConfig.h"

@protocol EM_ChatInputToolDelegate;

@interface EM_ChatInputTool : EM_ChatBaseView

@property (nonatomic,weak) UIResponder *overrideNextResponder;
@property (nonatomic,assign) BOOL stateRecord;
@property (nonatomic,assign) BOOL stateEmoji;
@property (nonatomic,assign) BOOL stateAction;
@property (nonatomic,assign) BOOL stateMore;
@property (nonatomic,assign,readonly) CGSize contentSize;
@property (nonatomic,copy) NSString *editor;

@property (nonatomic, weak) id<EM_ChatInputToolDelegate> delegate;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;

- (void)addMessage:(NSString *)message;
- (void)deleteMessage;
- (void)sendMessage;

- (void)dismissKeyboard;
- (void)showKeyboard;

@end

@protocol EM_ChatInputToolDelegate <NSObject>

@required

- (void)didRecordStateChanged:(BOOL)changed;
- (void)didEmojiStateChanged:(BOOL)changed;
- (void)didActionStateChanged:(BOOL)changed;
- (void)didMoreStateChanged:(BOOL)changed;

@optional

- (void)didMessageChanged:(NSString *)message oldContentSize:(CGSize)oldContentSize newContentSize:(CGSize)newContentSize;
- (BOOL)shouldMessageSend:(NSString *)message;
- (void)didMessageSend:(NSString *)message;

@end