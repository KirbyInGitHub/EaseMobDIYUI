//
//  EM+ChatResourcesUtils.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface EM_ChatResourcesUtils : NSObject

+ (NSString *)stringWithName:(NSString *)name;
+ (NSString *)stringWithName:(NSString *)name table:(NSString *)table;
+ (UIImage *)toolImageWithName:(NSString *)name;
+ (UIImage *)actionImageWithName:(NSString *)name;
+ (UIImage *)cellImageWithName:(NSString *)name;

@end