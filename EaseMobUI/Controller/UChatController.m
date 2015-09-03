//
//  MainController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UChatController.h"
#import "UserCustomExtend.h"

@interface UChatController ()<EM_ChatControllerDelegate>

@end

@implementation UChatController

- (instancetype)initWithConversation:(EMConversation *)conversation{
    self = [super initWithConversation:conversation];
    if (self) {
        self.delegate = self;
        EM_ChatMessageExtend *extend = [[UserCustomExtend alloc]init];
        extend.showBody = YES;
        extend.showExtend = NO;
    }
    return self;
}

- (instancetype)initWithOpposite:(EM_ChatOpposite *)opposite{
    self = [super initWithOpposite:opposite];
    if (self) {
        self.delegate = self;
        EM_ChatMessageExtend *extend = [[UserCustomExtend alloc]init];
        extend.showBody = YES;
        extend.showExtend = NO;
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
- (EM_ChatMessageExtend *)extendForMessage:(id)body messageType:(MessageBodyType)type{
    EM_ChatMessageExtend *extend = [[UserCustomExtend alloc]init];
    extend.showBody = YES;
    extend.showExtend = YES;
    return extend;
}

- (void)didActionSelectedWithName:(NSString *)name{
    
}

- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn{
    
}

- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo{
    
}

- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo{
    
}

@end