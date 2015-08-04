//
//  EM+ChatLatelyEmoji.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBase.h"
#import "EM+ChatVersion.h"

#define EMOJI_COLUMN_EMOJI      (@"emoji")
#define EMOJI_COLUMN_CALCULATE  (@"calculate")
#define EMOJI_COLUMN_USE_TIME   (@"useTime")

@interface EM_ChatLatelyEmoji : EM_ChatBase

@property (nonatomic,copy) NSString *emoji;
@property (nonatomic,assign) NSInteger calculate;
@property (nonatomic,assign) double useTime;

- (instancetype)initWithEmoji:(NSString *)emoji;

@end