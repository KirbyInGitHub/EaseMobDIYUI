//
//  EM+MessageToolBar.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/2.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EM+Common.h"

#import "EM+ChatBaseView.h"
#import "EM+ChatInputTool.h"
#import "EM+ChatMoreTool.h"
#import "EM+ChatTableView.h"

@protocol EM_MessageToolBarDelegate;

@interface EM_ChatToolBar : EM_ChatBaseView

@property (nonatomic,assign) id <EM_MessageToolBarDelegate> delegate;

@property (nonatomic,assign,readonly) BOOL keyboardVisible;
@property (nonatomic,assign,readonly) CGRect keyboardRect;

@property (nonatomic,assign,readonly) BOOL moreToolVisble;
@property (nonatomic,assign,readonly) CGFloat moreToolHeight;

@property (nonatomic,strong,readonly) EM_ChatInputTool *inputToolView;
@property (nonatomic,strong,readonly) EM_ChatMoreTool *moreToolView;
@property (nonatomic,strong) EM_ChatTableView *chatTableView;

- (instancetype)initWithConfig:(EM_ChatUIConfig *)config;
- (void)pullUpShow;

@end

@protocol EM_MessageToolBarDelegate <NSObject>

@required

@optional

//InputTool
- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldSeneMessage:(NSString *)message;
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSendMessagee:(NSString *)message;

//MoroTool
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didSelectedActionWithName:(NSString *)action;

- (BOOL)messageToolBar:(EM_ChatToolBar *)toolBar shouldRecord:(UIView *)view;
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didStartRecord:(UIView *)view;
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didCancelRecord:(UIView *)view;
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didEndRecord:(NSString *)name record:(NSString *)recordPath duration:(NSInteger)duration;
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didRecordError:(NSError *)error;

//Tool
- (void)messageToolBar:(EM_ChatToolBar *)toolBar didShowToolOrKeyboard:(BOOL)isShow;

@end