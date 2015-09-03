//
//  UserCustomExtend.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UserCustomExtend.h"
#import "UserCustomExtendView.h"

@implementation UserCustomExtend

- (instancetype)init{
    self = [super init];
    if(self){
        self.extendProperty = @"这是扩展属性";
        self.viewClassName = NSStringFromClass([UserCustomExtendView class]);
    }
    return self;
}

+ (NSMutableDictionary *)keyMapping{
    NSMutableDictionary *mapping = [super keyMapping];
    [mapping setObject:kExtendAttributeNameExtend forKey:kExtendAttributeKeyExtend];
    return mapping;
}

- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth{
    return [self.extendProperty sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}

@end