//
//  MainController.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/1.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UStylistChatController.h"

@interface UStylistChatController ()<EM_ChatControllerDelegate>

@end

@implementation UStylistChatController


- (void)viewDidLoad {
    self.delegate = self;
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#define mark - EM_ChatControllerDelegate
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return nil;
}

- (NSString *)avatarWithChatter:(NSString *)chatter{
    return nil;
}

- (NSDictionary *)extendForMessageBody:(id<IEMMessageBody>)messageBody{
    return @{@"extend":@"extend"};
}

- (BOOL)showForExtendMessage:(NSDictionary *)ext{
    return YES;
}

- (NSString *)reuseIdentifierForExtendMessage:(NSDictionary *)ext{
    return @"extend";
}

- (CGSize)sizeForExtendMessage:(NSDictionary *)ext maxWidth:(CGFloat)max{
    return CGSizeMake(100, 30);
}

- (UIView *)viewForExtendMessage:(NSDictionary *)ext reuseView:(UIView *)view{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"extend";
    }
    return label;
}

- (void)didActionSelectedWithName:(NSString *)name{
    
}

@end