//
//  EM+ChatListController.m
//  EaseMobUI 会话列表
//
//  Created by 周玉震 on 15/8/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatListController.h"
#import "EM+ChatController.h"

#import "EM+ChatTableView.h"
#import "EM+ConversationCell.h"

#import "EM+ChatMessageModel.h"

#import "EaseMobUIClient.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatDateUtils.h"

#import <MJRefresh/MJRefresh.h>

@interface EM_ChatListController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,EMChatManagerDelegate,EM_ChatTableViewTapDelegate,SWTableViewCellDelegate>

@property (nonatomic, assign) BOOL needReload;

@end

@implementation EM_ChatListController{
    UISearchDisplayController *_searchController;
    
    UISearchBar *_searchBar;
    EM_ChatTableView *_tableView;
    
    NSMutableArray *_searchResultArray;
    
    BOOL fromUser;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndCall:) name:kEMNotificationCallDismiss object:nil];
    
    _tableView = [[EM_ChatTableView alloc]initWithFrame:self.view.frame];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    _tableView.tapDelegate = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(didBeginRefresh)];
    _tableView.header = header;
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _tableView.tableHeaderView = _searchBar;
    
    _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchController.delegate = self;
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //好像需要加载两次才能够把数据加载出来？
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needReload) {
        [_tableView reloadData];
        self.needReload = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_searchBar.isFirstResponder) {
        [_searchController setActive:NO];
    }
}

- (void)dealloc{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)didEndCall:(NSNotification *)notification{
    NSString *chattar = notification.userInfo[kEMCallChatter];
    NSArray *conversations = [EaseMob sharedInstance].chatManager.conversations;
    for (int i = 0; i < conversations.count; i++) {
        EMConversation *conversation = conversations[i];
        if ([conversation.chatter isEqualToString:chattar]) {
            [_tableView reloadData];
            break;
        }
    }
}

- (void)reloadData{
    if ([EaseMob sharedInstance].chatManager.isLoggedIn) {
        [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    }
}

- (void)startRefresh{
    [_tableView.header beginRefreshing];
}

- (void)endRefresh{
    [_tableView.header endRefreshing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didEndRefresh)]) {
        [self.delegate didEndRefresh];
    }
}

- (void)didBeginRefresh{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartRefresh)]) {
        [self.delegate didStartRefresh];
    }
    //刷新数据
    [self reloadData];
    [self endRefresh];
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (index == 0) {
        EMConversation *conversation = [EaseMob sharedInstance].chatManager.conversations[indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:NO append2Chat:YES];
    }
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
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    EMConversation *conversation;
    if (tableView == _tableView) {
        conversation = [EaseMob sharedInstance].chatManager.conversations[indexPath.row];
        cell.hiddenBottomLine = indexPath.row != [EaseMob sharedInstance].chatManager.conversations.count - 1;
    }else{
        conversation = _searchResultArray[indexPath.row];
        cell.hiddenBottomLine = indexPath.row != _searchResultArray.count - 1;
    }
    
    cell.imageView.image = [EM_ChatResourcesUtils defaultAvatarImage];
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
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_image"];
        }
            break;
        case eMessageBodyType_Video:{
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_video"];
        }
            break;
        case eMessageBodyType_Voice:{
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_voice"];
        }
            break;
        case eMessageBodyType_File:{
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_file"];;
        }
            break;
        case eMessageBodyType_Location:{
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_location"];
        }
            break;
        default:{
            cell.detailTextLabel.text = [EM_ChatResourcesUtils stringWithName:@"common.message_type_diy"];
        }
            break;
    }
    
    cell.time = [EM_ChatDateUtils stringFormatterMessageDateFromTimeInterval:lastMessage.timestamp / 1000];
    
    return cell;
}

#pragma mark - UITableViewDelegate

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
        EM_ChatController *chatController = [[EM_ChatController alloc]initWithConversation:conversation];
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - EMChatManagerChatDelegate
- (void)didUpdateConversationList:(NSArray *)conversationList{
    //手动向会话添加消息时；
    if (self.isShow) {
        [_tableView reloadData];
    }else{
        self.needReload = YES;
    }
}

- (void)willSendMessage:(EMMessage *)message error:(EMError *)error{
    //会话列表显示消息发送状态，编辑状态
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
    
}

- (void)didReceiveMessage:(EMMessage *)message{
    
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    
}

- (void)didUnreadMessagesCountChanged{

}

#pragma mark - EMChatManagerBuddyDelegate
//好友增加或删除,特殊的会话消息

#pragma mark - EMChatManagerUtilDelegate
- (void)didConnectionStateChanged:(EMConnectionState)connectionState{
    
}

#pragma mark - EMChatManagerGroupDelegate
//群操作,特殊的会话消息

#pragma mark - EMChatManagerChatroomDelegate
//聊天室操作,特殊的会话消息

#pragma mark - EMChatManagerPushNotificationDelegate

@end