//
//  EM+ChatController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

//View
#import "EM+ChatToolBar.h"
#import "EM+ChatTableView.h"
#import "EM+ChatMessageCell.h"
#import "MJRefresh.h"

#import "UIViewController+HUD.h"

@interface EM_ChatController : UIViewController

@property (nonatomic,strong,readonly) NSString *chatter;
@property (nonatomic,assign,readonly) EMConversationType conversationType;
@property (nonatomic,assign,readonly) EMMessageType messageType;

@property (nonatomic,assign,readonly) BOOL isShow;

@property (nonatomic,strong,readonly) EM_ChatTableView *chatTableView;
@property (nonatomic,strong,readonly) EM_ChatToolBar *chatToolBarView;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType;

- (void)sendMessage:(EMMessage *)message;
- (void)sendMessageBody:(id<IEMMessageBody>)messageBody;

@end