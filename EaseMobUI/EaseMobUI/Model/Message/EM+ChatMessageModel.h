//
//  EM+ChatMessageModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtend.h"
#import "EaseMob.h"
@class EM_ChatMessageUIConfig;

@interface EM_ChatMessageModel : NSObject

/**
 *  消息发送者的昵称
 */
@property (nonatomic, copy) NSString *displayName;
/**
 *  消息发送者的头像地址
 */
@property (nonatomic, strong) NSURL *avatar;
/**
 *  是否是自己发送
 */
@property (nonatomic, assign) BOOL sender;
@property (nonatomic, strong, readonly) EMMessage *message;
@property (nonatomic, strong, readonly) id<IEMMessageBody> messageBody;
@property (nonatomic, strong, readonly) EM_ChatMessageExtend *extend;

/**
 *  Cell的reuseIdentifier
 */
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

+ (instancetype)fromEMMessage:(EMMessage *)message;
+ (instancetype)fromText:(NSString *)text conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;
+ (instancetype)fromImage:(UIImage *)image conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;
+ (instancetype)fromVoice:(NSString *)path name:(NSString *)name duration:(NSInteger)duration conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;
+ (instancetype)fromVideo:(NSString *)path conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;
+ (instancetype)fromLatitude:(double)latitude longitude:(double)longitude address:(NSString *)address conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;
+ (instancetype)fromFile:(NSString *)path name:(NSString *)name conversation:(EMConversation *)conversation extend:(EM_ChatMessageExtend *)extend;

- (BOOL)updateExt;
- (Class)classForBuildView;
/**
 *  根据消息内容获取气泡的大小
 *
 *  @param maxWidth 气泡最大宽度
 *
 *  @return 气泡大小,由bodySize 和 extendSize共同决定
 */
- (CGSize)bubbleSizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config;

/**
 *  根据消息内容获取显示消息内容的body大小
 *
 *  @param maxWidth 最大body宽度 = 气泡最大宽度 - bubblePadding * 2
 *
 *  @return body大小,由messageBody决定
 */
- (CGSize)bodySizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config;

/**
 *  根据自定义扩展获取显示扩展的大小
 *
 *  @param maxWidth 最大扩展宽度 = 气泡最大宽度 - bubblePadding * 2
 *
 *  @return 扩展宽度,由extend决定
 */
- (CGSize)extendSizeFormMaxWidth:(CGFloat)maxWidth config:(EM_ChatMessageUIConfig *)config;

@end