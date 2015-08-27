//
//  UBuddyListController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UBuddyListController.h"
#import "UChatController.h"
#import "EaseMob.h"

#import "EM+ChatOppositeTag.h"
#import "EM+ChatBuddy.h"

@interface UBuddyListController ()<EM_ChatBuddyListControllerDataSource,EM_ChatBuddyListControllerDelegate,EMChatManagerDelegate>

@property (nonatomic, assign) BOOL needReload;

@end

@implementation UBuddyListController{
    NSArray *tags;
    NSMutableArray *buddyArray;
    NSMutableArray *searchArray;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        tags = @[@"新朋友",@"特别关心",@"群组",@"黑名单"];
        
        buddyArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 2; i++) {
            [buddyArray addObject:[[NSMutableDictionary alloc]initWithDictionary:@{@"groupName":[NSString stringWithFormat:@"我的好友%d",i + 1],
                                                                                   @"groupExpand":@(NO),
                                                                                   @"buddys":[[NSMutableArray alloc]init]}]];
        }
        searchArray = [[NSMutableArray alloc]init];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needReload) {
        [self reloadOppositeList];
        self.needReload = NO;
    }
}

#pragma mark - EM_ChatBuddyListControllerDataSource
- (BOOL)shouldShowSearchBar{
    return YES;
}

- (BOOL)shouldShowTagBar{
    return YES;
}

//search
- (NSInteger)numberOfRowsForSearch{
    return searchArray.count;
}

- (EM_ChatOpposite *)dataForSearchRowAtIndex:(NSInteger)index{
    return searchArray[index];
}

- (NSInteger)numberOfTags{
    return tags.count;
}

- (NSString *)titleForTagAtIndex:(NSInteger)index{
    return tags[index];
}

//opposite
- (NSInteger)numberOfGroups{
    return buddyArray.count;
}

- (NSString *)titleForGroupAtIndex:(NSInteger)index{
    NSDictionary *info = buddyArray[index];
    return info[@"groupName"];
}

- (NSInteger)numberOfRowsAtGroupIndex:(NSInteger)groupIndex{
    NSDictionary *info = buddyArray[groupIndex];
    BOOL expand = [info[@"groupExpand"] boolValue];
    if (expand) {
        return [info[@"buddys"] count];
    }else{
        return 0;
    }
}

- (EM_ChatOpposite *)dataForRow:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex{
    NSMutableDictionary *info = buddyArray[groupIndex];
    NSArray *buddys = info[@"buddys"];
    return buddys[rowIndex];
}

#pragma mark - EM_ChatBuddyListControllerDelegate
- (BOOL)shouldReloadSearchForSearchString:(NSString *)searchString{
    if (searchString) {
        [searchArray removeAllObjects];
        
        for (int i = 0; i < buddyArray.count; i++) {
            NSDictionary *info = buddyArray[i];
            NSArray *buddys = info[@"buddys"];
            for (EM_ChatBuddy *buddy in buddys) {
                if ([buddy.displayName containsString:searchString]) {
                    [searchArray addObject:buddy];
                    continue;
                }
                if ([buddy.remarkName containsString:searchString]){
                    [searchArray addObject:buddy];
                    continue;
                }
                if ([buddy.uid containsString:searchString]){
                    [searchArray addObject:buddy];
                    continue;
                }
            }
        }
    }
    return YES;
}

- (void)didSelectedForSearchRowAtIndex:(NSInteger)index{
    EM_ChatBuddy *buddy = searchArray[index];
    UChatController *chatController = [[UChatController alloc]initWithOpposite:buddy config:nil];
    [self.navigationController pushViewController:chatController animated:YES];
}

//opposite
- (void)didSelectedForGroupAtIndex:(NSInteger)groupIndex{
    NSDictionary *info = buddyArray[groupIndex];
    BOOL expand = [info[@"groupExpand"] boolValue];
    [info setValue:@(!expand) forKey:@"groupExpand"];
    [self reloadOppositeList];
}

- (void)didSelectedForRowAtIndex:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex{
    NSMutableDictionary *info = buddyArray[groupIndex];
    NSArray *buddys = info[@"buddys"];
    EM_ChatBuddy *buddy = buddys[rowIndex];
    UChatController *chatController = [[UChatController alloc]initWithOpposite:buddy config:nil];
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - EMChatManagerBuddyDelegate
- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error{
    for (int i = 0;i < buddyList.count;i++) {
        EMBuddy *emBuddy = buddyList[i];
        EM_ChatBuddy *buddy = [[EM_ChatBuddy alloc]init];
        buddy.uid = emBuddy.username;
        buddy.nickName = emBuddy.username;
        buddy.remarkName = emBuddy.username;
        buddy.displayName = buddy.remarkName;
        buddy.intro = @"[在线]最新动态";
        
        
        NSDictionary *info = buddyArray[i % 2];
        NSMutableArray *buddys = info[@"buddys"];
        
        if (![buddys containsObject:buddy]) {
            [buddys addObject:buddy];
        }
    }
    
    if (self.isShow) {
        [self reloadOppositeList];
    }else{
        self.needReload = YES;
    }
}

- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd{
    
}

- (void)didRemovedByBuddy:(NSString *)username{
    
}

@end