//
//  EM+ChatMessageBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBubble.h"
#import "EM+ChatMessageTextBody.h"
#import "EM+ChatMessageImageBody.h"
#import "EM+ChatMessageVideoBody.h"
#import "EM+ChatMessageLocationBody.h"
#import "EM+ChatMessageVoiceBody.h"
#import "EM+ChatMessageFileBody.h"
#import "EM+ChatMessageExtendView.h"
#import "EM+ChatMessageModel.h"

@interface EM_ChatMessageBubble()

@end

@implementation EM_ChatMessageBubble

- (instancetype)initWithMessage:(EM_ChatMessageModel *)message{
    self = [super init];
    if (self) {
        _message = message;
        
        switch (_message.messageBody.messageBodyType) {
            case eMessageBodyType_Text:{
                _bodyView = [[EM_ChatMessageTextBody alloc]init];
            }
                break;
            case eMessageBodyType_Image:{
                _bodyView = [[EM_ChatMessageImageBody alloc]init];
            }
                break;
            case eMessageBodyType_Video:{
                _bodyView = [[EM_ChatMessageVideoBody alloc]init];
            }
                break;
            case eMessageBodyType_Location:{
                _bodyView = [[EM_ChatMessageLocationBody alloc]init];
            }
                break;
            case eMessageBodyType_Voice:{
                _bodyView = [[EM_ChatMessageVoiceBody alloc]init];
            }
                break;
            case eMessageBodyType_File:{
                _bodyView = [[EM_ChatMessageFileBody alloc]init];
            }
                break;
            default:
                break;
        }
        _bodyView.message = _message;
        
        if (_message.extend.class != [EM_ChatMessageExtendView class]) {
            _extendView = [[[_message.extend classForExtendView]alloc]init];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGSize bodySize = [self.message bodySizeFormMaxWidth:size.width - CELL_BUBBLE_PADDING * 2];
    CGSize extendSize = [self.message extendSizeFormMaxWidth:size.width - CELL_BUBBLE_PADDING * 2];
    if (self.message.sender) {
        _bodyView.frame = CGRectMake(size.width - CELL_BUBBLE_PADDING - bodySize.width, CELL_BUBBLE_PADDING, bodySize.width, bodySize.height);
    }else{
        _bodyView.frame = CGRectMake(CELL_BUBBLE_PADDING, CELL_BUBBLE_PADDING, bodySize.width, bodySize.height);
    }
    
    if (_extendView) {
        _extendView.bounds = CGRectMake(0, 0, extendSize.width, extendSize.height);
        _extendView.center = CGPointMake(size.width / 2, _bodyView.frame.origin.y + _bodyView.frame.size.height + 1 + extendSize.height / 2);
    }
}

@end