//
//  UBuddyListController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UBuddyListController.h"
#import "EaseMob.h"

#import "EM+ChatOppositeTag.h"

@interface UBuddyListController ()
<EM_ChatBuddyListControllerDataSource,
EM_ChatBuddyListControllerDelegate,
EMChatManagerDelegate>

@end

@implementation UBuddyListController{
    NSArray *tags;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        tags = @[@"新朋友",@"特别关心",@"群组",@"黑名单"];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark - EM_ChatBuddyListControllerDataSource
- (BOOL)shouldShowSearchBar{
    return YES;
}

- (BOOL)shouldShowTagBar{
    return NO;
}

//search
- (NSInteger)numberOfRowsForSearch{
    return 0;
}

- (EM_ChatOpposite *)dataForSearchRowAtIndex:(NSInteger)index{
    return nil;
}

//opposite
- (NSInteger)numberOfGroups{
    return 1;
}

- (NSString *)titleForGroupAtIndex:(NSInteger)index{
    return @"我的好友";
}

- (NSInteger)numberOfRowsAtGroupIndex:(NSInteger)groupIndex{
    return 1;
}

- (EM_ChatOpposite *)dataForRow:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex{
    return nil;
}

#pragma mark - EM_ChatBuddyListControllerDelegate
- (BOOL)shouldReloadSearchForSearchString:(NSString *)searchString{
    if (searchString) {
        
    }
    return YES;
}

- (void)didSelectedForSearchRowAtIndex:(NSInteger)index{
    
}

//opposite
- (void)didSelectedForGroupAtIndex:(NSInteger)groupIndex{
    
}

- (void)didSelectedForRowAtIndex:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex{
    
}

#pragma mark - EMChatManagerBuddyDelegate

@end