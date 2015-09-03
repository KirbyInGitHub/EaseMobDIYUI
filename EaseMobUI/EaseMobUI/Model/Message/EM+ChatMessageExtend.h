//
//  EM+ChatMessageExtend.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>
@class EM_ChatMessageModel;


//key
#define kExtendAttributeKeyClassName           (kExtendAttributeNameClassName)
#define kExtendAttributeKeyIsCallMessage       (kExtendAttributeNameIsCallMessage)
#define kExtendAttributeKeyFileType            (kExtendAttributeNameFileType)

#define kExtendAttributeKeyMessage             (kExtendAttributeNameMessage)
#define kExtendAttributeKeyShowBody            (kExtendAttributeNameShowBody)
#define kExtendAttributeKeyShowExtend          (kExtendAttributeNameShowExtend)
#define kExtendAttributeKeyShowTime            (kExtendAttributeNameShowTime)
#define kExtendAttributeKeyDetails             (kExtendAttributeNameDetails)
#define kExtendAttributeKeyChecking            (kExtendAttributeNameChecking)
#define kExtendAttributeKeyCollected           (kExtendAttributeNameCollected)
#define kExtendAttributeKeyAttributes          (kExtendAttributeNameAttributes)

#define kExtendAttributeKeyViewClassName       (kExtendAttributeNameViewClassName)


//name
#define kExtendAttributeNameClassName           (@"className")
#define kExtendAttributeNameIsCallMessage       (@"isCallMessage")
#define kExtendAttributeNameFileType            (@"fileType")

#define kExtendAttributeNameMessage             (@"message")
#define kExtendAttributeNameShowBody            (@"showBody")
#define kExtendAttributeNameShowExtend          (@"showExtend")
#define kExtendAttributeNameShowTime            (@"showTime")
#define kExtendAttributeNameDetails             (@"details")
#define kExtendAttributeNameChecking            (@"checking")
#define kExtendAttributeNameCollected           (@"collected")
#define kExtendAttributeNameAttributes          (@"attributes")

#define kExtendAttributeNameViewClassName       (@"viewClassName")


@interface EM_ChatMessageExtend : JSONModel

/****************************************************/

/**
 *  不要修改
 *  扩展所在的消息
 */
@property (nonatomic, strong) EM_ChatMessageModel<Ignore> *message;

/**
 *  不要修改
 *  当前类的类名
 */
@property (nonatomic, copy) NSString *className;

/**
 *  不要修改
 *  标记是否是即时语音、即时视频消息,该标记只针对文字消息有效,
 */
@property (nonatomic, assign) BOOL isCallMessage;

/**
 *  不要修改
 *  文件类型,只针对文件消息有效,
 */
@property (nonatomic, copy) NSString<Optional> *fileType;




/****************************************************/

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
 *  自定义扩展属性,不用来显示
 */
@property (nonatomic, strong) NSDictionary<Optional> *attributes;




/*****************************************************/

/**
 *
 *  显示View的类名,showExtend为YES的时候必须设置
 */
@property (nonatomic, copy) NSString *viewClassName;

/**
 *  overwrite
 *  key 和 属性名的对应
 *  请使用super
 *  @return
 */
+ (NSMutableDictionary *)keyMapping;

/**
 *  overwrite
 *  显示View的大小,showExtend为YES时子类必须重写,否则默认返回CGSizeZero
 *
 *  @param maxWidth 扩展最大的宽度,返回大小的宽度必须小于等于maxWidth
 *
 *  @return size
 */
- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth;

@end