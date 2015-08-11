//
//  EM+ChatWifiView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/10.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatWifiView.h"
#import "HTTPServer.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@interface EM_ChatWifiView()

@property (nonatomic, strong) HTTPServer *httpServer;

@end

@implementation EM_ChatWifiView{
    UILabel *titleLabel;
    UILabel *hintLabel;
    UILabel *iconLabel;
    UILabel *actionHintLabel;
    UILabel *serveAddressLabel;
    UIButton *closeButton;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"WIFI服务已开启";
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        hintLabel = [[UILabel alloc]init];
        hintLabel.text = @"上传过程中请勿离开此页或锁屏";
        hintLabel.textColor = [UIColor blueColor];
        [hintLabel sizeToFit];
        [self addSubview:hintLabel];
        
        iconLabel = [[UILabel alloc]init];
        iconLabel.bounds = CGRectMake(0, 0, 60, 60);
        [self addSubview:iconLabel];
        
        actionHintLabel = [[UILabel alloc]init];
        actionHintLabel.text = @"在电脑浏览器地址栏中输入";
        actionHintLabel.textColor = [UIColor blackColor];
        [actionHintLabel sizeToFit];
        [self addSubview:actionHintLabel];
        
        serveAddressLabel = [[UILabel alloc]init];
        serveAddressLabel.textColor = [UIColor blackColor];
        [self addSubview:serveAddressLabel];
        
        closeButton = [[UIButton alloc]init];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton sizeToFit];
        [self addSubview:closeButton];
        
        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"EM_Web.bundle"];
        
        NSLog(@"webPath - %@",webPath);
        
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setType:@"_http._tcp."];
        [_httpServer setPort:8080];
        [_httpServer setName:@"EaseMobUI"];
        [_httpServer setDocumentRoot:webPath];
        [_httpServer start:nil];
        
        serveAddressLabel.text = [NSString stringWithFormat:@"http://%@:%d",[self deviceIPAdress],_httpServer.port];
        [serveAddressLabel sizeToFit];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    titleLabel.center = CGPointMake(size.width / 2, titleLabel.bounds.size.height / 2);
    hintLabel.center = CGPointMake(size.width / 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + hintLabel.frame.size.height / 2);
    iconLabel.center = CGPointMake(size.width / 2, titleLabel.frame.origin.y + titleLabel.bounds.size.height + iconLabel.bounds.size.height / 2);
    
    actionHintLabel.center = CGPointMake(size.width / 2, iconLabel.frame.origin.y + iconLabel.frame.size.height + actionHintLabel.frame.size.height / 2);
    serveAddressLabel.center = CGPointMake(size.width / 2, actionHintLabel.frame.origin.y + actionHintLabel.frame.size.height + serveAddressLabel.frame.size.height / 2);
    
    closeButton.center = CGPointMake(size.width / 2, serveAddressLabel.frame.origin.y + serveAddressLabel.frame.size.height + closeButton.frame.size.height / 2);
}

- (CGFloat)contentHeight{
    return titleLabel.frame.size.height + hintLabel.frame.size.height + iconLabel.frame.size.height + actionHintLabel.frame.size.height + serveAddressLabel.frame.size.height +  closeButton.frame.size.height;
}

- (void)completion{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)dismiss{
    [super dismiss];
    [_httpServer stop];
}

- (void)close:(id)sender{
    [self dismiss];
}

- (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    return address;  
}

@end