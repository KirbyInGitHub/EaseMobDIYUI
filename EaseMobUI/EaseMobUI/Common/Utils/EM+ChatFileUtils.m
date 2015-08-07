//
//  EM+ChatFileUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatFileUtils.h"


@implementation EM_ChatFileUtils

+ (BOOL)initialize{
    BOOL create = [self createFolderWithPath:kChatFolderPath];
    if (!create) {
        NSLog(@"创建根目录失败");
        return NO;
    }
    
    create = [self createFolderWithPath:kChatDBFolderPath];
    if (!create) {
        NSLog(@"创建数据库目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileFolderPath];
    if (!create) {
        NSLog(@"穿件文件目录失败");
        return NO;
    }
    
    create = [self createFolderWithPath:kChatFileImageFolderPath];
    if (!create) {
        NSLog(@"创建图片目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileAudioFolderPath];
    if (!create) {
        NSLog(@"创建音频目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileDocumentFolderPath];
    if (!create) {
        NSLog(@"创建文档目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileOtherFolderPath];
    if (!create) {
        NSLog(@"创建其他目录失败");
    }
    
    return YES;
}

+ (BOOL)createFolderWithPath:path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExisted = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = isDir && isExisted;
    if (!isCreated){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isCreated;
}

@end