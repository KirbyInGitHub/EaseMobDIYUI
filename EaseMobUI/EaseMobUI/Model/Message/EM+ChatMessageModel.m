//
//  EM+ChatMessageModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageBodyView.h"
#import "EM+ChatMessageTextBody.h"
#import "EM+ChatMessageImageBody.h"
#import "EM+ChatMessageVideoBody.h"
#import "EM+ChatMessageLocationBody.h"
#import "EM+ChatMessageVoiceBody.h"
#import "EM+ChatMessageFileBody.h"

#import "EM+ChatMessageUIConfig.h"

@interface EM_ChatMessageModel()

@property (nonatomic, assign) CGSize bodySize;
@property (nonatomic, assign) CGSize extendSize;

@end

@implementation EM_ChatMessageModel

+ (instancetype)fromEMMessage:(EMMessage *)message{
    EM_ChatMessageModel *model = [[EM_ChatMessageModel alloc]init];
    model.message = message;
    
    NSString *className = message.ext[kClassName];
    if (className && className.length > 0) {
        model.extend = [[NSClassFromString(className) alloc]init];
        [model.extend getFrom:model.message.ext];
    }else{
        model.extend = [[EM_ChatMessageExtend alloc]init];
    }
    model.extend.message = model;
    
    return model;
}

+ (instancetype)fromText:(NSString *)text conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *textBody = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    return [EM_ChatMessageModel fromBody:textBody conversation:conversation extend:extend];
}

+ (instancetype)fromVoice:(NSString *)path name:(NSString *)name duration:(NSInteger)duration conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatVoice *chatVoice = [[EMChatVoice alloc] initWithFile:path displayName:name];
    chatVoice.duration = duration;
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc] initWithChatObject:chatVoice];
    return [EM_ChatMessageModel fromBody:voiceBody conversation:conversation extend:extend];
}

+ (instancetype)fromImage:(UIImage *)image conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:[NSString stringWithFormat:@"%d%d%@",(int)[NSDate date].timeIntervalSince1970,arc4random() % 100000,@".jpg"]];
    EMImageMessageBody *imageBody = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [EM_ChatMessageModel fromBody:imageBody conversation:conversation extend:extend];
}

+ (instancetype)fromVideo:(NSString *)path conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:path displayName:[NSString stringWithFormat:@"%d%d%@",(int)[NSDate date].timeIntervalSince1970,arc4random() % 100000,@".mp4"]];
    EMVideoMessageBody *videoBody = [[EMVideoMessageBody alloc]initWithChatObject:chatVideo];
    return [EM_ChatMessageModel fromBody:videoBody conversation:conversation extend:extend];
}

+ (instancetype)fromLatitude:(double)latitude longitude:(double)longitude address:(NSString *)address conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *locationBody = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [EM_ChatMessageModel fromBody:locationBody conversation:conversation extend:extend];
}

+ (instancetype)fromFile:(NSString *)path name:(NSString *)name conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMChatFile *chatFile = [[EMChatFile alloc]initWithFile:path displayName:name];
    EMFileMessageBody *fileBody = [[EMFileMessageBody alloc]initWithChatObject:chatFile];
    return [EM_ChatMessageModel fromBody:fileBody conversation:conversation extend:extend];
}

+ (instancetype)fromBody:(id<IEMMessageBody>)body conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend{
    EMMessage *retureMsg = [[EMMessage alloc]initWithReceiver:conversation.chatter bodies:[NSArray arrayWithObject:body]];
    switch (conversation.conversationType) {
        case eConversationTypeGroupChat:{
            retureMsg.messageType = eMessageTypeGroupChat;
        }
            break;
        case eConversationTypeChatRoom:{
            retureMsg.messageType = eMessageTypeChatRoom;
        }
            break;
        default:{
            retureMsg.messageType = eMessageTypeChat;
        }
            break;
    }
    
    EM_ChatMessageModel *model = [[EM_ChatMessageModel alloc]init];
    model.message = retureMsg;
    if (extend) {
        model.extend = extend;
    }else{
        model.extend = [[EM_ChatMessageExtend alloc]init];
    }
    model.extend.message = model;
    
    model.message.ext = [model.extend getContentValues];
    return model;
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setMessage:(EMMessage *)message{
    _message = message;
}

- (void)setExtend:(EM_ChatMessageExtend *)extend{
    _extend = extend;
}

- (id<IEMMessageBody>)messageBody{
    if (self.message) {
        return [self.message.messageBodies firstObject];
    }
    return nil;
}

- (BOOL)updateExt{
    BOOL update = YES;
    if (self.extend) {
        update = [self.message updateMessageExtToDB];
    }
    return update;
}

- (NSString *)reuseIdentifier{
    NSMutableString *reuseIdentifier = [[NSMutableString alloc]init];
    if (self.message) {
        [reuseIdentifier appendString:NSStringFromClass([self.messageBody class])];
    }
    
    if (self.extend) {
        [reuseIdentifier appendString:NSStringFromClass([self.extend class])];
    }
    
    return reuseIdentifier;
}

- (Class)classForBuildView{
    Class classForBuildView;
    switch (self.messageBody.messageBodyType) {
        case eMessageBodyType_Text:{
            classForBuildView = [EM_ChatMessageTextBody class];
        }
            break;
        case eMessageBodyType_Image:{
            classForBuildView = [EM_ChatMessageImageBody class];
        }
            break;
        case eMessageBodyType_Video:{
            classForBuildView = [EM_ChatMessageVideoBody class];
        }
            break;
        case eMessageBodyType_Location:{
            classForBuildView = [EM_ChatMessageLocationBody class];
        }
            break;
        case eMessageBodyType_Voice:{
            classForBuildView = [EM_ChatMessageVoiceBody class];
        }
            break;
        case eMessageBodyType_File:{
            classForBuildView = [EM_ChatMessageFileBody class];
        }
            break;
        default:{
            classForBuildView = [EM_ChatMessageBodyView class];
        }
            break;
    }
    return classForBuildView;
}

- (CGSize)bubbleSizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    CGSize bodySize = [self bodySizeFormMaxWidth:maxWidth - config.bubblePadding * 2 config:config];
    CGSize extendSize = [self extendSizeFormMaxWidth:maxWidth - config.bubblePadding * 2 config:config];
    return CGSizeMake((bodySize.width > extendSize.width ? bodySize.width : extendSize.width) + config.bubblePadding * 2, bodySize.height + extendSize.height + 1 + config.bubblePadding * 2);
}

- (CGSize)bodySizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    if (CGSizeEqualToSize(self.bodySize, CGSizeZero)) {
        id<IEMMessageBody> messageBody = self.messageBody;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:{
                EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
                static float systemVersion;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
                });
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:config.bubbleTextLineSpacing];
                
                self.bodySize = [textBody.text boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                             NSFontAttributeName:[UIFont systemFontOfSize:config.bubbleTextFont + 1],
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             }
                                                   context:nil].size;
            }
                break;
            case eMessageBodyType_Image:{
                EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
                self.bodySize = imageBody.thumbnailSize;
            }
                break;
            case eMessageBodyType_Video:{
                EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
                self.bodySize = videoBody.size;
            }
                break;
            case eMessageBodyType_Location:{
                self.bodySize = CGSizeMake(150, 150);
            }
                break;
            case eMessageBodyType_Voice:{
                EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)messageBody;
                self.bodySize = CGSizeMake(voiceBody.duration * 2 + 88, 15);
            }
                break;
            case eMessageBodyType_File:{
                self.bodySize = CGSizeMake(100, 150);
            }
                break;
            case eMessageBodyType_Command:{
                self.bodySize = CGSizeZero;
            }
                break;
        }
    }
    
    if (self.extend && !self.extend.showBody) {
        return CGSizeZero;
    }
    return self.bodySize;
}

- (CGSize)extendSizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config{
    if (CGSizeEqualToSize(self.extendSize, CGSizeZero) && self.extend) {
        self.extendSize = [self.extend extendSizeFromMaxWidth:maxWidth];
    }
    if (self.extend && !self.extend.showExtend) {
        return CGSizeZero;
    }
    return self.extendSize;
}

- (BOOL)isEqual:(id)object{
    
    BOOL isEqual = NO;
    
    EM_ChatMessageModel *model = object;
    if (model.message && self.message) {
        isEqual = [model.message isEqual:self.message];
        if (!isEqual) {
            isEqual = [model.message.messageId isEqualToString:self.message.messageId];
        }
    }
    
    return isEqual;
}

@end