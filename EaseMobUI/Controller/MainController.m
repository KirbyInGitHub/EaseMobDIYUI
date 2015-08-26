//
//  MainController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "MainController.h"
#import "UChatListController.h"
#import "UBuddyListController.h"

@interface MainController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation MainController{
    EM_ChatListController *chatController;
    EM_BuddyListController *buddysController;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    chatController = [[UChatListController alloc]init];
    UINavigationController *narChatController = [[UINavigationController alloc]initWithRootViewController:chatController];
    
    buddysController = [[UBuddyListController alloc]init];
    UINavigationController *narBuddysController = [[UINavigationController alloc]initWithRootViewController:buddysController];
    
    self.controllers = @[narChatController,narBuddysController];
    self.viewControllers = self.controllers;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}

@end