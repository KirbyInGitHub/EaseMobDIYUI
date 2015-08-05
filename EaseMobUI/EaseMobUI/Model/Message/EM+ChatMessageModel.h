//
//  EM+ChatMessageModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EM+ChatMessageData.h"

extern NSString * const kExtendUserData;
extern NSString * const kExtendMessageData;

@interface EM_ChatMessageModel : NSObject

@property (nonatomic,copy,readonly) NSString *messageId;
@property (nonatomic,copy,readonly) NSString *chatter;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic,assign) BOOL sender;
@property (nonatomic,assign,readonly) long timestamp;
@property (nonatomic,assign,readonly) MessageBodyType bodyType;
@property (nonatomic,assign,readonly) EMMessageType messageType;

@property (nonatomic,strong) EMMessage *message;
@property (nonatomic,strong,readonly) id<IEMMessageBody> messageBody;
@property (nonatomic, strong, readonly) NSDictionary *extend;
@property (nonatomic,strong,readonly) EM_ChatMessageData *messageData;

//额外的字段
@property (nonatomic,assign) CGSize bubbleSize;
@property (nonatomic,assign) BOOL showTime;
@property (nonatomic, assign) CGSize extendSize;
@property (nonatomic, assign) BOOL extendShow;
@property (nonatomic, assign) CGFloat progress;


- (instancetype)initWithMessage:(EMMessage *)message;
- (BOOL)updateExt;

@end