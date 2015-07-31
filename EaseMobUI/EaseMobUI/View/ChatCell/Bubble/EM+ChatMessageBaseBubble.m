//
//  EM+ChatMessageBaseBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/17.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBaseBubble.h"
#import "UIColor+Hex.h"
#import "EM+Common.h"

@implementation EM_ChatMessageBaseBubble{
    UITapGestureRecognizer *tap;
    UILongPressGestureRecognizer *longPress;
}

NSString * const kHandleActionName = @"kHandleActionName";
NSString * const kHandleActionMessage = @"kHandleActionMessage";
NSString * const kHandleActionValue = @"kHandleActionValue";

NSString * const HANDLE_ACTION_URL = @"HANDLE_ACTION_URL";
NSString * const HANDLE_ACTION_PHONE = @"HANDLE_ACTION_PHONE";
NSString * const HANDLE_ACTION_TEXT = @"HANDLE_ACTION_TEXT";
NSString * const HANDLE_ACTION_IMAGE = @"HANDLE_ACTION_IMAGE";
NSString * const HANDLE_ACTION_VOICE = @"HANDLE_ACTION_VOICE";
NSString * const HANDLE_ACTION_VIDEO = @"HANDLE_ACTION_VIDEO";
NSString * const HANDLE_ACTION_LOCATION = @"HANDLE_ACTION_LOCATION";
NSString * const HANDLE_ACTION_FILE = @"HANDLE_ACTION_FILE";
NSString * const HANDLE_ACTION_UNKNOWN = @"HANDLE_ACTION_UNKNOWN";

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody  maxWithd:(CGFloat)max{
    return CGSizeMake(CELL_BUBBLE_LEFT_PADDING + CELL_BUBBLE_RIGHT_PADDING, CELL_BUBBLE_TOP_PADDING + CELL_BUBBLE_BOTTOM_PADDING);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needTap = YES;
        self.needLongPress = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.extendView) {
        self.extendView.bounds = CGRectMake(0, 0, self.message.extendSize.width, self.message.extendSize.height);
    }
}

- (NSString *)handleAction{
    return HANDLE_ACTION_UNKNOWN;
}

- (void)setNeedTap:(BOOL)needTap{
    _needTap = needTap;
    if (tap) {
        [self removeGestureRecognizer:tap];
    }
    if (_needTap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleTap:)];
        [self addGestureRecognizer:tap];
        if (longPress) {
            [tap requireGestureRecognizerToFail:longPress];
        }
    }
}

- (void)setNeedLongPress:(BOOL)needLongPress{
    _needLongPress = needLongPress;
    
    if (longPress) {
        [self removeGestureRecognizer:longPress];
    }
    
    if (needLongPress) {
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleLongPress:)];
        longPress.minimumPressDuration = .5;
        [self addGestureRecognizer:longPress];
        if (tap) {
            [tap requireGestureRecognizerToFail:longPress];
        }
    }
}

- (void)bubbleTap:(UITapGestureRecognizer *)recognizer{
    if (self.extendView) {
        CGPoint point = [recognizer locationInView:self];
        if (CGRectContainsPoint(self.extendView.frame, point)) {
            return;
        }
    }
    
    if(_delegate){
        NSDictionary *userInfo = @{kHandleActionName:self.handleAction,kHandleActionMessage:self.message};
        [_delegate bubbleTapWithUserInfo:userInfo];
    }
}

- (void)bubbleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (self.extendView) {
        CGPoint point = [recognizer locationInView:self];
        if (CGRectContainsPoint(self.extendView.frame, point)) {
            return;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan && _delegate) {
        NSDictionary *userInfo = @{kHandleActionName:self.handleAction,kHandleActionMessage:self.message};
        [_delegate bubbleLongPressWithUserInfo:userInfo];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setExtendView:(UIView *)extendView{
    if (_extendView == extendView) {
        return;
    }else{
        if (_extendView) {
            [_extendView removeFromSuperview];
        }
        _extendView = extendView;
        if (_extendView){
            [self addSubview:_extendView];
            if(_extendLine){
                [_extendLine removeFromSuperview];
            }else{
                _extendLine = [[UIView alloc]init];
                _extendLine.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
            }
            [self addSubview:_extendLine];
        }else{
            if(_extendLine){
                [_extendLine removeFromSuperview];
            }
        }
    }
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;
}

@end