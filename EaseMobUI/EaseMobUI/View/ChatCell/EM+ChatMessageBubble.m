//
//  EM+ChatMessageBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageBubble.h"
#import "EM+ChatMessageBodyView.h"
#import "EM+ChatMessageExtendView.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageUIConfig.h"

@interface EM_ChatMessageBubble()

@end

@implementation EM_ChatMessageBubble

- (instancetype)initWithBodyClass:(Class)bodyClass withExtendClass:(Class)extendClass{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        _backgroundView = [[UIImageView alloc]init];
        [self addSubview:_backgroundView];
        
        _bodyView = [[bodyClass alloc]init];
        [self addSubview:_bodyView];
        _extendView = [[extendClass alloc]init];
        [self addSubview:_extendView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _backgroundView.frame = self.bounds;
    
    CGSize bodySize = [self.message bodySizeFormMaxWidth:size.width - self.config.bubblePadding * 2 config:self.config];
    CGSize extendSize = [self.message extendSizeFormMaxWidth:size.width - self.config.bubblePadding * 2 config:self.config];
    
    if (self.message.extend.showBody) {
        if (self.message.sender) {
            _bodyView.frame = CGRectMake(size.width - self.config.bubblePadding - bodySize.width, self.config.bubblePadding, bodySize.width, bodySize.height);
        }else{
            _bodyView.frame = CGRectMake(self.config.bubblePadding, self.config.bubblePadding, bodySize.width, bodySize.height);
        }
    }else{
        _bodyView.frame = CGRectZero;
    }
    
    if (self.message.extend.showExtend) {
        _extendView.bounds = CGRectMake(0, 0, extendSize.width, extendSize.height);
        _extendView.center = CGPointMake(size.width / 2, _bodyView.frame.origin.y + _bodyView.frame.size.height + 1 + extendSize.height / 2);
    }else{
        _extendView.frame = CGRectZero;
    }
    
}

- (void)setConfig:(EM_ChatMessageUIConfig *)config{
    _config = config;
    _bodyView.config = _config;
    _extendView.config = _config;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;
    _bodyView.message = _message;
    _extendView.message = _message;
    
    _bodyView.hidden = !_message.extend.showBody;
    _extendView.hidden = !_message.extend.showExtend;
}

@end