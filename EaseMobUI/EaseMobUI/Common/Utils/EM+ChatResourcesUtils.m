//
//  EM+ChatResourcesUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatResourcesUtils.h"

#import <UIKit/UIKit.h>


@implementation EM_ChatResourcesUtils

+ (NSString *)stringWithName:(NSString *)name{
    return [self stringWithName:name table:@"EM_ChatStrings"];
}

+ (NSString *)stringWithName:(NSString *)name table:(NSString *)table{
    return NSLocalizedStringFromTable(name,table,@"");
}

+ (UIImage *)imageWithName:(NSString *)name{
    return [UIImage imageNamed:name];
}

+ (UIImage *)toolImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/tool/%@",name]];
}

+ (UIImage *)actionImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/action/%@",name]];
}

+ (UIImage *)cellImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/cell/%@",name]];
}

+ (UIImage *)callImageWithName:(NSString *)name{
    return [self imageWithName:[NSString stringWithFormat:@"EM_Resource.bundle/images/call/%@",name]];
}

@end