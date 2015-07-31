//
//  EM+ChatMessageModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageModel.h"

@implementation EM_ChatMessageModel

NSString * const kExtendUserInfo = @"kExtendUserInfo";
NSString * const kExtendMessageData = @"kExtendMessageData";

- (instancetype)initWithMessage:(EMMessage *)message{
    self = [super init];
    if (self) {
        _bubbleSize = CGSizeZero;
        _showTime = YES;
        _messageDetailsState = [[EM_ChatMessageState alloc]init];
        [self setMessage:message];
    }
    return self;
}

- (NSString *)messageId{
    return _message.messageId;
}

- (NSString *)chatter{
    return _message.from;
}

- (long)timestamp{
    return _message.timestamp;
}

- (MessageBodyType)bodyType{
    return self.messageBody.messageBodyType;
}

- (EMMessageType)messageType{
    return self.message.messageType;
}

- (id<IEMMessageBody>)messageBody{
    return [self.message.messageBodies firstObject];
}

- (NSDictionary *)messageData{
    NSDictionary *ext = self.message.ext;
    if (ext) {
        return ext[kExtendMessageData];
    }
    return nil;
}

- (NSDictionary *)extend{
    NSDictionary *ext = self.message.ext;
    if (ext) {
        return ext[kExtendUserInfo];
    }
    return nil;
}

- (void)setMessage:(EMMessage *)message{
    _message = message;
    _nickName = _message.from;
    
    _messageDetailsState.messageId = _message.messageId;
    _messageDetailsState.messageBodyType = self.bodyType;
    _messageDetailsState.messageType = self.messageType;
}

- (BOOL)isEqual:(id)object{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual) {
        EM_ChatMessageModel *model = object;
        isEqual = [model.messageId isEqual:self.messageId];
    }
    return isEqual;
}

@end