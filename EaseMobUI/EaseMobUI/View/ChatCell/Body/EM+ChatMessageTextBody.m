//
//  EM+ChatMessageTextBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageTextBody.h"
#import "TTTAttributedLabel.h"
#import "EM+ChatMessageModel.h"

#define TEXT_LINE_SPACING (1)
#define TEXT_FONT_SIZE (16)
#define TEXT_PADDING (2)

@interface EM_ChatMessageTextBody()<TTTAttributedLabelDelegate>

@end

@implementation EM_ChatMessageTextBody{
    TTTAttributedLabel *textLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needTap = NO;
        
        textLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        textLabel.delegate = self;
        textLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        textLabel.userInteractionEnabled = YES;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    textLabel.bounds = self.bounds;
    textLabel.center = CGPointMake(size.width / 2, size.height / 2);
}

- (NSString *)handleAction{
    return HANDLE_ACTION_TEXT;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    EMTextMessageBody *textBody = (EMTextMessageBody *)message.messageBody;
    textLabel.text = textBody.text;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if (self.delegate) {
        NSDictionary *userInfo = @{kHandleActionName:HANDLE_ACTION_URL,kHandleActionValue:url,kHandleActionMessage:self.message};
        [self.delegate bubbleTapWithUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    if (self.delegate) {
        NSDictionary *userInfo = @{kHandleActionName:HANDLE_ACTION_PHONE,kHandleActionValue:phoneNumber,kHandleActionMessage:self.message};
        [self.delegate bubbleTapWithUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point{
    if (self.delegate) {
        NSDictionary *userInfo = @{kHandleActionName:HANDLE_ACTION_URL,kHandleActionValue:url,kHandleActionMessage:self.message};
        [self.delegate bubbleLongPressWithUserInfo:userInfo];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithPhoneNumber:(NSString *)phoneNumber atPoint:(CGPoint)point{
    NSDictionary *userInfo = @{kHandleActionName:HANDLE_ACTION_PHONE,kHandleActionValue:phoneNumber,kHandleActionMessage:self.message};
    [self.delegate bubbleLongPressWithUserInfo:userInfo];
}

@end