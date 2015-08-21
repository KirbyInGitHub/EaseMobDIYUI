//
//  EM+ChatMessageExtend.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/11.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtend.h"
#import "EM+ChatMessageExtendView.h"
#import "EM+ChatMessageModel.h"

@interface EM_ChatMessageExtend()

@property (nonatomic, assign) BOOL sender;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@end

@implementation EM_ChatMessageExtend

NSString * const kShowBody = @"kShowBody";
NSString * const kShowExtend = @"kShowExtend";
NSString * const kShowTime = @"kShowTime";

NSString * const kDetails = @"kDetails";
NSString * const kChecking = @"kChecking";
NSString * const kCollected = @"kCollected";
NSString * const kCallMessage = @"kCallMessage";
NSString * const kMessageFileType = @"kFileType";

NSString * const kAttributes = @"kAttributes";

NSString * const kClassName = @"kClassName";


- (instancetype)init{
    self = [super init];
    if (self) {
        _attributes = [[NSMutableDictionary alloc]init];
        _showBody = YES;
        _showExtend = NO;
        _showTime = NO;
    }
    return self;
}

- (Class)classForExtendView{
    return [EM_ChatMessageExtendView class];
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [[NSMutableDictionary alloc]init];
    [values setObject:NSStringFromClass([self class]) forKey:kClassName];
    
    [values setObject:@(self.showBody) forKey:kShowBody];
    [values setObject:@(self.showExtend) forKey:kShowExtend];
    [values setObject:@(self.showTime) forKey:kShowTime];
    
    [values setObject:@(self.details) forKey:kDetails];
    [values setObject:@(self.checking) forKey:kChecking];
    [values setObject:@(self.collected) forKey:kCollected];
    [values setObject:self.attributes forKey:kAttributes];
    [values setObject:@(self.isCallMessage) forKey:kCallMessage];
    if (self.fileType) {
        [values setObject:self.fileType forKey:kMessageFileType];
    }
    return values;
}

- (void)setShowBody:(BOOL)showBody{
    _showBody = showBody;
    if (self.message) {
        [self.message.message.ext setValue:@(_showBody) forKey:kShowBody];
    }
}

- (void)setShowExtend:(BOOL)showExtend{
    _showExtend = showExtend;
    if (self.message) {
        [self.message.message.ext setValue:@(_showExtend) forKey:kShowExtend];
    }
}

- (void)setShowTime:(BOOL)showTime{
    _showTime = showTime;
    if (self.message) {
        [self.message.message.ext setValue:@(_showTime) forKey:kShowTime];
    }
}

- (void)setDetails:(BOOL)details{
    _details = details;
    if (self.message) {
        [self.message.message.ext setValue:@(_details) forKey:kDetails];
    }
}

- (void)setChecking:(BOOL)checking{
    _checking = checking;
    if (self.message) {
        [self.message.message.ext setValue:@(_checking) forKey:kChecking];
    }
}

- (void)setCollected:(BOOL)collected{
    _collected = collected;
    if (self.message) {
        [self.message.message.ext setValue:@(_collected) forKey:kCollected];
    }
}

- (void)getFrom:(NSDictionary *)extend{
    id showBody = extend[kShowBody];
    if (showBody && ![showBody isMemberOfClass:[NSNull class]]) {
        self.showBody = [showBody boolValue];
    }
    
    id showExtend = extend[kShowExtend];
    if (showExtend && ![showExtend isMemberOfClass:[NSNull class]]) {
        self.showExtend = [showExtend boolValue];
    }
    
    id showTime = extend[kShowTime];
    if (showTime && ![showTime isMemberOfClass:[NSNull class]]) {
        self.showTime = [showTime boolValue];
    }
    
    id details = extend[kDetails];
    if (details && ![details isMemberOfClass:[NSNull class]]) {
        self.details = [details boolValue];
    }
    
    id checking = extend[kChecking];
    if (checking && ![checking isMemberOfClass:[NSNull class]]) {
        self.checking = [checking boolValue];
    }
    
    id collected = extend[kCollected];
    if (collected && ![collected isMemberOfClass:[NSNull class]]) {
        self.collected = [collected boolValue];
    }
    
    id attributes = extend[kAttributes];
    if (attributes && ![attributes isMemberOfClass:[NSNull class]]) {
        _attributes = attributes;
    }
    
    id isCallMessage = extend[kCallMessage];
    if (isCallMessage && ![isCallMessage isMemberOfClass:[NSNull class]]) {
        self.isCallMessage = [isCallMessage boolValue];
    }
    
    id fileType = extend[kMessageFileType];
    if (fileType && ![fileType isMemberOfClass:[NSNull class]]) {
        self.fileType = fileType;
    }
}

- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth{
    return CGSizeZero;
}

- (void)setAttribute:(id)attribute forKey:(NSString *)key{
    if (!attribute || !key) {
        return;
    }
    [_attributes setObject:attribute forKey:key];
}

- (void)removeAttributeForKey:(NSString *)key{
    if (!key) {
        return;
    }
    [_attributes removeObjectForKey:key];
}

- (id)attributeForkey:(NSString *)key{
    return _attributes[key];
}

@end