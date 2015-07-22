//
//  EM+ChatMessageModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

@interface EM_ChatMessageModel : NSObject

@property (nonatomic,copy,readonly) NSString *messageId;
@property (nonatomic,copy,readonly) NSString *nickName;
@property (nonatomic,copy,readonly) NSString *chatter;
@property (nonatomic,assign) BOOL sender;
@property (nonatomic,assign,readonly) long timestamp;
@property (nonatomic,assign,readonly) MessageBodyType bodyType;
@property (nonatomic,assign,readonly) EMMessageType messageType;

@property (nonatomic,strong) EMMessage *message;
@property (nonatomic,strong,readonly) id<IEMMessageBody> messageBody;

@property (nonatomic,assign) CGSize bubbleSize;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic,assign) BOOL playing;

- (instancetype)initWithMessage:(EMMessage *)message;

@end