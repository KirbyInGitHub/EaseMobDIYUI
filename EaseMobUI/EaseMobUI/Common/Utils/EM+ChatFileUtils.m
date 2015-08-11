//
//  EM+ChatFileUtils.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/6.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"

@implementation EM_ChatFileUtils

NSString * const kFolderTitle = @"kFolderTitle";
NSString * const kFolderName = @"kFolderName";
NSString * const kFolderPath = @"kFolderPath";
NSString * const kFolderContent = @"kFolderContent";

+ (BOOL)initialize{
    BOOL create = [self createFolderWithPath:kChatFolderPath];
    if (!create) {
        NSLog(@"创建根目录失败");
        return NO;
    }else{
        NSLog(@"创建根目录 - %@",kChatFolderPath);
    }
    
    create = [self createFolderWithPath:kChatDBFolderPath];
    if (!create) {
        NSLog(@"创建数据库目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileFolderPath];
    if (!create) {
        NSLog(@"创建文件目录失败");
        return NO;
    }
    
    create = [self createFolderWithPath:kChatFileDocumentFolderPath];
    if (!create) {
        NSLog(@"创建文档目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileVideoFolderPath];
    if (!create) {
        NSLog(@"创建视频目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileImageFolderPath];
    if (!create) {
        NSLog(@"创建图片目录失败");
    }
    
    create = [self createFolderWithPath:kChatFileAudioFolderPath];
    if (!create) {
        NSLog(@"创建音频目录失败");
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

+ (NSArray *)folderArray{
    static NSMutableArray *_folderArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _folderArray = [[NSMutableArray alloc] init];
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.document"],
                                  kFolderName : kChatFileDocumentFolderName,
                                  kFolderPath : kChatFileDocumentFolderPath,
                                  kFolderContent : [self contentsOfDirectoryAtPath:kChatFileDocumentFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.video"],
                                  kFolderName : kChatFileVideoFolderName,
                                  kFolderPath : kChatFileVideoFolderPath,
                                  kFolderContent : [self contentsOfDirectoryAtPath:kChatFileVideoFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.image"],
                                  kFolderName : kChatFileImageFolderName,
                                  kFolderPath : kChatFileImageFolderPath,
                                  kFolderContent : [self contentsOfDirectoryAtPath:kChatFileImageFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.audio"],
                                  kFolderName : kChatFileAudioFolderName,
                                  kFolderPath : kChatFileAudioFolderPath,
                                  kFolderContent : [self contentsOfDirectoryAtPath:kChatFileAudioFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.other"],
                                  kFolderName : kChatFileOtherFolderName,
                                  kFolderPath : kChatFileOtherFolderPath,
                                  kFolderContent : [self contentsOfDirectoryAtPath:kChatFileOtherFolderPath]}];
    });
    return _folderArray;
}

+ (NSArray *)contentsOfDirectoryAtPath:(NSString *)path{
    NSMutableArray *content = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSArray *contentArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (contentArray && contentArray.count > 0 && !error) {
        [content addObjectsFromArray:contentArray];
    }
    return content;
}

@end