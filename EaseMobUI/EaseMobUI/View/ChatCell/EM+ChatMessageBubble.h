//
//  EM+ChatMessageBubble.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EM_ChatMessageModel;
@class EM_ChatMessageBaseBody;
@class EM_ChatMessageExtendView;

@interface EM_ChatMessageBubble : UIView

@property (nonatomic, strong, readonly) EM_ChatMessageModel *message;
@property (nonatomic, strong, readonly) EM_ChatMessageBaseBody *bodyView;
@property (nonatomic, strong, readonly) EM_ChatMessageExtendView *extendView;

- (instancetype)initWithMessage:(EM_ChatMessageModel *)message;

@end