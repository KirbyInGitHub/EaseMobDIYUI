//
//  EM+ChatMessageTextBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageTextBubble.h"
#import "TTTAttributedLabel.h"

#define TEXT_LINE_SPACING (1)
#define TEXT_FONT_SIZE (16)
#define TEXT_PADDING (2)

@interface EM_ChatMessageTextBubble()<TTTAttributedLabelDelegate>

@end

@implementation EM_ChatMessageTextBubble{
    TTTAttributedLabel *textLabel;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    
    CGSize superSize = [super sizeForBubbleWithMessage:messageBody maxWithd:max];
    CGSize maxSize = CGSizeMake(max - CELL_BUBBLE_LEFT_PADDING - CELL_BUBBLE_RIGHT_PADDING, 1000);
    
    EMTextMessageBody *textBody = messageBody;
    
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:TEXT_LINE_SPACING];//调整行间距
    size = [textBody.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                                 NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT_SIZE],
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 }
                                       context:nil].size;
    
    superSize.height += (size.height + TEXT_PADDING * 2);
    superSize.width += (size.width + TEXT_PADDING * 2);
    
    return superSize;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.needTap = NO;
        
        textLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        textLabel.delegate = self;
        textLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
        textLabel.numberOfLines = 0;
        textLabel.lineSpacing = TEXT_LINE_SPACING;
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
    
    textLabel.frame = CGRectMake(CELL_BUBBLE_LEFT_PADDING, CELL_BUBBLE_TOP_PADDING, size.width - CELL_BUBBLE_LEFT_PADDING - CELL_BUBBLE_RIGHT_PADDING, size.height -  CELL_BUBBLE_TOP_PADDING - CELL_BUBBLE_BOTTOM_PADDING - self.message.extendSize.height - CELL_BUBBLE_EXTEND_PADDING);
    
    if (self.extendView) {
        self.extendView.center = CGPointMake(size.width / 2, size.height - CELL_BUBBLE_BOTTOM_PADDING - self.message.extendSize.height / 2);
    }
    if (self.extendLine) {
        self.extendLine.frame = CGRectMake(0, self.extendView.frame.origin.y + CELL_BUBBLE_EXTEND_PADDING, size.width, CELL_BUBBLE_EXTEND_PADDING);
    }
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