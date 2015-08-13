//
//  EM+ChatMessageExtend.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class EMMessage;

extern NSString * const kClassName;

@interface EM_ChatMessageExtend : NSObject

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
 *  标记消失是否被收藏
 */
@property (nonatomic, assign) BOOL collected;

+ (instancetype)createNewExtendFromSender;
+ (instancetype)createNewExtendFromMessage:(EMMessage *)message;

//overwrite
/**
 *  返回扩展内容绑定View的Class,子类必须重写
 *
 *  @return class
 */
- (Class)classForExtendView;

/**
 *  将扩展序列化成字典,子类必须重写,且必须通过super获取
 *
 *  @return <#return value description#>
 */
- (NSMutableDictionary *)getContentValues;

/**
 *  从字典解析扩展
 *
 *  @param extend 来自EMMessage 的 ext
 */
- (void)getFrom:(NSDictionary *)extend;

/**
 *  返回扩展展示的大小,子类必须重写,否则默认返回CGSizeZero
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