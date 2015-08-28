//
//  EM+ChatResourcesUtils.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIFont;
@class UIImage;

extern NSString * const kEMChatIconFontName;

extern NSString * const kEMChatIconToolVoice;
extern NSString * const kEMChatIconToolFace;
extern NSString * const kEMChatIconToolAction;
extern NSString * const kEMChatIconToolKeyboard;
extern NSString * const kEMChatIconToolDown;
extern NSString * const kEMChatIconToolUp;

extern NSString * const kEMChatIconActionImage;
extern NSString * const kEMChatIconActionCamera;
extern NSString * const kEMChatIconActionAudio;
extern NSString * const kEMChatIconActionVideo;
extern NSString * const kEMChatIconActionLocation;
extern NSString * const kEMChatIconActionFile;

extern NSString * const kEMChatIconMoreRepeal;
extern NSString * const kEMChatIconMoreRecord;
extern NSString * const kEMChatIconMoreTrash;
extern NSString * const KEMChatIconMorePlay;
extern NSString * const kEMChatIconMoreStop;

extern NSString * const kEMChatIconBubbleTailLeft;
extern NSString * const kEMChatIconBubbleTailRight;


@interface EM_ChatResourcesUtils : NSObject

+ (NSString *)stringWithName:(NSString *)name;
+ (NSString *)stringWithName:(NSString *)name table:(NSString *)table;
+ (UIImage *)defaultAvatarImage;
+ (NSURL *)defaultAvatarURL;
+ (UIImage *)cellImageWithName:(NSString *)name;
+ (UIImage *)callImageWithName:(NSString *)name;
+ (UIImage *)fileImageWithName:(NSString *)name;
+ (UIFont *)iconFontWithSize:(float)size;

@end