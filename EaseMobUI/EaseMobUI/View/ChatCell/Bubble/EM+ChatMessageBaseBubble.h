//
//  EM+ChatMessageBaseBubble.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/17.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EM+ChatMessageModel.h"


#define CELL_BUBBLE_LEFT_PADDING (12)
#define CELL_BUBBLE_RIGHT_PADDING (12)
#define CELL_BUBBLE_TOP_PADDING (8)
#define CELL_BUBBLE_BOTTOM_PADDING (8)
#define CELL_BUBBLE_EXTEND_PADDING  (1)

extern NSString * const kHandleActionName;
extern NSString * const kHandleActionMessage;
extern NSString * const kHandleActionValue;

extern NSString * const HANDLE_ACTION_URL;
extern NSString * const HANDLE_ACTION_PHONE;
extern NSString * const HANDLE_ACTION_TEXT;
extern NSString * const HANDLE_ACTION_IMAGE;
extern NSString * const HANDLE_ACTION_VOICE;
extern NSString * const HANDLE_ACTION_VIDEO;
extern NSString * const HANDLE_ACTION_LOCATION;
extern NSString * const HANDLE_ACTION_FILE;
extern NSString * const HANDLE_ACTION_UNKNOWN;

@protocol EM_ChatMessageBubbleDelegate;

@interface EM_ChatMessageBaseBubble : UIView

@property (nonatomic,strong) EM_ChatMessageModel *message;
@property (nonatomic,assign) BOOL needTap;
@property (nonatomic,assign) BOOL needLongPress;
@property (nonatomic,weak)   id<EM_ChatMessageBubbleDelegate> delegate;
@property (nonatomic,copy)   NSString *handleAction;

@property (nonatomic, strong) UIView *extendView;
@property (nonatomic, strong, readonly) UIView *extendLine;

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max;

@end

@protocol EM_ChatMessageBubbleDelegate <NSObject>

@required

- (void)bubbleTapWithUserInfo:(NSDictionary *)userInfo;
- (void)bubbleLongPressWithUserInfo:(NSDictionary *)userInfo;

@optional

@end