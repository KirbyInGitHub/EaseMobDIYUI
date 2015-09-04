//
//  EM+ChatMessageExtend.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendView.h"

@interface EM_ChatMessageExtend()

@end

@implementation EM_ChatMessageExtend

//JSONModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:[self keyMapping]];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _showBody = YES;
        _showExtend = NO;
        _showTime = NO;
        _viewClassName = NSStringFromClass([EM_ChatMessageExtendView class]);
    }
    return self;
}

- (NSString *)className{
    return NSStringFromClass([self class]);
}

+ (NSMutableDictionary *)keyMapping{
    NSMutableDictionary *mapping = [[NSMutableDictionary alloc]init];
    [mapping setObject:kExtendAttributeNameClassName forKey:kExtendAttributeKeyClassName];
    [mapping setObject:kExtendAttributeNameCallType forKey:kExtendAttributeKeyCallType];
    [mapping setObject:kExtendAttributeNameFileType forKey:kExtendAttributeKeyFileType];
    
    [mapping setObject:kExtendAttributeNameShowBody forKey:kExtendAttributeKeyShowBody];
    [mapping setObject:kExtendAttributeNameShowExtend forKey:kExtendAttributeKeyShowExtend];
    [mapping setObject:kExtendAttributeNameShowTime forKey:kExtendAttributeKeyShowTime];
    [mapping setObject:kExtendAttributeNameDetails forKey:kExtendAttributeKeyDetails];
    [mapping setObject:kExtendAttributeNameChecking forKey:kExtendAttributeKeyChecking];
    [mapping setObject:kExtendAttributeNameCollected forKey:kExtendAttributeKeyCollected];
    [mapping setObject:kExtendAttributeNameAttributes forKey:kExtendAttributeKeyAttributes];
    
    [mapping setObject:kExtendAttributeNameViewClassName forKey:kExtendAttributeKeyViewClassName];
    return mapping;
}

- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth{
    return CGSizeZero;
}

@end