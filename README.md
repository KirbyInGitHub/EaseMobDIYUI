#EaseMobDIYUI
@(EaseMob)[自定义聊天UI|简单继承|pod]
- **[LeanCloud](https://leancloud.cn/)**：LeanCloud 实时消息只需几行代码，就可使用户的应用完成移动 IM 的功能添加。 IM 系统与当前用户系统完全解耦，无需同步或修改现有用户体系，即可使用；除 iOS、Android 移动开发的原生 SDK 之外，还也支持网页内聊天。
- **[融云](http://www.rongcloud.cn/)**：融云是国内首家专业的即时通讯云服务提供商，专注为互联网、移动互联网开发者提供即时通讯基础能力和云端服务。通过融云平台，开发者不必搭建服务端硬件环境，就可以将即时通讯、实时网络能力快速集成至应用中 针对开发者所需的不同场景，融云平台提供了一系列产品、技术解决方案，包括：客户端 IM组件，客户端 IM 基础库，服务端 RESTAPI，客户端实时网络通讯基础库等。利用这些解决方案，开发者可以直接在自己的应用中构建出即时通讯产品，也可以无限创意出自己的即时通讯场景。 融云 SDK 包括两部分：IM 界面组件和 IM 能力库。
- **[环信](http://www.easemob.com/)**：环信即时通讯云是移动即时通讯能力的云计算 PaaS (Platform as a Service, 平台即服务)平台服务商。移动即时通讯能力是指基于互联网和移动终端的单聊，群聊，富媒体消息，实时语音，实时视频，多人语音视频，流媒体播放及互动等通讯能力。环信将移动即时通讯能力通过云端开放的API 和客户端 SDK 包的方式提供给开发者和企业，帮助合作伙伴在自己的产品中便捷、快速的实现通讯和社交功能
- **[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)**：[LeanCloud](https://leancloud.cn/)、[融云](http://www.rongcloud.cn/)、[环信](http://www.easemob.com/)是我用过IM平台，也是当前比较受欢迎的三个IM平台。通过对比它们的优缺点，还是非常明显的。[LeanCloud](https://leancloud.cn/)免费内容太少，超过500用户就要收费，SDK支持的平台倒是挺多的。[融云](http://www.rongcloud.cn/)还不错，在1.0时代有太多的问题，有幸看到过它们的UI代码，写的比较烂。没有WinPhone的支持， Server SDK支持也比较多。[环信](http://www.easemob.com/)在免费内容上和融云做得差不多，SDK 的API也不错，但是没有让开发者直接拿来继承使用的UI（只是有个Demo，但是直接使用太麻烦，如果能pod得话就更好，这也是我现在写这个项目的初衷）。

---
* [简介](#1) 
    * [环信SDK](#1.1) 
    * [额外功能](#1.2) 
* [使用](#2)
    * [要求](#2.1) 
    * [pod](#2.2) 
    * [依赖](#2.3) 
    * [初始化及权限](#2.4) 
        * [初始化](#2.4.1)
        * [权限](#2.4.2)
    * [会话列表](#2.5)   
    * [好友列表](#2.6) 
    * [聊天界面](#2.7)
        * [配置文件](#2.7.1)
    * [自定义扩展](#2.8)
    * [UI](#2.9)
* [期望](#3)
  
<h2 id = "1">简介</h2>
集成环信的即时通讯功能，pod集成，方便管理。简单继承，轻松定制自己的UI界面。当前最新版本```0.2.1```,主要由会话列表(```EM_ConversationListController```)、好友列表(```EM_FriendsController```)和聊天界面(```EM_ChatController```)组成。很多功能和界面都在开发中，聊天界面的UI也没有开发完善，所以现在显示很挫。在```1.0.0```版本之前会完成所有可以使用环信SDK实现的功能，并且加入其它实用的功能，在此之前也不适合使用。当然你也可以参考环信的[Demo](http://www.easemob.com/downloads)。

<h3 id = "1.1">环信SDK</h3>
使用pod集成的[EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)，集成版本```2.1.7```。因为pod集成[EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods)是没有语音和视频通讯功能的。

<h3 id = "1.2">额外功能</h3>
- 会话编辑状态保存
- 最近Emoji表情的保存
- 自定义扩展View，由环信的消息扩展来决定
- 语音消息发送之前的播放
- 自定义Action，除了图片、相机、语音、视频、位置和文件等Action外，可以额外添加其它Action，View会根据数量来自动增加翻页
- 语音识别（未实现）
- 文件浏览器
- WiFi文件上传
- .......

<h2 id = "2">使用</h2>
<h3 id = "2.1">要求</h3>
iOS版本7.0以上
<h3 id = "2.2">pod</h3>
```
pod 'EaseMobDIYUI', :git => 'https://github.com/AwakenDragon/EaseMobDIYUI.git'
```
```
pod 'VoiceConvert',:git => "https://github.com/AwakenDragon/VoiceConvert.git"
```

*PS:语音消息的播放需要[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能模块，开始我试图直接把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能代码放到项目里使用，但在制作成pod并使用的时候，总是报找不到相关类库文件的错误。无奈只能单独将[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能做成pod来集成。但在制作[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的pod的时候，没有办法把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)作为依赖添加进入，所以只能要求使用者，在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI) 的时候，同时pod [VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)。后期，我会想办法修复这个问题，好可以只pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)。*

<h3 id = "2.3">依赖</h3>
在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的时候，EaseMobSDKFull已经添加了以下依赖：
- ```"EaseMobSDKFull", "2.1.7"``` 不解释 [EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)
- ```"SDWebImage", "3.7.3"``` 用来加载图片的 [SDWebImage](https://github.com/rs/SDWebImage)
- ```"MJRefresh", "2.0.4"``` 上拉下拉，相信你也会用到 [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
- ```"MWPhotoBrowser", "2.1.1"``` 图片浏览，同时也支持视频播放 [MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)
- ```"MBProgressHUD", "0.9.1"``` 主要还是toast功能 [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
- ```"TTTAttributedLabel", "1.13.4"``` 富文本显示 [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)
- ```"FXBlurView","1.6.3"``` 毛玻璃效果  [FXBlurView](https://github.com/nicklockwood/FXBlurView)

所以你不需要再额外pod这些了。

**注意：**在pod完成开始运行的时候， [EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)
的一个文件*```EMErrorDefs.h```*可能会报错，具体原因是几个枚举没有或者重复。

**解决办法：**从环信最新的SDK([EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods) )中拿到这个文件，然后进入自己项目[EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)的对应pod目录，覆盖掉该文件即可。虽然在```XCode```里不允许修改pod的文件，但这样做事没有问题的。

**文件目录：**
- ```EaseMobSDK --> include --> Utility --> ErrorManager --> EMErrorDefs.h``` 
- ```你项目根目录 --> Pods --> EaseMobSDKFull --> EaseMobSDKFull --> include --> Utility --> ErrorManager --> EMErrorDefs.h```

<h3 id = "2.4">初始化及权限</h3>
<h4 id = "2.4.1">初始化</h4>
在```AppDelegate```中初始化

```
#import "AppDelegate.h"
#import "EaseMobUIClient.h"
#import "EaseMob.h"

@interface AppDelegate ()<EM_ChatUserDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    //初始化，并设置用户代理
    [EaseMobUIClient sharedInstance].userDelegate = self;
    [EaseMobUIClient sharedInstance].oppositeDelegate = self;

    //初始化环信
    [[EaseMob sharedInstance] registerSDKWithAppKey:EaseMob_AppKey apnsCertName:EaseMob_APNSCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    //登录环信
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"你的用户名" password:@"你的密码" completion:^(NSDictionary *loginInfo, EMError *error) {
    } onQueue:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMobUIClient sharedInstance] applicationWillTerminate:application];
}

#pragma mark - EM_ChatUserDelegate
- (EM_ChatUser *)userForEMChat{
    EM_ChatUser *user = [[EM_ChatUser alloc]init];
    user.uid = @"唯一标示";
    user.avatar = @"头像地址";
    user.displayName = @"要显示的名字";
    user.intro = @"一些简介";
    return user;
}

#pragma mark - EM_ChatOppositeDelegate
/**
 *  根据chatter返回好友信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter{
    
}

/**
 *  根据chatter返回群信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatGroup *)groupInfoWithChatter:(NSString *)chatter{
    
}

/**
 *  根据chatter返回群中好友信息
 *
 *  @param chatter
 *  @param group
 *
 *  @return
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inGroup:(EM_ChatGroup *)group{
    
}

/**
 *  根据chatter返回讨论组信息
 *
 *  @param chatter
 *
 *  @return
 */
- (EM_ChatRoom *)roomInfoWithChatter:(NSString *)chatter{
    
}

/**
 *  根据chatter返回讨论组成员信息
 *
 *  @param chatter
 *  @param room
 *
 *  @return 
 */
- (EM_ChatBuddy *)buddyInfoWithChatter:(NSString *)chatter inRoom:(EM_ChatRoom *)room{
    
}


@end
```
环信的部分API仍然需要自己去调用，比如初始化及登录方法。具体其他的环信API调用请参考环信的[官方文档](http://www.easemob.com/docs/ios/IOSSDKPrepare/)。
<h4 id = "2.4.2">权限</h4>
为了功能的正常时候，我们需要以下全下
- **位置**    *在Info.plist中添加NSLocationAlwaysUsageDescription(始终允许使用)、NSLocationWhenInUseUsageDescription(使用期间允许使用)*
- **照片**
- **麦克风**
- **相机**
- **通知**    *注册APNS*
- **后台应用程序刷新**  *在Info.plist中添加Required background modes 并添加App plays audio or streams audio/video using AirPlay、App downloads content in response to push notifications和App provides Voice over IP services三项；或者在Capabilities中打开Background Models，勾选Audio and Airplay、Voice over IP和Remote notifications*
- **使用蜂窝移动数据**

<h3 id = "2.5">会话列表</h3>
```
EM_ChatListController
```
会话列表
```
#import "EM+ChatBaseController.h"
@class EMConversation;

@protocol EM_ChatListControllerDelegate;

@interface EM_ChatListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatListControllerDelegate> delegate;

/**
 *  重新加载会话
 */
- (void)reloadData;

/**
 *  开始下拉刷新
 */
- (void)startRefresh;

/**
 *  结束下拉刷新
 */
- (void)endRefresh;

@end

@protocol EM_ChatListControllerDelegate <NSObject>

@required

@optional

/**
 *  选中某一会话
 *
 *  @param conversation
 */
- (void)didSelectedWithConversation:(EMConversation *)conversation;

/**
 *  开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  结束下拉刷新
 */
- (void)didEndRefresh;

@end
```
继承
```
#import "EM+ChatListController.h"

@interface CustomChatListController : EM_ChatListController

@end
```
```
#import "CustomChatListController.h"
#import "CustomChatController.h"

@interface CustomChatListController ()<EM_ChatListControllerDelegate>

@end

@implementation CustomChatListController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - EM_ChatListControllerDelegate
- (void)didSelectedWithConversation:(EMConversation *)conversation{
    UChatController *chatController = [[UChatController alloc]initWithConversation:conversation];
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
```
![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/chat_list.png?raw=true)

<h3 id = "2.6">好友列表</h3>
```
EM_BuddyListController
```
好友列表
```
#import "EM+ChatBaseController.h"
@class EM_ChatOpposite;

@protocol EM_ChatBuddyListControllerDataSource;
@protocol EM_ChatBuddyListControllerDelegate;

@interface EM_BuddyListController : EM_ChatBaseController

@property (nonatomic, weak) id<EM_ChatBuddyListControllerDataSource> dataSource;
@property (nonatomic, weak) id<EM_ChatBuddyListControllerDelegate> delegate;

- (void)reloadTagBar;

- (void)reloadOppositeList;

- (void)startRefresh;

- (void)endRefresh;

@end

@protocol EM_ChatBuddyListControllerDataSource <NSObject>

@required

/**
 *  是否显示搜索
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowSearchBar;

/**
 *  是否显示Tag
 *
 *  @return 默认NO
 */
- (BOOL)shouldShowTagBar;

/**
 *  每个分组有多少个好友，群或者讨论组
 *
 *  @param groupIndex 组索引
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsAtGroupIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组数据
 *
 *  @param rowIndex
 *  @param groupIndex 组索引
 *
 *  @return 默认nil
 */
- (EM_ChatOpposite *)dataForRow:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex;

@optional

/**
 *  搜索结果数量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfRowsForSearch;

/**
 *  搜索数据
 *
 *  @param index
 *
 *  @return
 */
- (EM_ChatOpposite *)dataForSearchRowAtIndex:(NSInteger)index;

/**
 *  tag数据量
 *
 *  @return 默认0
 */
- (NSInteger)numberOfTags;

/**
 *  tag标题
 *
 *  @param index tag索引
 *
 *  @return 默认nil
 */
- (NSString *)titleForTagAtIndex:(NSInteger)index;

/**
 *  tag字体
 *
 *  @param index
 *
 *  @return
 */
- (UIFont *)fontForTagAtIndex:(NSInteger)index;

/**
 *  tag图标
 *
 *  @param index
 *
 *  @return
 */
- (NSString *)iconForTagAtIndex:(NSInteger)index;

/**
 *  好友分组数量
 *
 *  @return 默认1
 */
- (NSInteger)numberOfGroups;

/**
 *  分组标题
 *
 *  @param index
 *
 *  @return 默认 "我的好友"
 */
- (NSString *)titleForGroupAtIndex:(NSInteger)index;

@end

@protocol EM_ChatBuddyListControllerDelegate <NSObject>

@required

@optional

/**
 *  搜索
 *
 *  @param searchString
 *
 *  @return 是否加载搜索结果
 */
- (BOOL)shouldReloadSearchForSearchString:(NSString *)searchString;

/**
 *  搜索结果被点击
 *
 *  @param index
 */
- (void)didSelectedForSearchRowAtIndex:(NSInteger)index;

/**
 *  tag被点击
 *
 *  @param index
 */
- (void)didSelectedForTagAtIndex:(NSInteger)index;

/**
 *  分组被点击
 *
 *  @param groupIndex
 */
- (void)didSelectedForGroupAtIndex:(NSInteger)groupIndex;

/**
 *  好友，群或者讨论组被点击
 *
 *  @param rowIndex
 *  @param groupIndex
 */
- (void)didSelectedForRowAtIndex:(NSInteger)rowIndex groupIndex:(NSInteger)groupIndex;

/**
 *  已经开始开始下拉刷新
 */
- (void)didStartRefresh;

/**
 *  已经结束下拉刷新
 */
- (void)didEndRefresh;

@end
```
继承
```
#import "EM+BuddyListController.h"

@interface CustomBuddyListController : EM_BuddyListController

@end
```
```
#import "CustomBuddyListController.h"
#import "CustomChatController.h"
#import "EaseMob.h"

#import "EM+ChatOppositeTag.h"
#import "EM+ChatBuddy.h"

@interface CustomBuddyListController ()<EM_ChatBuddyListControllerDataSource,EM_ChatBuddyListControllerDelegate,EMChatManagerDelegate>

@property (nonatomic, assign) BOOL needReload;

@end

@implementation CustomBuddyListController{
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
    CustomChatController *chatController = [[CustomChatController alloc]initWithOpposite:buddy];
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
    UChatController *chatController = [[UChatController alloc]initWithOpposite:buddy];
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
```
![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/buddy_list.png?raw=true)

<h3 id = "2.7">聊天界面</h3>
直接继承使用即可，有很多功能和UI还在完善中。
<h4 id = "2.7.1">配置文件</h4>
在使用聊天界面之前，请先了解```EM_ChatUIConfig```和```EM_ChatMessageUIConfig```两个配置文件的相关属性。配置文件只在初始化显示聊天界面的时候使用，在聊天界面显示后再修改无效。
```
EM_ChatUIConfig
```
聊天界面的配置
```
#import <Foundation/Foundation.h>
@class EM_ChatMessageUIConfig;

//聊天界面中大部分文字的默认大小
#define RES_FONT_DEFAUT (14)

//文字输入工具栏图标字体的默认大小
#define RES_TOOL_ICO_FONT (30)

//动作图标的默认大小
#define RES_ACTION_ICO_FONT (30)

//属性
/**
 *  属性名称
 */
extern NSString * const kAttributeName;

/**
 *  标题
 */
extern NSString * const kAttributeTitle;

/**
 *  一般图片
 */
extern NSString * const kAttributeNormalImage;

/**
 *  高亮图片
 */
extern NSString * const kAttributeHighlightImage;

/**
 *  背景色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBackgroundColor;

/**
 *  边框颜色,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderColor;

/**
 *  边框宽度,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeBorderWidth;

/**
 *  圆角,输入框工具栏按钮无此属性
 */
extern NSString * const kAttributeCornerRadius;

/**
 *  图标字体,设置此属性后,kAttributeNormalImage和kAttributeHighlightImage会失效
 */
extern NSString * const kAttributeFont;

/**
 *  图标
 */
extern NSString * const kAttributeText;

/**
 *  图标一般颜色
 */
extern NSString * const kAttributeNormalColor;

/**
 *  图标高亮颜色
 */
extern NSString * const kAttributeHighlightColor;

//工具栏按钮Name
extern NSString * const kButtonNameRecord;
extern NSString * const kButtonNameKeyboard;
extern NSString * const kButtonNameEmoji;
extern NSString * const kButtonNameAction;

//动作Name
extern NSString * const kActionNameImage;
extern NSString * const kActionNameCamera;
extern NSString * const kActionNameVoice;
extern NSString * const kActionNameVideo;
extern NSString * const kActionNameLocation;
extern NSString * const kActionNameFile;

@interface EM_ChatUIConfig : NSObject

@property (nonatomic, assign) BOOL hiddenOfRecord;
@property (nonatomic, assign) BOOL hiddenOfEmoji;
@property (nonatomic, strong) EM_ChatMessageUIConfig *messageConfig;

@property (nonatomic, strong, readonly) NSMutableDictionary *actionDictionary;
@property (nonatomic, strong, readonly) NSMutableDictionary *toolDictionary;
@property (nonatomic, strong, readonly) NSMutableArray *keyArray;


+ (instancetype)defaultConfig;

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeToolWithName:(NSString *)name;
- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName;

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeActionWithName:(NSString *)name;
- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName;
```

```
EM_ChatMessageUIConfig
```
显示消息cell的配置
```
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EM_AVATAR_STYLE) {
    EM_AVATAR_STYLE_SQUARE = 0,//方形
    EM_AVATAR_STYLE_CIRCULAR//圆形
};

@interface EM_ChatMessageUIConfig : NSObject

//cell
/**
 *  头像风格,默认EM_AVATAR_STYLE_CIRCULAR
 */
@property (nonatomic, assign) EM_AVATAR_STYLE avatarStyle;

/**
 *  头像的大小
 */
@property (nonatomic, assign) float messageAvatarSize;

/**
 *  消息左右的padding
 */
@property (nonatomic, assign) float messagePadding;

/**
 *  消息顶部padding,即消息和消息之间的空隙
 */
@property (nonatomic, assign) float messageTopPadding;

/**
 *  消息时间显示高度
 */
@property (nonatomic, assign) float messageTimeLabelHeight;

/**
 *  昵称显示高度
 */
@property (nonatomic, assign) float messageNameLabelHeight;

/**
 *  菊花高度
 */
@property (nonatomic, assign) float messageIndicatorSize;

/**
 *  气泡尾巴宽度
 */
@property (nonatomic, assign) float messageTailWithd;

//bubble
/**
 *  气泡padding
 */
@property (nonatomic, assign) float bubblePadding;

/**
 *  气泡文字大小
 */
@property (nonatomic, assign) float bubbleTextFont;

/**
 *  文字行间距
 */
@property (nonatomic, assign) float bubbleTextLineSpacing;

/**
 *  气泡圆角大小
 */
@property (nonatomic, assign) float bubbleCornerRadius;

@property (nonatomic, assign) float bodyTextPadding;

@property (nonatomic, assign) float bodyImagePadding;

@property (nonatomic, assign) float bodyVideoPadding;

@property (nonatomic, assign) float bodyVoicePadding;

@property (nonatomic, assign) float bodyLocationPadding;

@property (nonatomic, assign) float bodyFilePadding;

+ (instancetype)defaultConfig;

@end
```

<h4 id = "2.7.2">聊天Controller</h4>
```
EM_ChatController
```
聊天界面的Controller，直接继承并自定义自己的部分。

```
#import "EM+ChatBaseController.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"

@protocol EM_ChatControllerDelegate;

@interface EM_ChatController : EM_ChatBaseController

/**
 *  会话对象
 */
@property (nonatomic, strong, readonly) EMConversation *conversation;


@property (nonatomic,weak) id<EM_ChatControllerDelegate> delegate;

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType config:(EM_ChatUIConfig *)config;

- (void)sendMessage:(EM_ChatMessageModel *)message;

@end

@protocol EM_ChatControllerDelegate <NSObject>

@required

@optional

/**
 *  配置
 *
 *  @return
 */
- (EM_ChatUIConfig *)configForChat;

/**
 *  为要发送的消息添加扩展
 *
 *  @param body 消息内容
 *
 *  @param type 消息类型
 *
 *  @return 扩展
 */
- (EM_ChatMessageExtend *)extendForMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  是否允许发送消息
 *
 *  @param body 消息内容
 *  @param type 消息类型
 *
 *  @return YES or NO,默认YES
 */
- (BOOL)shouldSendMessage:(id)body messageType:(MessageBodyType)type;

/**
 *  自定义动作监听
 *
 *  @param name 自定义动作
 */
- (void)didActionSelectedWithName:(NSString *)name;

/**
 *  头像点击事件
 *
 *  @param chatter 
 *  @param isOwn 是否是自己的头像
 */
- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn;

/**
 *  扩展View被点击
 *
 *  @param userInfo  数据
 *  @param indexPath
 */
- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo;

/**
 *  扩展View菜单被选择
 *
 *  @param userInfo  数据
 *  @param indexPath 
 */
- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo;

@end
```
继承
```
#import "EM+ChatController.h"

@interface CustomChatController : EM_ChatController

@end
```
```
#import "CustomChatController.h"
#import "CustomExtend.h"

@interface CustomChatController ()<EM_ChatControllerDelegate>

@end

@implementation CustomChatController

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)conversationType{
    self = [super initWithChatter:chatter conversationType:conversationType];
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
- (EM_ChatUIConfig *)configForChat{
    return [EM_ChatUIConfig defaultConfig];
}

- (EM_ChatMessageExtend *)extendForMessage:(id)body messageType:(MessageBodyType)type{
    CustomExtend *extend = [[CustomExtend alloc]init];
    extend.showBody = YES;
    extend.showExtend = NO;
    return extend;
}

- (void)didActionSelectedWithName:(NSString *)name{
    
}

- (void)didAvatarTapWithChatter:(NSString *)chatter isOwn:(BOOL)isOwn{
    //点击了头像
}

- (void)didExtendTapWithUserInfo:(NSDictionary *)userInfo{
    //点击了扩展View
}

- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo{
    
}

@end
```

聊天界面会涉及的其他三个Controller，```EM_LocationController```(定位，用于获取定位信息)、```EM_ExplorerController```（文件浏览器，获取要发送的文件）、```EM_CallController```(语音、视频即时通讯)

<h3 id = "2.8">自定义扩展</h3>
**自定义扩展**是通过环信```EMMessage```的扩展属性```ext```来实现的，我只是对自定义扩展进行了规范，可以让大家方便扩展的同时实现了自己的一些功能。为了统一iOS和Android，在声明属性的时候请尽量只声明NSString、BOOL和数字类型，因为Android只支持这些类型。
```
EM_ChatMessageExtend
```
这里有我自己的一些扩展属性，大家只需要继承就可以了。
```

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class EM_ChatMessageModel;

extern NSString * const kClassName;

@interface EM_ChatMessageExtend : NSObject

@property (nonatomic, strong) EM_ChatMessageModel *message;

/**
 *  是否显示消息内容,默认YES
 */
@property (nonatomic, assign) BOOL showBody;

/**
 *  是否显示扩展内容,默认NO
 */
@property (nonatomic, assign) BOOL showExtend;

/**
 *  是否显示时间,默认NO
 */
@property (nonatomic, assign) BOOL showTime;

/**
 *  标记消息的详情是否被查看,比如图片的大图是否被查看,语音消息是否被听过,视频是否被看过
 */
@property (nonatomic, assign) BOOL details;

/**
 *  标记消息是否正在查看
 */
@property (nonatomic, assign) BOOL checking;

/**
 *  标记消息是否被收藏
 */
@property (nonatomic, assign) BOOL collected;

/**
 *  标记是否是即时语音、即时视频消息,该标记只针对文字消息有效,请不要随意修改
 */
@property (nonatomic, assign) BOOL isCallMessage;

/**
 *  文件类型,只针对文件消息有效,请不要随意修改
 */
@property (nonatomic, copy) NSString *fileType;

//overwrite
/**
 *  返回扩展内容绑定View的Class,showExtend为YES时子类必须重写
 *
 *  @return class
 */
- (Class)classForExtendView;

/**
 *  将扩展序列化成字典,子类必须重写,且必须通过super获取
 *
 *  @return
 */
- (NSMutableDictionary *)getContentValues;

/**
 *  从字典解析扩展
 *
 *  @param extend 来自EMMessage 的 ext
 */
- (void)getFrom:(NSDictionary *)extend;

/**
 *  返回扩展展示的大小,showExtend为YES时子类必须重写,否则默认返回CGSizeZero
 *
 *  @param maxWidth 扩展最大的宽度,返回大小的宽度必须小于等于maxWidth
 *
 *  @return size
 */
- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth;

//private,你可能仅仅扩展自己基本类型的字段,且不需要显示,这里会满足你
- (void)setAttribute:(id)attribute forKey:(NSString *)key;
- (void)removeAttributeForKey:(NSString *)key;
- (id)attributeForkey:(NSString *)key;

@end
```
其中大部分属性都不需要自己去修改，自己只需要关注```showBody```、```showExtend```这两个字段，以及```- (Class)classForExtendView```、```- (NSMutableDictionary *)getContentValues```、```- (void)getFrom:(NSDictionary *)extend```和```- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth```方法就可以了。

因为扩展内容是通过```NSDictionary```的方式进行存储的，所以子类需要重写```- (NSMutableDictionary *)getContentValues```和```- (void)getFrom:(NSDictionary *)extend```方法。

```
#import "EM+ChatMessageExtend.h"

@interface CustomExtend : EM_ChatMessageExtend

@property (nonatomic, copy) NSString *custom;

@end
```
```
#import "CustomExtend.h"
#import "CustomExtendView.h"

@implementation CustomExtend

- (instancetype)init{
    self = [super init];
    if(self){

    }
    return self;
}

- (Class)classForExtendView{
    return [CustomExtendView class];
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];
    //放入自定义属性,请避免让key和父类中的重复
    if(self.custom){
        [values setObject:self.custom forKey:@"key"];
    }
    
    return values;
}
- (void)getFrom:(NSDictionary *)extend{
    [super getFrom:extend];
    //取出自己的属性,一定要记得super
    self.custom = extend[@"key"];
}

@end
```
当你需要消息```View```上显示扩展内容的时候，请将```showExtend```标记为```YES```。当然你也可以同时将```showBody```标记为```NO```，这个时候就只会在```View```上显示扩展内容而不显示消息内容了。然后再在消息气泡上加一个特殊的背景！
当```showExtend```标记为```YES```，你需要提供自定义的```View```，自定义View必须继承```EM_ChatMessageExtendView```，不需要提供额外的```init```方法。```EM_ChatMessageExtendView```本身没有太多可以实现的（后期会加入更多的实现），和```EM_ChatMessageBodyView```（用来显示消息内容的View）一样都是继承自```EM_ChatMessageContent```。
```
EM_ChatMessageContent
```
目前你只需要关注该类中的实现。
```
#import <UIKit/UIKit.h>
@class EM_ChatMessageModel;
@class EM_ChatMessageUIConfig;

/**
 *  userInfo key
 */
extern NSString * const kHandleActionName;
extern NSString * const kHandleActionMessage;
extern NSString * const kHandleActionValue;
extern NSString * const kHandleActionView;
extern NSString * const kHandleActionFrom;

/**
 *  from
 */
extern NSString * const HANDLE_FROM_CONTENT;
extern NSString * const HANDLE_FROM_BODY;
extern NSString * const HANDLE_FROM_EXTEND;

/**
 *  action
 */
extern NSString * const HANDLE_ACTION_URL;
extern NSString * const HANDLE_ACTION_PHONE;
extern NSString * const HANDLE_ACTION_TEXT;
extern NSString * const HANDLE_ACTION_IMAGE;
extern NSString * const HANDLE_ACTION_VOICE;
extern NSString * const HANDLE_ACTION_VIDEO;
extern NSString * const HANDLE_ACTION_LOCATION;
extern NSString * const HANDLE_ACTION_FILE;
extern NSString * const HANDEL_ACTION_BODY;
extern NSString * const HANDLE_ACTION_EXTEND;
extern NSString * const HANDLE_ACTION_UNKNOWN;

/**
 *  menu action
 */
extern NSString * const MENU_ACTION_DELETE;//删除
extern NSString * const MENU_ACTION_COPY;//复制
extern NSString * const MENU_ACTION_FACE;//添加到表情
extern NSString * const MENU_ACTION_DOWNLOAD;//下载
extern NSString * const MENU_ACTION_COLLECT;//收藏
extern NSString * const MENU_ACTION_FORWARD;//转发

@protocol EM_ChatMessageContentDelegate;

@interface EM_ChatMessageContent : UIView

@property (nonatomic, weak) id<EM_ChatMessageContentDelegate> delegate;
@property (nonatomic,strong) EM_ChatMessageModel *message;

/**
 *  是否需要点击,默认YES
 */
@property (nonatomic, assign) BOOL needTap;

/**
 *  是否需要长按,默认YES
 */
@property (nonatomic, assign) BOOL needLongPress;

@property (nonatomic, strong) EM_ChatMessageUIConfig *config;


//overwrite

/**
 *  返回菜单项,请使用super
 *
 *  @return 菜单项
 */
- (NSMutableArray *)menuItems;

/**
 *  返回点击、长按传入的数据,请使用super
 *
 *  @return 数据
 */
- (NSMutableDictionary *)userInfo;

@end

@protocol EM_ChatMessageContentDelegate <NSObject>

@required

@optional

/**
 *  点击监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentTap:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  长按监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentLongPress:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

/**
 *  菜单选项监听
 *
 *  @param content  view
 *  @param action   动作
 *  @param userInfo 数据
 */
- (void) contentMenu:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo;

@end
```
默认有点击、长按手势，而且你不需要实现代理，代理已经在```EM_ChatController```中实现。你需要关注```- (NSMutableArray *)menuItems```和```- (NSMutableDictionary *)userInfo```方法，长按手势默认是用来调出menu的，所以你需要提供menuItems。
```
#import "EM+ChatMessageExtendView.h"

@interface CustomExtendView : EM_ChatMessageExtendView

@end
```
```
#import "CustomExtendView.h"

@implementation CustomExtendView

- (NSMutableArray *)menuItems{
    NSMutableArray *items = [super menuItems];
    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copy:)];
    [items addObject:copyItem];
    return items;
}

- (void)copy:(id)sender{
    //这里执行你的代码，或者调用代理中的方法。如果你使用代理，EM_ChatControllerDelegate中的- (void)didExtendMenuSelectedWithUserInfo:(NSDictionary *)userInfo方法会被调用。
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentMenu:action:withUserInfo:)]) {
        NSMutableDictionary *userInfo = [self userInfo];//
        [userInfo setObject:MENU_ACTION_COPY forKey:kHandleActionName];
        [self.delegate contentMenu:self action:MENU_ACTION_COPY withUserInfo:userInfo];
    }
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    //在userInfo中放入自己的一些数据，点击和长按都触发
    [userInfo setObject:@"Click" forKey:kHandleActionName];
    return userInfo;
}

@end
```


<h3 id = "2.9">UI</h3>

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/action_view.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/emoji_view.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/voice_input.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/voice_play.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_in.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_voice.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/call_video.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/wifi_upload.png?raw=true)

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/web_wifi_upload.png?raw=true)

<h2 id = "3">期望</h2>
- **合作：**如果你 也是环信的使用者，可以一起和我开发这个项目，让更多的环信开发者方便使用
- **联系：**请联系我 QQ：940549652
