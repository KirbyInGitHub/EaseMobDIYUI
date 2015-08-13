//
//  EM+ChatMessageBaseBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/17.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBaseBody.h"
#import "UIColor+Hex.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"

#import "EM+ChatMessageModel.h"

@implementation EM_ChatMessageBaseBody{
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

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needTap = YES;
        self.needLongPress = YES;
    }
    return self;
}

- (NSString *)handleAction{
    return HANDLE_ACTION_UNKNOWN;
}

- (NSMutableArray *)bubbleMenuItems{
    NSMutableArray *menuItems = [[NSMutableArray alloc]init];
    id<IEMMessageBody> messageBody = self.message.messageBody;
    
    if (messageBody.messageBodyType == eMessageBodyType_Text) {
        //复制
        UIMenuItem *copyItme = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.copy"] action:@selector(copyEMMessage:)];
        [menuItems addObject:copyItme];
    }else if (messageBody.messageBodyType == eMessageBodyType_Image){
        //收藏到表情
        UIMenuItem *collectFaceItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.collect_face"] action:@selector(collectEMMessageFace:)];
        [menuItems addObject:collectFaceItem];
    }else if (messageBody.messageBodyType == eMessageBodyType_File){
        //下载,如果未下载
        EMFileMessageBody *fileBody = (EMFileMessageBody *)messageBody;
        if (fileBody.attachmentDownloadStatus == EMAttachmentNotStarted) {
            UIMenuItem *downloadItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.download"] action:@selector(downloadEMMessageFile:)];
            [menuItems addObject:downloadItem];
        }
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Video) {
        //收藏
        NSString *conllect = [EM_ChatResourcesUtils stringWithName:@"common.collect"];
        if (self.message.extend.collected) {
            conllect = [EM_ChatResourcesUtils stringWithName:@"common.collect_cancel"];
        }
        UIMenuItem *collectItem = [[UIMenuItem alloc]initWithTitle:conllect action:@selector(collectEMMessage:)];
        [menuItems addObject:collectItem];
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Voice) {
        //转发
        
        UIMenuItem *forwardItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.forward"] action:@selector(forwardEMMessage:)];
        [menuItems addObject:forwardItem];
        
        //转发多条
    }
    
    //删除
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:[EM_ChatResourcesUtils stringWithName:@"common.delete"] action:@selector(deleteEMMessage:)];
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
    if(_delegate){
        NSDictionary *userInfo = @{kHandleActionName:self.handleAction,kHandleActionMessage:self.message};
        [_delegate bubbleTapWithUserInfo:userInfo];
    }
}

- (void)bubbleLongPress:(UILongPressGestureRecognizer *)recognizer{
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
    
    id<IEMMessageBody> messageBody = [self.message.message.messageBodies firstObject];
    
    if (messageBody.messageBodyType == eMessageBodyType_Text && action == @selector(copyEMMessage:)) {
        return YES;
    }
    
    if (messageBody.messageBodyType == eMessageBodyType_Image && action == @selector(collectEMMessageFace:)){
        return YES;
    }
    if (messageBody.messageBodyType == eMessageBodyType_File && action == @selector(downloadEMMessageFile:)){
        return YES;
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Video && action == @selector(collectEMMessage:)) {
        return YES;
    }
    
    if (messageBody.messageBodyType != eMessageBodyType_Voice && action == @selector(forwardEMMessage:)) {
        return YES;
    }
    return NO;
}


- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;
}

@end