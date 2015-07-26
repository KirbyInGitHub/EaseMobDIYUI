//
//  EM+MessageUIConfig.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatUIConfig.h"
#import "EM+Common.h"

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
    [config setToolName:kButtonNameRecord attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_record")]];
    [config setToolName:kButtonNameRecord attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_record")]];
    [config setToolName:kButtonNameRecord attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameRecord attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameRecord attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setToolName:kButtonNameRecord attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //键盘
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_keyboard")]];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_keyboard")]];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setToolName:kButtonNameKeyboard attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //Emoji
    [config setToolName:kButtonNameEmoji attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_emoji")]];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_emoji")]];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setToolName:kButtonNameEmoji attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //动作
    [config setToolName:kButtonNameAction attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_action")]];
    [config setToolName:kButtonNameAction attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_TOOL(@"tool_action")]];
    [config setToolName:kButtonNameAction attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameAction attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setToolName:kButtonNameAction attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setToolName:kButtonNameAction attributeName:kAttributeCornerRadius attribute:@(0)];
    
    
    //图片
    [config setActionName:kActionNameImage attributeName:kAttributeTitle attribute:EM_ChatString(@"common.image")];
    [config setActionName:kActionNameImage attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_image")]];
    [config setActionName:kActionNameImage attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_image")]];
    [config setActionName:kActionNameImage attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameImage attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameImage attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setActionName:kActionNameImage attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //相机
    [config setActionName:kActionNameCamera attributeName:kAttributeTitle attribute:EM_ChatString(@"common.camera")];
    [config setActionName:kActionNameCamera attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_camera")]];
    [config setActionName:kActionNameCamera attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_camera")]];
    [config setActionName:kActionNameCamera attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameCamera attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameCamera attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setActionName:kActionNameCamera attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //语音
    [config setActionName:kActionNameVoice attributeName:kAttributeTitle attribute:EM_ChatString(@"common.voice")];
    [config setActionName:kActionNameVoice attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_phone")]];
    [config setActionName:kActionNameVoice attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_phone")]];
    [config setActionName:kActionNameVoice attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameVoice attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameVoice attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setActionName:kActionNameVoice attributeName:kAttributeCornerRadius attribute:@(0)];
    
    
    //视频
    [config setActionName:kActionNameVideo attributeName:kAttributeTitle attribute:EM_ChatString(@"common.video")];
    [config setActionName:kActionNameVideo attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_video")]];
    [config setActionName:kActionNameVideo attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_video")]];
    [config setActionName:kActionNameVideo attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameVideo attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameVideo attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setActionName:kActionNameVideo attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //位置
    [config setActionName:kActionNameLocation attributeName:kAttributeTitle attribute:EM_ChatString(@"common.location")];
    [config setActionName:kActionNameLocation attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_location")]];
    [config setActionName:kActionNameLocation attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_location")]];
    [config setActionName:kActionNameLocation attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameLocation attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameLocation attributeName:kAttributeBorderWidth attribute:@(0)];
    [config setActionName:kActionNameLocation attributeName:kAttributeCornerRadius attribute:@(0)];
    
    //文件
    [config setActionName:kActionNameFile attributeName:kAttributeTitle attribute:EM_ChatString(@"common.file")];
    [config setActionName:kActionNameFile attributeName:kAttributeNormalImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_file")]];
    [config setActionName:kActionNameFile attributeName:kAttributeHighlightImage attribute:[UIImage imageNamed:RES_IMAGE_ACTION(@"action_file")]];
    [config setActionName:kActionNameFile attributeName:kAttributeBackgroundColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameFile attributeName:kAttributeBorderColor attribute:[UIColor clearColor]];
    [config setActionName:kActionNameFile attributeName:kAttributeBorderWidth attribute:@(0.1)];
    [config setActionName:kActionNameFile attributeName:kAttributeCornerRadius attribute:@(0)];
    
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