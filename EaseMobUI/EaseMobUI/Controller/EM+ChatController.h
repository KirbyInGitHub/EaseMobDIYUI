//
//  EM+ChatController.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"
#import "EM+ChatMessageCell.h"
#import "EM+ChatUIConfig.h"

@class EM_ChatToolBar;
@class EM_ChatTableView;

extern NSString * const kExtendUserInfo;
extern NSString * const kExtendUserExt;

@protocol EM_ChatControllerDelegate;

@interface EM_ChatController : UIViewController

@property (nonatomic,strong,readonly) NSString *chatter;
@property (nonatomic,assign,readonly) EMConversationType conversationType;
@property (nonatomic,assign,readonly) EMMessageType messageType;

@property (nonatomic,assign,readonly) BOOL isShow;

@property (nonatomic,strong,readonly) EM_ChatTableView *chatTableView;
@property (nonatomic,strong,readonly) EM_ChatToolBar *chatToolBarView;

@property (nonatomic,weak) id<EM_ChatControllerDelegate> delegate;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType config:(EM_ChatUIConfig *)config;

- (void)sendMessageBody:(id<IEMMessageBody>)messageBody;
- (void)sendMessageBody:(id<IEMMessageBody>)messageBody userExt:(NSDictionary *)userExt;

@end

@protocol EM_ChatControllerDelegate <NSObject>

@required

@optional

- (NSString *)nickNameWithChatter:(NSString *)chatter;
- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSDictionary *)extendForMessageBody:(id<IEMMessageBody>)messageBody;
- (BOOL)showForExtendMessage:(NSDictionary *)ext;
- (NSString *)reuseIdentifierForExtendMessage:(NSDictionary *)ext;
- (CGSize)sizeForExtendMessage:(NSDictionary *)ext maxWidth:(CGFloat)max;
- (UIView *)viewForExtendMessage:(NSDictionary *)ext reuseView:(UIView *)view;

- (void)didActionSelectedWithName:(NSString *)name;

@end