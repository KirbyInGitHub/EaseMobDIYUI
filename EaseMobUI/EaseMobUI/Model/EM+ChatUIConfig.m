//
//  EM+MessageUIConfig.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatUIConfig.h"
#import "EM+Common.h"
#import "EM+ChatResourcesUtils.h"

@interface EM_ChatUIConfig()

@end

@implementation EM_ChatUIConfig

//属性
NSString * const kAttributeName = @"kAttributeName";
NSString * const kAttributeTitle = @"kAttribuTitle";
NSString * const kAttributeNormalImage = @"kAttribuNormalImage";
NSString * const kAttributeHighlightImage = @"kAttribuNormalImage";
NSString * const kAttributeBackgroundColor = @"kActionBackgroundColor";
NSString * const kAttributeBorderColor = @"kAttribuBorderColor";
NSString * const kAttributeBorderWidth = @"kAttribuBorderWidth";
NSString * const kAttributeCornerRadius = @"kAttribuCornerRadius";
NSString * const kAttributeFont = @"kAttributeFont";
NSString * const kAttributeText = @"kAttributeText";

//工具栏按钮
NSString * const kButtonNameRecord = @"kButtonNameRecord";
NSString * const kButtonNameKeyboard = @"kButtonNameKeyboard";
NSString * const kButtonNameEmoji = @"kButtonNameEmoji";
NSString * const kButtonNameAction = @"kButtonNameAction";

//动作
NSString * const kActionNameImage = @"kActionNameImage";
NSString * const kActionNameCamera = @"kActionNameCamera";
NSString * const kActionNameVoice = @"kActionNameVoice";
NSString * const kActionNameVideo = @"kActionNameVideo";
NSString * const kActionNameLocation = @"kActionNameLocation";
NSString * const kActionNameFile = @"kActionNameFile";

+ (instancetype)defaultConfig{
    EM_ChatUIConfig *config = [[EM_ChatUIConfig alloc]init];
    
    config.hiddenOfRecord = NO;
    config.hiddenOfEmoji = NO;
    //录音按钮
    [config setToolName:kButtonNameRecord attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils toolImageWithName:@"tool_record"]];
    
    //键盘
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils toolImageWithName:@"tool_keyboard"]];
    
    //Emoji
    [config setToolName:kButtonNameEmoji attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils toolImageWithName:@"tool_emoji"]];
    
    //动作
    [config setToolName:kButtonNameAction attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils toolImageWithName:@"tool_action"]];
    
    
    //图片
    [config setActionName:kActionNameImage attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.image"]];
    [config setActionName:kActionNameImage attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_image"]];
    
    //相机
    [config setActionName:kActionNameCamera attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.camera"]];
    [config setActionName:kActionNameCamera attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_camera"]];
    
    //语音
    [config setActionName:kActionNameVoice attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.voice"]];
    [config setActionName:kActionNameVoice attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_phone"]];
    
    
    //视频
    [config setActionName:kActionNameVideo attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.video"]];
    [config setActionName:kActionNameVideo attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_video"]];
    
    //位置
    [config setActionName:kActionNameLocation attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.location"]];
    [config setActionName:kActionNameLocation attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_location"]];
    
    //文件
    [config setActionName:kActionNameFile attributeName:kAttributeTitle attribute:[EM_ChatResourcesUtils stringWithName:@"common.file"]];
    [config setActionName:kActionNameFile attributeName:kAttributeNormalImage attribute:[EM_ChatResourcesUtils actionImageWithName:@"action_file"]];
    
    return config;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _keyArray = [[NSMutableArray alloc]init];
        _actionDictionary = [[NSMutableDictionary alloc]init];
        _toolDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute{
    if (toolName && toolName.length > 0 && attributeName && attributeName.length > 0 && attribute) {
        NSMutableDictionary *buttonDic = _toolDictionary[toolName];
        if (!buttonDic) {
            buttonDic = [[NSMutableDictionary alloc]init];
            [buttonDic setObject:toolName forKey:kAttributeName];
            [_toolDictionary setObject:buttonDic forKey:toolName];
        }
        if (![attributeName isEqualToString:kAttributeName]) {
            [buttonDic setObject:attribute forKey:attributeName];
        }
    }
}

- (void)removeToolWithName:(NSString *)name{
    if (name && name.length > 0) {
        [_toolDictionary removeObjectForKey:name];
    }
}

- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName{
    if (attributeName && attributeName.length > 0 && toolName && toolName.length > 0) {
        NSMutableDictionary *action = _toolDictionary[toolName];
        [action removeObjectForKey:attributeName];
        if (action.count == 0) {
            [_toolDictionary removeObjectForKey:toolName];
        }
    }
}

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute{
    if (actionName && actionName.length > 0 && attributeName && attributeName.length > 0 && attribute) {
        NSMutableDictionary *actionAttributeDic = _actionDictionary[actionName];
        if (!actionAttributeDic) {
            actionAttributeDic = [[NSMutableDictionary alloc]init];
            [actionAttributeDic setObject:kAttributeName forKey:actionName];
            [_actionDictionary setObject:actionAttributeDic forKey:actionName];
            
            [_keyArray addObject:actionName];
        }
        if (![attributeName isEqualToString:kAttributeName]) {
            [actionAttributeDic setObject:attribute forKey:attributeName];
        }
    }
}

- (void)removeActionWithName:(NSString *)name{
    if (name && name.length > 0) {
        [_actionDictionary removeObjectForKey:name];
        [_keyArray removeObject:name];
    }
}

- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName{
    if (attributeName && attributeName.length > 0 && actionName && actionName.length > 0) {
        NSMutableDictionary *action = _actionDictionary[actionName];
        [action removeObjectForKey:attributeName];
        if (action.count == 0) {
            [_actionDictionary removeObjectForKey:actionName];
            [_keyArray removeObject:actionName];
        }
    }
}

@end