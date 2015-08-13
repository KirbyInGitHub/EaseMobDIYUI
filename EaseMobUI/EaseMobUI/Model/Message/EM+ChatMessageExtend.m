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
NSString * const kAttributes = @"kAttributes";

NSString * const kClassName = @"kClassName";


+ (instancetype)createNewExtendFromSender{
    EM_ChatMessageExtend *extend = [[[self class]alloc]init];
    extend.sender = YES;
    return extend;
}

+ (instancetype)createNewExtendFromMessage:(EMMessage *)message{
    EM_ChatMessageExtend *extend = [self createNewExtendFromSender];
    extend.sender = NO;
    return extend;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _attributes = [[NSMutableDictionary alloc]init];
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
    return values;
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