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

NSString * const kFileName = @"kFileName";
NSString * const kFilePath = @"kFilePath";
NSString * const kFileAttributes = @"kFileAttributes";

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
                                  kFolderContent : [[NSFileManager defaultManager] subpathsAtPath:kChatFileDocumentFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.video"],
                                  kFolderName : kChatFileVideoFolderName,
                                  kFolderPath : kChatFileVideoFolderPath,
                                  kFolderContent : [[NSFileManager defaultManager] subpathsAtPath:kChatFileVideoFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.image"],
                                  kFolderName : kChatFileImageFolderName,
                                  kFolderPath : kChatFileImageFolderPath,
                                  kFolderContent : [[NSFileManager defaultManager] subpathsAtPath:kChatFileImageFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.audio"],
                                  kFolderName : kChatFileAudioFolderName,
                                  kFolderPath : kChatFileAudioFolderPath,
                                  kFolderContent : [[NSFileManager defaultManager] subpathsAtPath:kChatFileAudioFolderPath]}];
        
        [_folderArray addObject:@{kFolderTitle : [EM_ChatResourcesUtils stringWithName:@"file.other"],
                                  kFolderName : kChatFileOtherFolderName,
                                  kFolderPath : kChatFileOtherFolderPath,
                                  kFolderContent : [[NSFileManager defaultManager] subpathsAtPath:kChatFileOtherFolderPath]}];
    });
    return _folderArray;
}

+ (NSArray *)filesInfoAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath:path];
    NSMutableArray *filesInfo = [[NSMutableArray alloc]init];
    
    for (NSString *fileName in files) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
        NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSMutableDictionary *fileInfo = [[NSMutableDictionary alloc]init];
        [fileInfo setObject:fileName forKey:kFileName];
        [fileInfo setObject:filePath forKey:kFilePath];
        [fileInfo setObject:attributes forKey:kFileAttributes];
        [filesInfo addObject:fileInfo];
    }
    
    [filesInfo sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *fileModify1 = [[obj1 objectForKey:kFileAttributes] fileModificationDate];
        NSDate *fileModify2 = [[obj2 objectForKey:kFileAttributes] fileModificationDate];
        
        if (fileModify1.timeIntervalSince1970 > fileModify2.timeIntervalSince1970) {
            return NSOrderedAscending;
        }else if (fileModify1.timeIntervalSince1970 < fileModify2.timeIntervalSince1970){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    return filesInfo;
}

+ (long long)fileSizeAtPath:(NSString *)path{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize];
}

+ (NSString *)stringFileSizeAtPath:(NSString *)path{
    long long fileSize = [self fileSizeAtPath:path];
    return  [self stringFileSize:fileSize];
}

+ (NSString *)stringFileSize:(long long)fileSize{
    if (fileSize > 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%0.2f G",fileSize / (1024.0 * 1024.0 * 1024.0)];
    }else if(fileSize > 1024 * 1024){
        return [NSString stringWithFormat:@"%0.2f M",fileSize / (1024.0 * 1024.0)];
    }else if (fileSize > 1024){
        return [NSString stringWithFormat:@"%0.2f K",fileSize / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%lld B",fileSize];
    }
}

@end