//
//  EM+FriendsController.m
//  EaseMobUI 好友列表
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+BuddyController.h"
#import "EM+ChatController.h"

#import "MJRefresh.h"
#import "EM+ChatBuddyHeader.h"
#import "EM+ChatBuddyCell.h"
#import "EM+ChatTableView.h"
#import "EM+ChatBuddyTableHeader.h"

#import "EaseMobUIClient.h"
#import "EaseMob.h"

#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"

@interface EM_BuddyController ()
<UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
EMChatManagerDelegate,
EM_ChatTableViewTapDelegate,
EM_ChatBuddyTableHeaderDelegate>

@end

@implementation EM_BuddyController{
    UISearchDisplayController *_searchController;
    
    EM_ChatTableView *_tableView;
    EM_ChatBuddyTableHeader *_tableHeader;
    
    NSMutableArray *_buddyArray;
    NSMutableArray *_searchResultArray;
    NSMutableArray *_groupArray;
    NSMutableDictionary *_groupBuddy;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = [EM_ChatResourcesUtils stringWithName:@"common.contact"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[EM_ChatTableView alloc]initWithFrame:self.view.frame];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tapDelegate = self;
    [self.view addSubview:_tableView];
    
    
    NSMutableArray *tags = [[NSMutableArray alloc]init];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagsForChatBuddy)]) {
        NSArray *userTags = [self.delegate tagsForChatBuddy];
        [tags addObjectsFromArray:userTags];
    }else{
        [tags addObjectsFromArray:[EM_ChatBuddyTagModel defaultTags]];
    }
    
    _tableHeader = [[EM_ChatBuddyTableHeader alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / 4 + (IS_PAD ? 60 : 44)) tags:tags];
    _tableView.tableHeaderView = _tableHeader;
    
    _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_tableHeader.searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    if ([EaseMobUIClient sharedInstance].buddyDelegate &&
        [[EaseMobUIClient sharedInstance].buddyDelegate respondsToSelector:@selector(listForChatBuddy)]) {
        _buddyArray = [[NSMutableArray alloc]initWithArray:[[EaseMobUIClient sharedInstance].buddyDelegate listForChatBuddy]];
    }else{
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
    }
    
    _groupArray = [[NSMutableArray alloc]init];
    [_groupArray addObjectsFromArray:[EM_ChatBuddyGroupModel defaultGroup]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupsForChatBuddy)]) {
        [_groupArray addObjectsFromArray:[self.delegate groupsForChatBuddy]];
    }
    
    _groupBuddy = [[NSMutableDictionary alloc]init];
    [self groupProcess];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_tableHeader.searchBar.isFirstResponder){
        [_searchController setActive:NO];
    }
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)groupProcess{
    if (_buddyArray && _buddyArray.count > 0) {
        for (int i = 0; i < _buddyArray.count; i++) {
            EM_ChatBuddyModel *buddy = _buddyArray[i];
            EM_ChatBuddyGroupModel *group = buddy.group;
            NSMutableArray *buddys = _groupBuddy[group.sign];
            if (!buddys) {
                buddys = [[NSMutableArray alloc]init];
                [_groupBuddy setObject:buddys forKey:group.sign];
            }
            [buddys addObject:buddy];
        }
    }
}

#pragma mark - UISearchDisplayDelegate
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [controller.searchBar removeFromSuperview];
    controller.searchBar.frame = CGRectMake(0, 0, _tableHeader.frame.size.width, IS_PAD ? 60 : 44);
    [_tableHeader addSubview:controller.searchBar];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    [_searchResultArray removeAllObjects];
    
    for (EM_ChatBuddyModel *buddy in _buddyArray) {
        NSRange range = [buddy.userName rangeOfString:searchString];
        if (range.location != NSNotFound) {
            [_searchResultArray addObject:buddy];
            continue;
        }
        
        range = [buddy.nickName rangeOfString:searchString];
        if (range.location != NSNotFound) {
            [_searchResultArray addObject:buddy];
            continue;
        }
        
        range = [buddy.remarkName rangeOfString:searchString];
        if (range.location != NSNotFound) {
            [_searchResultArray addObject:buddy];
            continue;
        }
    }
    return YES;
}

#pragma mark - EM_ChatBuddyTableHeaderDelegate
- (void)didSelectedWithBuddyTag:(EM_ChatBuddyTagModel *)tag{
    if ([tag.name isEqualToString:kEMChatBuddyTagNameNewBuddy]) {
        
    }else if ([tag.name isEqualToString:kEMChatBuddyTagNameCarefor]) {
        
    }else if ([tag.name isEqualToString:kEMChatBuddyTagNameGroup]) {
        
    }else if ([tag.name isEqualToString:kEMChatBuddyTagNameBlacklist]) {
        
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithTag:)]) {
            [self.delegate didSelectedWithTag:tag];
        }
    }
}

#pragma mark - EM_ChatTableViewTapDelegate
- (void)chatTableView:(EM_ChatTableView *)table didTapEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_tableHeader.searchBar.isFirstResponder) {
        [_tableHeader.searchBar resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return  _groupArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        EM_ChatBuddyGroupModel *group = _groupArray[section];
        
        if (group.expand) {
            NSArray *buddys = _groupBuddy[group.sign];
            return buddys.count;
        }else{
            return 0;
        }
    }else{
        return _searchResultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"buddy";
    EM_ChatBuddyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[EM_ChatBuddyCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    EM_ChatBuddyModel *buddy;
    if (tableView == _tableView) {
        EM_ChatBuddyGroupModel *group = _groupArray[indexPath.section];
        NSArray *buddys = _groupBuddy[group.sign];
        buddy = buddys[indexPath.row];
    }else{
        buddy = _searchResultArray[indexPath.row];
    }
    cell.name = buddy.userName;
    cell.details = @"[在线] 最新动态";
    cell.avatarImage = buddy.avatarImage;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        static NSString *headerIdentifier = @"header";
        EM_ChatBuddyHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
        if (!header) {
            header = [[EM_ChatBuddyHeader alloc]initWithReuseIdentifier:headerIdentifier];
        }
        EM_ChatBuddyGroupModel *group = _groupArray[section];
        header.section = section;
        header.title = group.title;
        [header setChatBuddyHeaderBlock:^(NSInteger section) {
            EM_ChatBuddyGroupModel *group = _groupArray[section];
            group.expand = !group.expand;
            MAIN(^{
                [_tableView reloadData];
            });
        }];
        return header;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EM_ChatBuddyModel *buddy;
    if (tableView == _tableView) {
        EM_ChatBuddyGroupModel *group = _groupArray[indexPath.section];
        NSArray *buddys = _groupBuddy[group.sign];
        buddy = buddys[indexPath.row];
    }else{
        buddy = _searchResultArray[indexPath.row];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithBuddy:)]) {
        [self.delegate didSelectedWithBuddy:buddy];
    }else{
        EM_ChatController *chatController = [[EM_ChatController alloc]initWithBuddy:buddy config:nil];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - EMChatManagerDelegate

#pragma mark - EMChatManagerBuddyDelegate
- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error{
    NSMutableArray *buddys = [[NSMutableArray alloc]init];
    for (int i = 0; i < buddyList.count; i++) {
        EMBuddy *emBuddy = buddyList[i];
        
        EM_ChatBuddyModel *buddy;
        if ([EaseMobUIClient sharedInstance].buddyDelegate && [[EaseMobUIClient sharedInstance].buddyDelegate respondsToSelector:@selector(buddyWithChatter:)]) {
            buddy = [[EaseMobUIClient sharedInstance].buddyDelegate buddyWithChatter:emBuddy.username];
        }else{
            buddy = [[EM_ChatBuddyModel alloc]init];
            buddy.userName = emBuddy.username;
            buddy.nickName = emBuddy.username;
            buddy.remarkName = emBuddy.username;
            buddy.avatarImage = [EM_ChatResourcesUtils cellImageWithName:@"avatar_default"];
        }
        
        [buddys addObject:buddy];
    }
    
    _buddyArray = buddys;
    [self groupProcess];
    MAIN(^{
        [_tableView reloadData];
    });
}

@end
