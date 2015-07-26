//
//  EM+ChatMessageVoiceBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVoiceBubble.h"
#import "EM+ChatUIConfig.h"


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
    if (self.message.sender) {
        timeLabel.frame = CGRectMake(0, 0, timeSize.width, size.height);
        animationView.frame = CGRectMake(size.width - size.height, 0, size.height, size.height);
    }else{
        timeLabel.frame = CGRectMake(size.width - size.height, 0, timeSize.width, size.height);
        animationView.frame = CGRectMake(0, 0, size.height, size.height);
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
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_left_1")],
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_left_2")],
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_left_3")]
                                            ]];
        animationView.image = [UIImage imageNamed:RES_IMAGE_CELL(@"voice_left_3")];
    }else{
        [animationView setAnimationImages:@[
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_right_1")],
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_right_2")],
                                            [UIImage imageNamed:RES_IMAGE_CELL(@"voice_right_3")]
                                            ]];
        animationView.image = [UIImage imageNamed:RES_IMAGE_CELL(@"voice_right_3")];
    }
    if (self.message.messageDetailsState.checking && !animationView.isAnimating) {
        [animationView startAnimating];
    }else{
        [animationView stopAnimating];
    }
}
@end