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
        self.extendStr = @"customExtendStr";
    }
    return self;
}

- (Class)classForExtendView{
    return [UserCustomExtendView class];
}

- (void)getFrom:(NSDictionary *)extend{
    [super getFrom:extend];
    self.extendStr = [extend objectForKey:@"customExtendStr"];
}

- (NSMutableDictionary *)getContentValues{
    NSMutableDictionary *values = [super getContentValues];
    [values setObject:self.extendStr forKey:@"customExtendStr"];
    return values;
}

- (CGSize)extendSizeFromMaxWidth:(CGFloat)maxWidth{
    return CGSizeMake(50, 30);
}

@end