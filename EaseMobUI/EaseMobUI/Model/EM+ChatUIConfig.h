//
//  EM+MessageUIConfig.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RES_IMAGE_TOOL(name) ([NSString stringWithFormat:@"EM_Resourse.bundle/images/tool/%@",name])
#define RES_IMAGE_ACTION(name) ([NSString stringWithFormat:@"EM_Resourse.bundle/images/action/%@",name])
#define RES_IMAGE_CELL(name) ([NSString stringWithFormat:@"EM_Resourse.bundle/images/cell/%@",name])

#define RES_FONT_DEFAUT (14)

//属性
extern NSString * const kAttributeName;
extern NSString * const kAttributeTitle;
extern NSString * const kAttributeNormalImage;
extern NSString * const kAttributeHighlightImage;
extern NSString * const kAttributeBackgroundColor;
extern NSString * const kAttributeBorderColor;
extern NSString * const kAttributeBorderWidth;
extern NSString * const kAttributeCornerRadius;

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

@property (nonatomic,assign) BOOL hiddenOfRecord;
@property (nonatomic,assign) BOOL hiddenOfEmoji;


@property (nonatomic,strong,readonly) NSMutableDictionary *actionDictionary;
@property (nonatomic,strong,readonly) NSMutableDictionary *toolDictionary;
@property (nonatomic,strong,readonly) NSMutableArray *keyArray;

+ (instancetype)defaultConfig;

- (void)setToolName:(NSString *)toolName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeToolWithName:(NSString *)name;
- (void)removeToolAttributeWithName:(NSString *)attributeName tool:(NSString *)toolName;

- (void)setActionName:(NSString *)actionName attributeName:(NSString *)attributeName attribute:(id)attribute;
- (void)removeActionWithName:(NSString *)name;
- (void)removeActionAttributeWithName:(NSString *)attributeName action:(NSString *)actionName;

@end