//
//  EM+ChatBuddyGroupModel.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  默认分组，我的好友
 */
extern NSString * const kEMChatBuddyGroupSignBuddy;

@interface EM_ChatBuddyGroupModel : NSObject

@property (nonatomic, copy) NSString *title;

/**
 *  唯一标示
 */
@property (nonatomic, copy) NSString *sign;

/**
 *  标记是否展开
 */
@property (nonatomic, assign) BOOL expand;

+ (NSArray *)defaultGroup;

@end