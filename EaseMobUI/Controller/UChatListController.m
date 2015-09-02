//
//  UStylistChatListController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UChatListController.h"
#import "UChatController.h"

@interface UChatListController ()<EM_ChatListControllerDelegate>

@end

@implementation UChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - EM_ChatListControllerDelegate
- (void)didSelectedWithConversation:(EMConversation *)conversation{
    UChatController *chatController = [[UChatController alloc]initWithConversation:conversation];
    [self.navigationController pushViewController:chatController animated:YES];
}

@end