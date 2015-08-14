//
//  MainController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UStylistChatController.h"
#import "UserCustomExtend.h"

@interface UStylistChatController ()<EM_ChatControllerDelegate>

@end

@implementation UStylistChatController

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType config:(EM_ChatUIConfig *)config{
    self = [super initWithChatter:chatter conversationType:conversationType config:config];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#define mark - EM_ChatControllerDelegate
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}

- (NSString *)avatarWithChatter:(NSString *)chatter{
    return nil;
}

- (EM_ChatMessageExtend *)extendForMessage:(id)body messageType:(MessageBodyType)type{
    EM_ChatMessageExtend *extend = [[UserCustomExtend alloc]init];
    extend.showBody = YES;
    extend.showExtend = YES;
    return extend;
}

- (void)didActionSelectedWithName:(NSString *)name{
    
}

@end