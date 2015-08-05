#EaseMobDIYUI
@(EaseMob)[自定义聊天UI|简单继承|pod]
***
- **[LeanCloud](https://leancloud.cn/)**：LeanCloud 实时消息只需几行代码，就可使用户的应用完成移动 IM 的功能添加。 IM 系统与当前用户系统完全解耦，无需同步或修改现有用户体系，即可使用；除 iOS、Android 移动开发的原生 SDK 之外，还也支持网页内聊天。
- **[融云](http://www.rongcloud.cn/)**：融云是国内首家专业的即时通讯云服务提供商，专注为互联网、移动互联网开发者提供即时通讯基础能力和云端服务。通过融云平台，开发者不必搭建服务端硬件环境，就可以将即时通讯、实时网络能力快速集成至应用中 针对开发者所需的不同场景，融云平台提供了一系列产品、技术解决方案，包括：客户端 IM组件，客户端 IM 基础库，服务端 RESTAPI，客户端实时网络通讯基础库等。利用这些解决方案，开发者可以直接在自己的应用中构建出即时通讯产品，也可以无限创意出自己的即时通讯场景。 融云 SDK 包括两部分：IM 界面组件和 IM 能力库。
- **[环信](http://www.easemob.com/)**：环信即时通讯云是移动即时通讯能力的云计算 PaaS (Platform as a Service, 平台即服务)平台服务商。移动即时通讯能力是指基于互联网和移动终端的单聊，群聊，富媒体消息，实时语音，实时视频，多人语音视频，流媒体播放及互动等通讯能力。环信将移动即时通讯能力通过云端开放的API 和客户端 SDK 包的方式提供给开发者和企业，帮助合作伙伴在自己的产品中便捷、快速的实现通讯和社交功能
- **[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)**：[LeanCloud](https://leancloud.cn/)、[融云](http://www.rongcloud.cn/)、[环信](http://www.easemob.com/)是我用过IM平台，也是当前比较受欢迎的三个IM平台。通过对比它们的优缺点，还是非常明显的。[LeanCloud](https://leancloud.cn/)免费内容太少，超过500用户就要收费，SDK支持的平台倒是挺多的。[融云](http://www.rongcloud.cn/)还不错，在1.0时代有太多的问题，有幸看到过它们的UI代码，写的比较烂。没有WinPhone的支持， Server SDK支持也比较多。[环信](http://www.easemob.com/)在免费内容上和融云做得差不多，SDK 的API也不错，但是没有让开发者直接拿来继承使用的UI（只是有个Demo，但是直接使用太麻烦，如果能pod得话就更好，这也是我现在写这个项目的初衷）。
***
[TOC]
***
##简介
集成环信的即时通讯功能，pod集成，方便管理。简单继承，轻松定制自己的UI界面。当前最新版本```0.1.8```,目前暂时只完成了单聊界面，暂时不支持即时语音和即时视频功能。很多功能和界面都在开发中，聊天界面的UI也没有开发完善，所以现在显示很挫。在```1.0.0```版本之前会完成所有可以使用环信SDK实现的功能，并且加入其它实用的功能，在此之前也不适合使用。当然你也可以参考环信的[Demo](http://www.easemob.com/downloads)。

###环信SDK
使用pod集成的[EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)，集成版本```2.1.7```。因为pod集成[EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods)是没有语音和视频通讯功能的。

###额外功能
- 会话编辑状态保存
- 最近Emoji表情的保存
- 自定义扩展View，由环信的消息扩展来决定
- 语音消息发送之前的播放
- 自定义Action，除了图片、相机、语音、视频、位置和文件等Action外，可以额外添加其它Action，View会根据数量来自动增加翻页
- 语音识别（未实现）
- 文件浏览器（未实现）
- .......

##使用
###要求
iOS版本7.0以上
###pod
```pod 'EaseMobDIYUI', :git => 'https://github.com/AwakenDragon/EaseMobDIYUI.git'```
```pod 'VoiceConvert',:git => "https://github.com/AwakenDragon/VoiceConvert.git"```

*PS:语音消息的播放需要[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能模块，开始我试图直接把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能代码放到项目里使用，但在制作成pod并使用的时候，总是报找不到相关类库文件的错误。无奈只能单独将[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)功能做成pod来集成。但在制作[EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的pod的时候，没有办法把[VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)作为依赖添加进入，所以只能要求使用者，在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI) 的时候，同时pod [VoiceConvert](https://github.com/AwakenDragon/VoiceConvert)。后期，我会想办法修复这个问题，好可以只pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)。*

###依赖
在pod [EaseMobDIYUI](https://github.com/AwakenDragon/EaseMobDIYUI)的时候，EaseMobSDKFull已经添加了以下依赖：
```"EaseMobSDKFull", "2.1.7"``` 不解释 [EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)
```"SDWebImage", "3.7.3"``` 用来加载图片的 [SDWebImage](https://github.com/rs/SDWebImage)
```"MJRefresh", "2.0.4"``` 上拉下拉，相信你也会用到 [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
```"MWPhotoBrowser", "2.1.1"``` 图片浏览，同时也支持视频播放 [MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)
```"MBProgressHUD", "0.9.1"``` 主要还是toast功能 [MBProgressHUD](https://github.com/jdg/MBProgressHUD)
```"FMDB", "2.5"``` 这是实现保存会话状态和聊天表情的，你应该也会用到 [FMDB](https://github.com/ccgus/fmdb)
```"TTTAttributedLabel", "1.13.4"``` 富文本显示 [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel)

所以你不需要再额外pod这些了。
**注意：**在pod完成开始运行的时候， [EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)
的一个文件*```EMErrorDefs.h```*可能会报错，具体原因是几个枚举没有或者重复。
**解决办法：**从环信最新的SDK([EaseMobSDK](https://github.com/easemob/sdk-ios-cocoapods) )中拿到这个文件，然后进入自己项目[EaseMobSDKFull](https://github.com/dujiepeng/EaseMobSDKFull)的对应pod目录，覆盖掉该文件即可。虽然在```XCode```里不允许修改pod的文件，但这样做事没有问题的。
**文件目录：**
```EaseMobSDK --> include --> Utility --> ErrorManager --> EMErrorDefs.h``` 
```你项目根目录 --> Pods --> EaseMobSDKFull --> EaseMobSDKFull --> include --> Utility --> ErrorManager --> EMErrorDefs.h```

### 初始化及使用
```
#import "EaseMobUIClient.h"
```

```
[EaseMobUIClient sharedInstance];//这里会初始化数据库等
EM_ChatUIConfig *config = [EM_ChatUIConfig defaultConfig];//自定义UI的配置
UIViewController *chatController = [[EM_ChatController alloc]initWithChatter:chatter conversationType:eConversationTypeChat config:config];
```
你也可以直接继承```EM_ChatController```使用。环信初始化及登录方法仍然需要自己去调用。
```
[[EaseMob sharedInstance] registerSDKWithAppKey:EaseMob_AppKey apnsCertName:EaseMob_APNSCertName];
[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
[[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user password:password completion:^(NSDictionary *loginInfo, EMError *error) {
} onQueue:nil];
```
具体其他的环信API调用请参考环信的[官方文档](http://www.easemob.com/docs/ios/IOSSDKPrepare/)。

###配置文件
```
EM_ChatUIConfig
```
```
//Action按钮，录音，Emoji表情，和更多按钮的属性
extern NSString * const kAttributeName;
extern NSString * const kAttributeTitle;//录音，Emoji表情，和更多按钮没有这个属性
extern NSString * const kAttributeNormalImage;
extern NSString * const kAttributeHighlightImage;
extern NSString * const kAttributeBackgroundColor;
extern NSString * const kAttributeBorderColor;
extern NSString * const kAttributeBorderWidth;
extern NSString * const kAttributeCornerRadius;
extern NSString * const kAttributeFont;
extern NSString * const kAttributeText;//字体图标

//工具栏按钮Name,默认有录音，Emoji表情，和更多（即'+'）按钮
extern NSString * const kButtonNameRecord;
extern NSString * const kButtonNameKeyboard;
extern NSString * const kButtonNameEmoji;
extern NSString * const kButtonNameAction;

//动作Name，默认图片，相机，语音，视频，位置，文件六个Action，更多按钮请自定义添加
extern NSString * const kActionNameImage;
extern NSString * const kActionNameCamera;
extern NSString * const kActionNameVoice;
extern NSString * const kActionNameVideo;
extern NSString * const kActionNameLocation;
extern NSString * const kActionNameFile;

@interface EM_ChatUIConfig : NSObject

@property (nonatomic,assign) BOOL hiddenOfRecord;//是否显示录音按钮
@property (nonatomic,assign) BOOL hiddenOfEmoji;//是否显示Emoji表情按钮

@property (nonatomic,strong,readonly) NSMutableDictionary *actionDictionary;//存储Action按钮的属性
@property (nonatomic,strong,readonly) NSMutableDictionary *toolDictionary;//存储录音，Emoji表情和更多按钮的属性
@property (nonatomic,strong,readonly) NSMutableArray *keyArray;//Action按钮的name，这个决定按钮的显示顺序

+ (instancetype)defaultConfig;//默认的配置

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute;//设置录音，Emoji表情和更多按钮的属性的属性
- (void)removeToolWithName:(NSString *)name;
- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName;

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute;//设置Action按钮
- (void)removeActionWithName:(NSString *)name;//移除一个Action按钮的配置
- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName;
```
配置文件只在初始化显示聊天界面的时候使用，在聊天界面显示后再修改并不能修改界面元素

###Delegate
** ```EM_ChatControllerDelegate```**
```
@protocol EM_ChatControllerDelegate <NSObject>
@required
@optional
- (NSString *)nickNameWithChatter:(NSString *)chatter;//昵称
- (NSString *)avatarWithChatter:(NSString *)chatter;//头像地址
- (NSDictionary *)extendForMessageBody:(id<IEMMessageBody>)messageBody;//为所有要发送的消息添加扩展
- (BOOL)showForExtendMessage:(NSDictionary *)ext;//是否显示消息扩展View
- (NSString *)reuseIdentifierForExtendMessage:(NSDictionary *)ext;//reuseIdentifier
- (CGSize)sizeForExtendMessage:(NSDictionary *)ext maxWidth:(CGFloat)max;//消息扩展View的Size
- (UIView *)viewForExtendMessage:(NSDictionary *)ext reuseView:(UIView *)view;//消息扩展View
- (void)didActionSelectedWithName:(NSString *)name;//自定义Action按钮被点击

@end
```
###UI
**聊天界面**

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/01.PNG?raw=true)

**更多Action按钮**

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/02.PNG?raw=true)

**Emoji**

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/03.PNG?raw=true)

**录音**

![enter image description here](https://github.com/AwakenDragon/ImageRepository/blob/master/EaseMobDIYUI/04.PNG?raw=true)

##期望
- **合作：**如果你 也是环信的使用者，可以一起和我开发这个项目，让更多的环信开发者方便使用
- **联系：**请联系我 QQ：940549652
