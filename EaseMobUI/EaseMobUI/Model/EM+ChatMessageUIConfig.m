//
//  EM+ChatCellUIConfig.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/13.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageUIConfig

+ (instancetype)defaultConfig{
    EM_ChatMessageUIConfig *config = [[EM_ChatMessageUIConfig alloc]init];
    config.avatarStyle = EM_AVATAR_STYLE_CIRCULAR;
    config.messageAvatarSize = 50;
    config.messagePadding = 10;
    config.messageTopPadding = 20;
    config.messageTimeLabelHeight = 20;
    config.messageNameLabelHeight = 20;
    config.messageIndicatorSize = 10;
    config.messageTailWithd = 15;
    
    config.bubblePadding = 5;
    config.bubbleTextFont = 16;
    config.bubbleTextLineSpacing = 2;
    config.bubbleTextPadding = 2;
    return config;
}

@end