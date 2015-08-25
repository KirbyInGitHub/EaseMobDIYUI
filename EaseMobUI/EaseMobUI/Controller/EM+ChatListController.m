//
//  EM+ConversationListController.m
//  EaseMobUI 会话列表
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatListController.h"
#import "EM+ChatController.h"

#import "EaseMobUIClient.h"
#import "EaseMob.h"

#import "MJRefresh.h"
#import "EM+ChatTableView.h"
#import "EM+ConversationCell.h"

#import "EM+ChatMessageModel.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"

@interface EM_ChatListController ()
<UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
EMChatManagerDelegate,
EM_ChatTableViewTapDelegate>

@end

@implementation EM_ChatListController{
    UISearchDisplayController *_searchController;
    
    EM_ChatTableView *_tableView;
    UISearchBar *_searchBar;
    
    EaseMobUIClient *_uiClient;
    
    NSMutableArray *_searchResultArray;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = [EM_ChatResourcesUtils stringWithName:@"common.message"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[EM_ChatTableView alloc]initWithFrame:self.view.frame];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tapDelegate = self;
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _tableView.tableHeaderView = _searchBar;
    
    _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    _uiClient = [EaseMobUIClient sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([EaseMob sharedInstance].chatManager.isLoggedIn) {
        [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
        [_tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    [_searchResultArray removeAllObjects];
    
    NSArray *search = [[EaseMob sharedInstance].chatManager searchMessagesWithCriteria:searchString];
    for (EMMessage *message in search) {
        EMMessageType messageType = message.messageType;
        EMConversationType conversationType;
        if (messageType == eMessageTypeGroupChat) {
            conversationType = eConversationTypeGroupChat;
        }else if (messageType == eMessageTypeChatRoom){
            conversationType = eConversationTypeChatRoom;
        }else{
            conversationType = eConversationTypeChat;
        }
        
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:message.conversationChatter conversationType:conversationType];
        if (![_searchResultArray containsObject:conversation]) {
            [_searchResultArray addObject:conversation];
        }
    }
    return YES;
}

#pragma mark - EM_ChatTableViewTapDelegate
- (void)chatTableView:(EM_ChatTableView *)table didTapEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return [EaseMob sharedInstance].chatManager.conversations.count;
    }else{
        return _searchResultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"conversation";
    EM_ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EM_ConversationCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    EMConversation *conversation;
    if (tableView == _tableView) {
        conversation = [EaseMob sharedInstance].chatManager.conversations[indexPath.row];
    }else{
        conversation = _searchResultArray[indexPath.row];
    }
    
    cell.imageView.image = [EM_ChatResourcesUtils cellImageWithName:@"avatar_default"];
    cell.textLabel.text = conversation.chatter;
    EMMessage *lastMessage = [conversation latestMessage];
    EM_ChatMessageModel *message = [EM_ChatMessageModel fromEMMessage:lastMessage];
    switch (message.messageBody.messageBodyType) {
        case eMessageBodyType_Text:{
            EMTextMessageBody *body = (EMTextMessageBody *)message.messageBody;
            cell.detailTextLabel.text = body.text;
        }
            break;
        case eMessageBodyType_Image:{
            cell.detailTextLabel.text = @"[图片]";
        }
            break;
        case eMessageBodyType_Video:{
            cell.detailTextLabel.text = @"[视频]";
        }
            break;
        case eMessageBodyType_Voice:{
            cell.detailTextLabel.text = @"[语音]";
        }
            break;
        case eMessageBodyType_File:{
            cell.detailTextLabel.text = @"[文件]";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *conversation;
    if (tableView == _tableView) {
        conversation = [EaseMob sharedInstance].chatManager.conversations[indexPath.row];
    }else{
        conversation = _searchResultArray[indexPath.row];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithConversation:)]) {
        [self.delegate didSelectedWithConversation:conversation];
    }else{
        EM_ChatController *chatController = [[EM_ChatController alloc]initWithConversation:conversation config:nil];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - EMChatManagerDelegate

#pragma mark - EMChatManagerLoginDelegate
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    if (!error) {
        [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
        MAIN(^{
            [_tableView reloadData];
        });
    }
}

@end