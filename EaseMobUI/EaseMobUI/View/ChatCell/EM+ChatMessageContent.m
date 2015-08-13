//
//  EM+ChatMessageContent.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/12.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageContent.h"

@implementation EM_ChatMessageContent{
    UITapGestureRecognizer *tap;
    UILongPressGestureRecognizer *longPress;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.needTap = YES;
        self.needLongPress = YES;
        self.needMenu = YES;
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap:)];
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLongPress:)];
        [tap requireGestureRecognizerToFail:longPress];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == tap) {
        return self.needTap;
    }else if(gestureRecognizer == longPress){
        return self.needLongPress;
    }else{
        return NO;
    }
}

- (void)contentTap:(UITapGestureRecognizer *)recognizer{
    
}

- (void)contentLongPress:(UILongPressGestureRecognizer *)recognizer{
    
}

@end
