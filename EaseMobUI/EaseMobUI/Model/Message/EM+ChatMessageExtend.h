//
//  EM+ChatMessageExtend.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

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
 *  返回扩展内容绑定View的Class,showExtend为YES的时候子类必须重写
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