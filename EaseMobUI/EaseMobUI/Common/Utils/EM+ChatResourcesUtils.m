//
//  EM+ChatResourcesUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatResourcesUtils.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation EM_ChatResourcesUtils

NSString * const kEMChatIconFontName = @"em_chat_icon";

NSString * const kEMChatIconToolVoice = @"\ue600";
NSString * const kEMChatIconToolFace = @"\ue601";
NSString * const kEMChatIconToolAction = @"\ue602";
NSString * const kEMChatIconToolKeyboard = @"\ue603";
NSString * const kEMChatIconToolDown = @"\ue604";
NSString * const kEMChatIconToolUp = @"\ue605";

NSString * const kEMChatIconActionImage = @"\ue606";
NSString * const kEMChatIconActionCamera = @"\ue607";
NSString * const kEMChatIconActionAudio = @"\ue608";
NSString * const kEMChatIconActionVideo = @"\ue609";
NSString * const kEMChatIconActionLocation = @"\ue60a";
NSString * const kEMChatIconActionFile = @"\ue60b";

NSString * const kEMChatIconMoreRepeal = @"\ue60c";
NSString * const kEMChatIconMoreRecord = @"\ue60d";
NSString * const kEMChatIconMoreTrash = @"\ue60e";
NSString * const KEMChatIconMorePlay = @"\ue60f";
NSString * const kEMChatIconMoreStop = @"\ue610";

+ (NSString *)stringWithName:(NSString *)name{
    return [self stringWithName:name table:@"EM_ChatStrings"];
}

+ (NSString *)stringWithName:(NSString *)name table:(NSString *)table{
    return NSLocalizedStringFromTable(name,table,@"");
}

+ (UIImage *)imageWithName:(NSString *)name{
    return [UIImage imageNamed:name];
}

+ (UIImage *)cellImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/cell/%@",name]];
}

+ (UIImage *)callImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/call/%@",name]];
}

+ (UIImage *)fileImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/file/%@",name]];
}

+ (UIFont *)iconFontWithSize:(float)size{
#ifndef DISABLE_FONTAWESOME_AUTO_REGISTRATION
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *fontUrl = [[NSBundle mainBundle] URLForResource:kEMChatIconFontName withExtension:@"ttf" subdirectory:@"EM_Resource.bundle/file"];
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
        CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CFErrorRef error;
        CTFontManagerRegisterGraphicsFont(newFont, &error);
        CGFontRelease(newFont);
    });
#endif
    
    UIFont *font = [UIFont fontWithName:kEMChatIconFontName size:size];
    return font;
}

@end