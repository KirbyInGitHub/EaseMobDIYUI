//
//  EM+ChatMessageModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageModel.h"

@implementation EM_ChatMessageModel

- (instancetype)initWithMessage:(EMMessage *)message{
    self = [super init];
    if (self) {
        [self setMessage:message];
        _bubbleSize = CGSizeZero;
        _showTime = YES;
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

- (void)setMessage:(EMMessage *)message{
    _message = message;
    _nickName = _message.from;
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