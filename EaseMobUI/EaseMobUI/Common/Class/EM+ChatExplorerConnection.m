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
#import "EM+ChatHttpErrorResponse.h"

#import "EM+ChatFileUtils.h"
#import "EM+ChatResourcesUtils.h"

#ifdef DEBUG
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;
#else
static const int httpLogLevel = HTTP_LOG_LEVEL_OFF;
#endif

@interface EM_ChatExplorerConnection()<MultipartFormDataParserDelegate>
@property (nonatomic, strong)  NSMutableDictionary *responseDic;
@end

@implementation EM_ChatExplorerConnection{
    MultipartFormDataParser *parser;
    NSFileHandle    *storeFile;
    
}

NSString * const kEMNotificationFileUpload = @"kEMNotificationFileUpload";
NSString * const kEMNotificationFileDelete = @"kEMNotificationFileDelete";
NSString * const kEMNotificationFileDownload = @"kEMNotificationFileDownload";

NSString * const kEMFileUploadState = @"kEMFileUploadState";
NSString * const kEMFIleUploadProgress = @"kEMFIleUploadProgress";

- (NSMutableDictionary *)responseDic{
    if (!_responseDic) {
        _responseDic = [[NSMutableDictionary alloc]init];
    }
    return _responseDic;
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"POST"]){
        return YES;
    }else if ([method isEqualToString:@"DELETE"]) {
        return YES;
    }else if ([method isEqualToString:@"PUT"]) {
        return YES;
    }else{
        return [super supportsMethod:method atPath:path];
    }
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
        if(![request headerField:@"boundary"])  {
            return NO;
        }
        return YES;
    }
    if ([method isEqualToString:@"DELETE"]) {
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path{
    HTTPLogTrace();
    if ([method isEqualToString:@"GET"]) {
        if ([path isEqualToString:@"/"]) {
            //请求index.html
            
            NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [appInfo objectForKey:@"CFBundleDisplayName"];
            
            NSMutableDictionary *replaceData = [[NSMutableDictionary alloc]init];
            [replaceData setObject:[NSString stringWithFormat:@"%@ - WiFi上传",appName] forKey:@"title"];
            
            for (NSString *fileType in [EM_ChatFileUtils fileTypeArray]) {
                
                NSMutableString *replaceHtml = [[NSMutableString alloc]init];
                NSArray *files = [EM_ChatFileUtils filesInfoWithType:fileType];
                
                for (NSDictionary *fileInfo in files) {
                    NSString *fileName = [fileInfo objectForKey:kFileName];
                    NSDictionary *fileAttributes = [fileInfo objectForKey:kFileAttributes];
                    long long fileSize = [fileAttributes fileSize];
                    
                    NSString *html = [NSString stringWithFormat:@"<tr><td>%@</td><td>%@</td><td><a href=\"%@\" download><i class=\"fa fa-cloud-download\"></i></a><a href=\"javascript:;\"><i class=\"fa fa-trash-o\"></i></a></td></tr>",fileName,[EM_ChatFileUtils stringFileSize:fileSize],[NSString stringWithFormat:@"%@/%@",fileType,fileName]];
                    [replaceHtml appendString:html];
                }
                
                [replaceData setObject:replaceHtml forKey:fileType];
            }
            
            NSString* indexPagePath = [[config documentRoot] stringByAppendingPathComponent:@"index.html"];
            return [[HTTPDynamicFileResponse alloc] initWithFilePath:indexPagePath forConnection:self separator:@"%" replacementDictionary:replaceData];
        }else if([path hasPrefix:@"/image"]||
                 [path hasPrefix:@"/text"] ||
                 [path hasPrefix:@"/video"]||
                 [path hasPrefix:@"/audio"]||
                 [path hasPrefix:@"/ohter"]){
            NSString *filePath = [NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,path];
            return [[HTTPFileResponse alloc]initWithFilePath:filePath forConnection:self];
        }
    }else if([method isEqualToString:@"POST"]){
        if ([path isEqualToString:@"/files"]) {
            NSDictionary *headers = [request allHeaderFields];
            NSString *fileName = [headers objectForKey:@"filename"];
            if (fileName) {
                EM_ChatHttpErrorResponse *response = [self.responseDic objectForKey:fileName];
                if (response) {
                    return response;
                }
            }
            return [[HTTPErrorResponse alloc]initWithErrorCode:200];
            
        }
    }else if([method isEqualToString:@"PUT"]){
        
    }else if([method isEqualToString:@"DELETE"]){
        if([path hasPrefix:@"/files"]){
            NSDictionary *headers = [request allHeaderFields];
            NSString *fileName = [headers objectForKey:@"filename"];
            NSString *fileType = [headers objectForKey:@"filetype"];
            NSError *error;
            BOOL delete = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@",kChatFileFolderPath,fileType,fileName] error:&error];
            if (delete && !error) {
                return [[EM_ChatHttpErrorResponse alloc]initWithErrorCode:200 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_delete_success"]];
            }else{
                return [[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[NSString stringWithFormat:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_delete_failure"],error]];
            }
        }
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
    NSDictionary *headers = [request allHeaderFields];
    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
    
    NSString *fileName = [[disposition.params objectForKey:@"filename"] lastPathComponent];
    if (!fileName || fileName.length == 0) {
        return;
    }
    
    //获取文件大小
    long long fileSize  = [[headers objectForKey:@"Content-Length"] longLongValue];
    if (fileSize > 1024 * 1024 * 10) {
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_big"]] forKey:fileName];
        return;
    }
    
    NSString *fileType = [headers objectForKey:@"filetype"];
    NSString* uploadDirPath = [NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,fileType];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",uploadDirPath,fileName];
    
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        storeFile = nil;
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_exist"]] forKey:fileName];
    }else {
        HTTPLogVerbose(@"Saving file to %@", filePath);
        
        if([[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil]) {
            storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
            NSDictionary *userInfo = @{
                                       kFileName:fileName,
                                       kFileType:fileType,
                                       kFilePath:filePath,
                                       kEMFileUploadState:@(WiFiFileUploadStateStart),
                                       kEMFIleUploadProgress:@(0)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationFileUpload object:nil userInfo:userInfo];
        }else{
            HTTPLogError(@"Could not create file at path: %@", filePath);
            [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:500 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_failure"]] forKey:fileName];
        }
    }
}

- (void)processContent:(NSData *)data WithHeader:(MultipartMessageHeader *)header{
    if(storeFile) {
        [storeFile writeData:data];
        NSDictionary *headers = [request allHeaderFields];
        NSString *fileName = [headers objectForKey:@"filename"];
        NSString *fileType = [headers objectForKey:@"filetype"];
        
        NSDictionary *userInfo = @{
                                   kFileName:fileName,
                                   kFileType:fileType,
                                   kFilePath:[NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,fileType],
                                   kEMFileUploadState:@(WiFiFileUploadStateProcess),
                                   kEMFIleUploadProgress:@(data.length)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationFileUpload object:nil userInfo:userInfo];
    }
}

- (void)processEndOfPartWithHeader:(MultipartMessageHeader *)header{
    if (storeFile) {
        [storeFile closeFile];
        NSDictionary *headers = [request allHeaderFields];
        NSString *fileName = [headers objectForKey:@"filename"];
        NSString *fileType = [headers objectForKey:@"filetype"];
        
        [self.responseDic setObject:[[EM_ChatHttpErrorResponse alloc]initWithErrorCode:200 errorMessage:[EM_ChatResourcesUtils stringWithName:@"wifi.server_file_upload_success"]] forKey:fileName];
        
        NSDictionary *userInfo = @{
                                   kFileName:fileName,
                                   kFileType:fileType,
                                   kFilePath:[NSString stringWithFormat:@"%@/%@",kChatFileFolderPath,fileType],
                                   kEMFileUploadState:@(WiFiFileUploadStateEnd),
                                   kEMFIleUploadProgress:@(0)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kEMNotificationFileUpload object:nil userInfo:userInfo];
        
    }
    storeFile = nil;
}

- (void)processPreambleData:(NSData *)data{
    
}

- (void)processEpilogueData:(NSData *)data{
    
}

@end