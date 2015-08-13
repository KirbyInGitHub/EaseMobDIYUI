//
//  EM+ChatMessageModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageBaseBody.h"
#import "EM+ChatMessageTextBody.h"
#import "EM+ChatMessageImageBody.h"
#import "EM+ChatMessageVideoBody.h"
#import "EM+ChatMessageLocationBody.h"
#import "EM+ChatMessageVoiceBody.h"
#import "EM+ChatMessageFileBody.h"

@interface EM_ChatMessageModel()

@property (nonatomic, assign) CGSize bodySize;
@property (nonatomic, assign) CGSize extendSize;

@end

@implementation EM_ChatMessageModel

- (instancetype)initWithMessage:(EMMessage *)message{
    self = [super init];
    if (self) {
        [self setMessage:message];
        _bubblePadding = 2;
        _textFont = 16;
    }
    return self;
}

- (void)setMessage:(EMMessage *)message{
    _message = message;
    
    NSString *className = _message.ext[kClassName];
    if (className && className.length > 0) {
        _extend = [[NSClassFromString(className) alloc]init];
        [_extend getFrom:_message.ext];
    }else{
        _extend = [[EM_ChatMessageExtend alloc]init];
    }
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
        _message.ext = [self.extend getContentValues];
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
            classForBuildView = [EM_ChatMessageBaseBody class];
        }
            break;
    }
    return classForBuildView;
}

- (CGSize)bubbleSizeFormMaxWidth:(CGFloat)maxWidth{
    CGSize bodySize = [self bodySizeFormMaxWidth:maxWidth - _bubblePadding * 2];
    CGSize extendSize = [self extendSizeFormMaxWidth:maxWidth - _bubblePadding * 2];
    return CGSizeMake((bodySize.width > extendSize.width ? bodySize.width : extendSize.width) + CELL_BUBBLE_PADDING * 2, bodySize.height + extendSize.height + 1 + CELL_BUBBLE_PADDING * 2);
}

- (CGSize)bodySizeFormMaxWidth:(CGFloat)maxWidth{
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
                [paragraphStyle setLineSpacing:1];//调整行间距
                self.bodySize = [textBody.text boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                             NSFontAttributeName:[UIFont systemFontOfSize:_textFont],
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

- (CGSize)extendSizeFormMaxWidth:(CGFloat)maxWidth{
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