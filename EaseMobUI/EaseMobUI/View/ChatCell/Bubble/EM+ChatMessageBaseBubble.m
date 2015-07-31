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

- (NSMutableArray *)bubbleMenuItems{
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    
    if (self.message.bodyType == eMessageBodyType_Text) {
        //复制
        UIMenuItem *copyItme = [[UIMenuItem alloc]initWithTitle:EM_ChatString(@"common.copy") action:@selector(copyEMMessage:)];
        [menuItems addObject:copyItme];
    }else if (self.message.bodyType == eMessageBodyType_Image){
        //收藏到表情
        UIMenuItem *collectFaceItem = [[UIMenuItem alloc]initWithTitle:EM_ChatString(@"common.collect_face") action:@selector(collectEMMessageFace:)];
        [menuItems addObject:collectFaceItem];
    }else if (self.message.bodyType == eMessageBodyType_File){
        //下载,如果未下载
        EMFileMessageBody *messageBody = (EMFileMessageBody *)self.message.messageBody;
        if (messageBody.attachmentDownloadStatus == EMAttachmentNotStarted) {
            UIMenuItem *downloadItem = [[UIMenuItem alloc]initWithTitle:EM_ChatString(@"common.download") action:@selector(downloadEMMessageFile:)];
            [menuItems addObject:downloadItem];
        }
    }
    
    if (self.message.bodyType != eMessageBodyType_Video) {
        //收藏
        NSString *conllect = EM_ChatString(@"common.collect");
        if (self.message.messageData.collected) {
            conllect = EM_ChatString(@"common.collect_cancel");
        }
        UIMenuItem *collectItem = [[UIMenuItem alloc]initWithTitle:conllect action:@selector(collectEMMessage:)];
        [menuItems addObject:collectItem];
    }
    
    if (self.message.bodyType != eMessageBodyType_Voice) {
        //转发
        
        UIMenuItem *forwardItem = [[UIMenuItem alloc]initWithTitle:EM_ChatString(@"common.forward") action:@selector(forwardEMMessage:)];
        [menuItems addObject:forwardItem];
        
        //转发多条
    }
    
    //删除
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:EM_ChatString(@"common.delete") action:@selector(deleteEMMessage:)];
    [menuItems addObject:deleteItem];
    
    return menuItems;
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

//复制
- (void)copyEMMessage:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_COPY];
    }
}

//添加到表情
- (void)collectEMMessageFace:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_FACE];
    }
}

//下载
- (void)downloadEMMessageFile:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_DOWNLOAD];
    }
}

//收藏
- (void)collectEMMessage:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_COLLECT];
    }
}

//转发
- (void)forwardEMMessage:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_FORWARD];
    }
}

//删除
- (void)deleteEMMessage:(id)sender{
    if (_delegate) {
        [_delegate bubbleMenuAction:EM_MENU_ACTION_DELETE];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    if (!self.message) {
        return NO;
    }
    
    if (action == @selector(deleteEMMessage:)) {
        return YES;
    }
    
    if (action == @selector(collectEMMessage:)) {
        return YES;
    }
    
    if (self.message.bodyType == eMessageBodyType_Text && action == @selector(copyEMMessage:)) {
        return YES;
    }
    
    if (self.message.bodyType == eMessageBodyType_Image && action == @selector(collectEMMessageFace:)){
        return YES;
    }
    if (self.message.bodyType == eMessageBodyType_File && action == @selector(downloadEMMessageFile:)){
        return YES;
    }
    
    if (self.message.bodyType != eMessageBodyType_Video && action == @selector(collectEMMessage:)) {
        return YES;
    }
    
    if (self.message.bodyType != eMessageBodyType_Voice && action == @selector(forwardEMMessage:)) {
        return YES;
    }
    return NO;
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