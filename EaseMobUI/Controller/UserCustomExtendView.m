//
//  UserCustomExtendView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UserCustomExtendView.h"
#import "EM+ChatMessageModel.h"
#import "UserCustomExtend.h"

@implementation UserCustomExtendView{
    UILabel *label;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    label.frame = self.bounds;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    UserCustomExtend *extend = (UserCustomExtend *)message.extend;
    label.text = extend.extendProperty;
}

@end