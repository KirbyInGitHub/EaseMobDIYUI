//
//  EM+ChatExplorerConnection.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/18.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatExplorerConnection.h"

#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"

#import "MultipartFormDataParser.h"
#import "MultipartMessageHeaderField.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPFileResponse.h"
#import "HTTPErrorResponse.h"

#import "EM+ChatFileUtils.h"

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;

@interface EM_ChatExplorerConnection()<MultipartFormDataParserDelegate>

@end

@implementation EM_ChatExplorerConnection{
    MultipartFormDataParser*        parser;
    NSFileHandle*					storeFile;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"POST"]){
        if ([path isEqualToString:@"/files"]){
            return YES;
        }
    }
    return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path{
    HTTPLogTrace();
    if([method isEqualToString:@"POST"] && [path isEqualToString:@"/files"]) {
        NSString* contentType = [request headerField:@"Content-Type"];
        NSUInteger paramsSeparator = [contentType rangeOfString:@";"].location;
        if(NSNotFound == paramsSeparator) {
            return NO;
        }
        if(paramsSeparator >= contentType.length - 1) {
            return NO;
        }
        NSString* type = [contentType substringToIndex:paramsSeparator];
        if(![type isEqualToString:@"multipart/form-data"] ) {
            return NO;
        }
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];
            
            if( [paramName isEqualToString:@"boundary"] ) {
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        if( nil == [request headerField:@"boundary"] )  {
            return NO;
        }
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"GET"]) {
        if ([path isEqualToString:@"/"]) {
            //请求index.html
            NSArray *files = [EM_ChatFileUtils filesInfoAtPath:kChatFileOtherFolderPath];
            NSMutableString *replaceHtml = [[NSMutableString alloc]init];
            for (NSDictionary *fileInfo in files) {
                NSString *fileName = [fileInfo objectForKey:kFileName];
                NSDictionary *fileAttributes = [fileInfo objectForKey:kFileAttributes];
                long long fileSize = [fileAttributes fileSize];
                NSString *html = [NSString stringWithFormat:@"<div class=\"file\">\n\t<div class=\"column filename\" filename=\"%@\">%@</div>\n\t<div class=\"column size\">%@</div>\n\t<div class=\"column download\" title=\"下载文件\"></div>\n\t<div class=\"column trash\" title=\"删除文件\"></div>\n</div>",fileName,fileName,[EM_ChatFileUtils stringFileSize:fileSize]];
                [replaceHtml appendString:html];
            }
            NSDictionary *replaceDic = @{@"files_panel":replaceHtml};
            NSString* indexPagePath = [[config documentRoot] stringByAppendingPathComponent:@"index.html"];
            return [[HTTPDynamicFileResponse alloc] initWithFilePath:indexPagePath forConnection:self separator:@"%" replacementDictionary:replaceDic];
        }else if([path isEqualToString:@""]){
            
        }
    }else if([method isEqualToString:@"POST"]){
        if ([path isEqualToString:@"/files"]) {
            return [[HTTPErrorResponse alloc]initWithErrorCode:200];
        }
    }else if([method isEqualToString:@"PUT"]){
        
    }else if([method isEqualToString:@"DELETE"]){
        
    }else if([method isEqualToString:@"HEAD"]){
        
    }
    return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength{
    HTTPLogTrace();
    NSString* boundary = [request headerField:@"boundary"];
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;
}

- (void)processBodyData:(NSData *)postDataChunk{
    HTTPLogTrace();
    [parser appendData:postDataChunk];
}

#pragma mark - MultipartFormDataParserDelegate
- (void)processStartOfPartWithHeader:(MultipartMessageHeader *)header{
    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
    NSString* filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    
    if (!filename || filename.length == 0) {
        return;
    }
    
    NSString* uploadDirPath = kChatFileOtherFolderPath;
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",uploadDirPath,filename];;
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        storeFile = nil;
    }else {
        HTTPLogVerbose(@"Saving file to %@", filePath);
        if(![[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
            HTTPLogError(@"Could not create file at path: %@", filePath);
        }
        storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    }
}

- (void)processContent:(NSData *)data WithHeader:(MultipartMessageHeader *)header{
    if(storeFile) {
        [storeFile writeData:data];
    }
}

- (void)processEndOfPartWithHeader:(MultipartMessageHeader *)header{
    [storeFile closeFile];
    storeFile = nil;
}

- (void)processPreambleData:(NSData *)data{
    
}

- (void)processEpilogueData:(NSData *)data{
    
}

@end