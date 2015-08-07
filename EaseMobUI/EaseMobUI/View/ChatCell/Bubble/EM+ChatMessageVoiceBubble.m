//
//  EM+ChatMessageVoiceBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVoiceBubble.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatResourcesUtils.h"

@implementation EM_ChatMessageVoiceBubble{
    UIImageView *animationView;
    UILabel *timeLabel;
    UIButton *identifyButton;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    CGSize superSize = [super sizeForBubbleWithMessage:messageBody maxWithd:max];
    
    EMVoiceMessageBody *voiceBody = messageBody;
    CGSize size = CGSizeMake(voiceBody.duration * 2 + 88, superSize.height + 10);
    
    return size;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        animationView = [[UIImageView alloc]init];
        animationView.backgroundColor = [UIColor clearColor];
        animationView.animationDuration = 1;
        [self addSubview:animationView];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:timeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    CGSize timeSize = [timeLabel.text sizeWithAttributes:@{NSFontAttributeName:timeLabel.font}];
    timeSize.height = size.height - self.message.extendSize.height - CELL_BUBBLE_EXTEND_PADDING;
    
    if (self.message.sender) {
        timeLabel.frame = CGRectMake(0, 0, timeSize.width, timeSize.height);
        animationView.frame = CGRectMake(size.width - timeSize.height, 0, timeSize.height, timeSize.height);
    }else{
        timeLabel.frame = CGRectMake(size.width - timeSize.width, 0, timeSize.width, timeSize.height);
        animationView.frame = CGRectMake(0, 0, timeSize.height, timeSize.height);
    }
    
    if (self.extendView) {
        self.extendView.center = CGPointMake(size.width / 2, size.height - self.message.extendSize.height / 2);
    }
    if (self.extendLine) {
        self.extendLine.frame = CGRectMake(0, self.extendView.frame.origin.y + CELL_BUBBLE_EXTEND_PADDING, size.width, CELL_BUBBLE_EXTEND_PADDING);
    }
}

- (NSString *)handleAction{
    return HANDLE_ACTION_VOICE;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody *)message.messageBody;

    NSString *time;
    if (voiceBody.duration < 60) {
        time = [NSString stringWithFormat:@"%ld\"",voiceBody.duration];
    }else{
        time = [NSString stringWithFormat:@"%ld\'%ld\"",voiceBody.duration / 60,voiceBody.duration % 60];
    }
    timeLabel.text = time;
    
    if (self.message.sender) {
        [animationView setAnimationImages:@[
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_1"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_2"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_right_3"]
                                            ]];
        animationView.image = [EM_ChatResourcesUtils cellImageWithName:@"voice_right_3"];
    }else{
        [animationView setAnimationImages:@[
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_1"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_2"],
                                            [EM_ChatResourcesUtils cellImageWithName:@"voice_left_3"]
                                            ]];
        animationView.image = [EM_ChatResourcesUtils cellImageWithName:@"voice_left_3"];
    }
    if (self.message.messageData.checking && !animationView.isAnimating) {
        [animationView startAnimating];
    }else{
        [animationView stopAnimating];
    }
}
@end