//
//  EM+ChatMessageModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EM+ChatMessageExtend.h"
#import "EaseMob.h"

#define CELL_BUBBLE_PADDING (2)

@interface EM_ChatMessageModel : NSObject
/**
 *  气泡边框padding
 */
@property (nonatomic, assign) CGFloat bubblePadding;
/**
 *  文字大小
 */
@property (nonatomic, assign) CGFloat textFont;

/**
 *  消息发送者的昵称
 */
@property (nonatomic, copy) NSString *nickName;
/**
 *  消息发送者的头像地址
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  是否是自己发送
 */
@property (nonatomic, assign) BOOL sender;
@property (nonatomic, strong) EMMessage *message;
@property (nonatomic, strong, readonly) id<IEMMessageBody> messageBody;
@property (nonatomic, strong, readonly) EM_ChatMessageExtend *extend;

/**
 *  Cell的reuseIdentifier
 */
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
/**
 *  显示内容View的Class
 */
@property (nonatomic, assign, readonly) Class classForBuildView;

- (instancetype)initWithMessage:(EMMessage *)message;
- (BOOL)updateExt;

/**
 *  根据消息内容获取气泡的大小
 *
 *  @param maxWidth 气泡最大宽度
 *
 *  @return 气泡大小,由bodySize 和 extendSize共同决定
 */
- (CGSize)bubbleSizeFormMaxWidth:(CGFloat)maxWidth;

/**
 *  根据消息内容获取显示消息内容的body大小
 *
 *  @param maxWidth 最大body宽度 = 气泡最大宽度 - bubblePadding * 2
 *
 *  @return body大小,由messageBody决定
 */
- (CGSize)bodySizeFormMaxWidth:(CGFloat)maxWidth;

/**
 *  根据自定义扩展获取显示扩展的大小
 *
 *  @param maxWidth 最大扩展宽度 = 气泡最大宽度 - bubblePadding * 2
 *
 *  @return 扩展宽度,由extend决定
 */
- (CGSize)extendSizeFormMaxWidth:(CGFloat)maxWidth;

@end